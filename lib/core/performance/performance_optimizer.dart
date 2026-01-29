import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:refundo/core/utils/log_util.dart';

/// 性能监控级别
enum PerformanceLevel {
  excellent, // 优秀：操作在16ms内完成
  good,      // 良好：操作在16-33ms内完成
  fair,      // 一般：操作在33-100ms内完成
  poor,      // 较差：操作在100-500ms内完成
  bad,       // 很差：操作超过500ms
}

/// 性能统计数据
class PerformanceMetrics {
  final String operation;
  final int durationMs;
  final DateTime timestamp;
  final PerformanceLevel level;

  PerformanceMetrics({
    required this.operation,
    required this.durationMs,
    required this.timestamp,
    required this.level,
  });

  @override
  String toString() {
    return '$operation: ${durationMs}ms (${level.name})';
  }
}

/// 增强的性能优化工具类
class PerformanceOptimizer {
  static PerformanceOptimizer? _instance;
  static PerformanceOptimizer get instance => _instance ??= PerformanceOptimizer._();

  PerformanceOptimizer._() {
    if (kDebugMode) {
      _startFrameMonitoring();
    }
  }

  // 性能数据收集
  final List<PerformanceMetrics> _metrics = [];
  final List<FrameTiming> _frameTimings = [];

  // 性能统计
  int _totalOperations = 0;
  int _slowOperations = 0; // 超过33ms的操作
  int _verySlowOperations = 0; // 超过100ms的操作

  /// 获取性能等级
  static PerformanceLevel getPerformanceLevel(int durationMs) {
    if (durationMs < 16) return PerformanceLevel.excellent;
    if (durationMs < 33) return PerformanceLevel.good;
    if (durationMs < 100) return PerformanceLevel.fair;
    if (durationMs < 500) return PerformanceLevel.poor;
    return PerformanceLevel.bad;
  }

  /// 性能监控 - 记录方法执行时间
  static Future<T> measure<T>(
    String operation,
    Future<T> Function() fn, {
    String? tag,
  }) async {
    if (!kDebugMode) return await fn();

    final stopwatch = Stopwatch()..start();
    try {
      final result = await fn();
      stopwatch.stop();

      instance._recordMetrics(
        operation,
        stopwatch.elapsedMilliseconds,
      );

      return result;
    } catch (e) {
      stopwatch.stop();
      LogUtil.e(tag ?? 'Performance', '$operation 失败: $e');
      rethrow;
    }
  }

  /// 同步方法的性能监控
  static T measureSync<T>(
    String operation,
    T Function() fn, {
    String? tag,
  }) {
    if (!kDebugMode) return fn();

    final stopwatch = Stopwatch()..start();
    try {
      final result = fn();
      stopwatch.stop();

      instance._recordMetrics(
        operation,
        stopwatch.elapsedMilliseconds,
      );

      return result;
    } catch (e) {
      stopwatch.stop();
      LogUtil.e(tag ?? 'Performance', '$operation 失败: $e');
      rethrow;
    }
  }

  /// 记录性能指标
  void _recordMetrics(String operation, int durationMs) {
    final level = getPerformanceLevel(durationMs);
    final metrics = PerformanceMetrics(
      operation: operation,
      durationMs: durationMs,
      timestamp: DateTime.now(),
      level: level,
    );

    _metrics.add(metrics);
    _totalOperations++;

    if (durationMs > 33) _slowOperations++;
    if (durationMs > 100) _verySlowOperations++;

    // 根据性能等级输出不同级别的日志
    switch (level) {
      case PerformanceLevel.bad:
        LogUtil.e('Performance', metrics.toString());
        break;
      case PerformanceLevel.poor:
        LogUtil.w('Performance', metrics.toString());
        break;
      default:
        LogUtil.d('Performance', metrics.toString());
    }
  }

  /// 启动帧监控
  void _startFrameMonitoring() {
    SchedulerBinding.instance.addTimingsCallback((timings) {
      _frameTimings.addAll(timings);

      // 只保留最近1000帧的数据
      if (_frameTimings.length > 1000) {
        _frameTimings.removeRange(0, _frameTimings.length - 1000);
      }

      // 检测慢帧
      for (final timing in timings) {
        // 计算帧的总时长（使用 totalSpan，如果不可用则估算）
        // FrameTiming.totalSpan 返回 Duration，包含 build 和 raster 时间
        final duration = timing.totalSpan.inMicroseconds / 1000;
        if (duration > 16) {
          LogUtil.w('FrameTiming', '慢帧检测: ${duration.toStringAsFixed(2)}ms');
        }
      }
    });
  }

  /// 获取性能统计报告
  Map<String, dynamic> getPerformanceReport() {
    if (_metrics.isEmpty) return {};

    final avgDuration = _metrics
        .map((m) => m.durationMs)
        .reduce((a, b) => a + b) / _metrics.length;

    final maxDuration = _metrics
        .map((m) => m.durationMs)
        .reduce((a, b) => a > b ? a : b);

    final minDuration = _metrics
        .map((m) => m.durationMs)
        .reduce((a, b) => a < b ? a : b);

    final slowOperationsCount = _metrics.where((m) => m.level.index >= 3).length;

    return {
      'totalOperations': _totalOperations,
      'avgDuration': '${avgDuration.toStringAsFixed(2)}ms',
      'maxDuration': '${maxDuration}ms',
      'minDuration': '${minDuration}ms',
      'slowOperations': slowOperationsCount,
      'slowOperationsRate': '${(slowOperationsCount / _totalOperations * 100).toStringAsFixed(2)}%',
    };
  }

  /// 打印性能报告
  void printPerformanceReport() {
    if (!kDebugMode) return;

    final report = getPerformanceReport();
    if (report.isEmpty) {
      LogUtil.i('Performance', '暂无性能数据');
      return;
    }

    LogUtil.i('Performance', '========== 性能报告 ==========');
    report.forEach((key, value) {
      LogUtil.i('Performance', '$key: $value');
    });

    // 打印最慢的5个操作
    final slowestOperations = _metrics.toList()
      ..sort((a, b) => b.durationMs.compareTo(a.durationMs));

    LogUtil.i('Performance', '========== 最慢的操作 ==========');
    for (var i = 0; i < (slowestOperations.length > 5 ? 5 : slowestOperations.length); i++) {
      LogUtil.i('Performance', '${i + 1}. ${slowestOperations[i]}');
    }
    LogUtil.i('Performance', '================================');
  }

  /// 清除性能数据
  void clearMetrics() {
    _metrics.clear();
    _frameTimings.clear();
    _totalOperations = 0;
    _slowOperations = 0;
    _verySlowOperations = 0;
    LogUtil.i('Performance', '性能数据已清除');
  }

  /// 内存使用警告
  static void checkMemoryUsage(String tag) {
    if (!kDebugMode) return;
    LogUtil.d(tag, '内存使用检查');
  }

  /// 网络请求优化建议
  static void suggestNetworkOptimizations(String tag, int requestCount) {
    if (!kDebugMode) return;
    if (requestCount > 10) {
      LogUtil.w(tag, '检测到大量网络请求($requestCount)，建议使用批量请求或缓存');
    }
  }

  /// 列表渲染优化建议
  static void suggestListOptimizations(String tag, int itemCount) {
    if (!kDebugMode) return;
    if (itemCount > 100) {
      LogUtil.w(tag, '列表项过多($itemCount)，建议使用分页或虚拟滚动');
    }
  }

  /// 图片加载优化
  static String getOptimizedImageUrl(String originalUrl, {
    int? width,
    int? height,
    int quality = 80,
  }) {
    // 这里可以添加图片优化逻辑，如添加尺寸参数等
    return originalUrl;
  }

  /// 缓存策略建议
  static Duration getCacheDuration(String dataType) {
    switch (dataType) {
      case 'user_info':
        return const Duration(minutes: 5);
      case 'orders':
        return const Duration(minutes: 2);
      case 'refunds':
        return const Duration(minutes: 3);
      default:
        return const Duration(minutes: 1);
    }
  }

  /// 分析操作是否需要优化
  static bool needsOptimization(int durationMs) {
    return durationMs > 33; // 超过2帧时间
  }

  /// 获取优化建议
  static String getOptimizationSuggestion(int durationMs) {
    if (durationMs < 16) {
      return '性能优秀，无需优化';
    } else if (durationMs < 33) {
      return '性能良好，可考虑优化';
    } else if (durationMs < 100) {
      return '建议优化：考虑使用缓存、异步处理或减少计算量';
    } else if (durationMs < 500) {
      return '需要优化：建议使用后台线程、分页加载或懒加载';
    } else {
      return '严重性能问题：必须优化，使用异步处理、数据库索引、批量操作等';
    }
  }
}
