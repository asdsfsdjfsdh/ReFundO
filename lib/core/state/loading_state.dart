import 'package:flutter/foundation.dart';
import 'dart:async';

/// 加载状态
enum LoadingStatus {
  idle,       // 空闲
  loading,    // 加载中
  success,    // 成功
  error,      // 错误
  empty,      // 空数据
}

/// 加载状态数据
class LoadingState<T> {
  final LoadingStatus status;
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  const LoadingState({
    required this.status,
    this.data,
    this.errorMessage,
    this.statusCode,
  });

  /// 空闲状态
  const LoadingState.idle()
      : status = LoadingStatus.idle,
        data = null,
        errorMessage = null,
        statusCode = null;

  /// 加载状态
  const LoadingState.loading()
      : status = LoadingStatus.loading,
        data = null,
        errorMessage = null,
        statusCode = null;

  /// 成功状态
  const LoadingState.success(T data)
      : status = LoadingStatus.success,
        data = data,
        errorMessage = null,
        statusCode = null;

  /// 错误状态
  const LoadingState.error(String message, {int? statusCode})
      : status = LoadingStatus.error,
        errorMessage = message,
        statusCode = statusCode,
        data = null;

  /// 空数据状态
  const LoadingState.empty()
      : status = LoadingStatus.empty,
        data = null,
        errorMessage = null,
        statusCode = null;

  /// 便捷 getters
  bool get isIdle => status == LoadingStatus.idle;
  bool get isLoading => status == LoadingStatus.loading;
  bool get isSuccess => status == LoadingStatus.success;
  bool get isError => status == LoadingStatus.error;
  bool get isEmpty => status == LoadingStatus.empty;

  /// 是否有数据
  bool get hasData => data != null;

  /// 复制并修改部分属性
  LoadingState<T> copyWith({
    LoadingStatus? status,
    T? data,
    String? errorMessage,
    int? statusCode,
  }) {
    return LoadingState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }

  /// 映射数据类型
  LoadingState<R> map<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      try {
        return LoadingState<R>.success(mapper(data as T));
      } catch (e) {
        return LoadingState<R>.error('数据转换失败: $e');
      }
    }
    return LoadingState<R>(
      status: status,
      errorMessage: errorMessage,
      statusCode: statusCode,
    );
  }

  @override
  String toString() {
    return 'LoadingState(status: $status, data: $data, error: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoadingState<T> &&
        other.status == status &&
        other.data == data &&
        other.errorMessage == errorMessage &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        data.hashCode ^
        errorMessage.hashCode ^
        statusCode.hashCode;
  }
}

/// 统一的加载状态管理器
class LoadingStateManager extends ChangeNotifier {
  LoadingState _state = const LoadingState.idle();

  LoadingState get state => _state;

  bool get isLoading => _state.isLoading;
  bool get isSuccess => _state.isSuccess;
  bool get isError => _state.isError;
  bool get isEmpty => _state.isEmpty;
  bool get hasData => _state.hasData;

  /// 设置状态并通知监听器
  void _setState(LoadingState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// 开始加载
  void setLoading() {
    _setState(const LoadingState.loading());
  }

  /// 设置成功
  void setData(dynamic data) {
    if (data == null || (data is List && data.isEmpty)) {
      _setState(const LoadingState.empty());
    } else {
      _setState(LoadingState.success(data));
    }
  }

  /// 设置错误
  void setError(String message, {int? statusCode}) {
    _setState(LoadingState.error(message, statusCode: statusCode));
  }

  /// 设置空数据
  void setEmpty() {
    _setState(const LoadingState.empty());
  }

  /// 重置状态
  void reset() {
    _setState(const LoadingState.idle());
  }

  /// 执行异步操作（自动管理状态）
  Future<T?> execute<T>(
    Future<T> Function() operation, {
    bool showEmptyOnNull = true,
  }) async {
    try {
      setLoading();
      final result = await operation();
      setData(result);
      return result;
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }

  /// 刷新数据
  Future<T?> refresh<T>(Future<T> Function() operation) {
    reset();
    return execute(operation);
  }
}

/// 异步操作基类
/// 提供 try-catch 包装和自动状态管理
abstract class AsyncViewModel extends ChangeNotifier {
  final LoadingStateManager _loadingManager = LoadingStateManager();

  LoadingState get state => _loadingManager.state;
  bool get isLoading => _loadingManager.isLoading;
  bool get isSuccess => _loadingManager.isSuccess;
  bool get isError => _loadingManager.isError;
  bool get hasData => _loadingManager.hasData;

  /// 执行异步操作
  Future<T?> execute<T>(Future<T> Function() operation) async {
    return _loadingManager.execute(operation);
  }

  /// 安全地更新状态
  void updateState(LoadingState newState) {
    _loadingManager._setState(newState);
  }

  /// 设置加载状态
  void setLoading() {
    _loadingManager.setLoading();
  }

  /// 设置错误
  void setError(String message, {int? statusCode}) {
    _loadingManager.setError(message, statusCode: statusCode);
  }

  /// 重置状态
  void reset() {
    _loadingManager.reset();
  }

  @override
  void dispose() {
    _loadingManager.dispose();
    super.dispose();
  }
}

/// 异步操作队列
/// 用于管理多个并发或串行的异步操作
class AsyncOperationQueue {
  final List<Future<dynamic> Function()> _operations = [];
  final int maxConcurrent;

  bool _isExecuting = false;
  final StreamController<QueueProgress> _progressController =
      StreamController.broadcast();

  AsyncOperationQueue({this.maxConcurrent = 3});

  Stream<QueueProgress> get progressStream => _progressController.stream;

  /// 添加操作
  void addOperation(Future<dynamic> Function() operation) {
    _operations.add(operation);
  }

  /// 执行所有操作
  Future<List<dynamic>> executeAll() async {
    if (_isExecuting) {
      throw StateError('队列正在执行中');
    }

    _isExecuting = true;
    final results = <dynamic>[];

    try {
      for (int i = 0; i < _operations.length; i += maxConcurrent) {
        final end =
            (i + maxConcurrent < _operations.length) ? i + maxConcurrent : _operations.length;
        final batch = _operations.sublist(i, end);

        // 并发执行批次
        final batchResults = await Future.wait(
          batch.map((op) => op()),
          eagerError: false,
        );

        results.addAll(batchResults);

        // 报告进度
        _progressController.add(QueueProgress(
          completed: i + batch.length,
          total: _operations.length,
        ));
      }

      return results;
    } finally {
      _isExecuting = false;
      _operations.clear();
    }
  }

  /// 清空队列
  void clear() {
    _operations.clear();
  }

  void dispose() {
    _progressController.close();
  }
}

/// 队列进度
class QueueProgress {
  final int completed;
  final int total;

  QueueProgress({required this.completed, required this.total});

  double get progress => total > 0 ? completed / total : 0;
  int get remaining => total - completed;

  @override
  String toString() {
    return 'QueueProgress: $completed/$total (${(progress * 100).toStringAsFixed(1)}%)';
  }
}

/// 防抖和节流工具
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class Throttler {
  final Duration delay;
  DateTime? _lastActionTime;

  Throttler({required this.delay});

  void call(VoidCallback action) {
    final now = DateTime.now();
    if (_lastActionTime == null ||
        now.difference(_lastActionTime!) >= delay) {
      _lastActionTime = now;
      action();
    }
  }
}

/// 未来扩展：可以添加重试机制、缓存等功能
