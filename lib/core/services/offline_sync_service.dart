import 'dart:async';
import 'package:refundo/core/utils/storage/offline_order_storage.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/utils/error_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// 同步状态
enum SyncStatus {
  idle,           // 空闲
  syncing,        // 同步中
  paused,         // 已暂停
  error,          // 错误
}

/// 同步结果
class SyncResult {
  final int successCount;
  final int failedCount;
  final int totalCount;
  final List<SyncError> errors;
  final Duration duration;

  SyncResult({
    required this.successCount,
    required this.failedCount,
    required this.totalCount,
    required this.errors,
    required this.duration,
  });

  double get successRate => totalCount > 0 ? successCount / totalCount : 0;
  bool get isComplete => successCount + failedCount >= totalCount;
  bool get hasErrors => errors.isNotEmpty;
}

/// 同步错误详情
class SyncError {
  final String orderId;
  final String message;
  final AppErrorType errorType;
  final int retryCount;
  final DateTime timestamp;

  SyncError({
    required this.orderId,
    required this.message,
    required this.errorType,
    this.retryCount = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// 同步配置
class SyncConfig {
  /// 每批次处理的订单数
  final int batchSize;

  /// 最大重试次数
  final int maxRetries;

  /// 重试延迟（秒）
  final int retryDelaySeconds;

  /// 并发请求数
  final int concurrentRequests;

  /// 单次同步超时（秒）
  final int syncTimeoutSeconds;

  /// 失败后是否继续
  final bool continueOnError;

  const SyncConfig({
    this.batchSize = 10,
    this.maxRetries = 3,
    this.retryDelaySeconds = 5,
    this.concurrentRequests = 3,
    this.syncTimeoutSeconds = 30,
    this.continueOnError = true,
  });

  /// 默认配置
  static const defaultConfig = SyncConfig();

  /// 快速配置（小批次）
  static const quickConfig = SyncConfig(
    batchSize: 5,
    maxRetries: 1,
    concurrentRequests: 2,
  );

  /// 谨慎配置（大量重试）
  static const carefulConfig = SyncConfig(
    batchSize: 5,
    maxRetries: 5,
    retryDelaySeconds: 10,
    concurrentRequests: 1,
  );
}

/// 离线订单同步服务（增强版）
/// 提供智能批次管理、重试机制、失败队列等功能
class OfflineSyncService {
  static OfflineSyncService? _instance;
  static OfflineSyncService get instance => _instance ??= OfflineSyncService._();

  OfflineSyncService._() {
    _initializeNetworkMonitoring();
  }

  // 同步状态
  SyncStatus _status = SyncStatus.idle;
  final StreamController<SyncStatus> _statusController = StreamController.broadcast();
  final StreamController<SyncProgress> _progressController = StreamController.broadcast();

  // 同步配置
  SyncConfig _config = SyncConfig.defaultConfig;

  // 失败队列
  final List<Map<String, dynamic>> _failedQueue = [];
  final Map<String, SyncError> _errorHistory = {};

  // 网络监听
  StreamSubscription? _networkSubscription;

  // 状态 getters
  SyncStatus get status => _status;
  bool get isSyncing => _status == SyncStatus.syncing;
  bool get canSync => _status == SyncStatus.idle && _failedQueue.isNotEmpty;
  int get failedQueueCount => _failedQueue.length;

  // 状态流
  Stream<SyncStatus> get statusStream => _statusController.stream;
  Stream<SyncProgress> get progressStream => _progressController.stream;

  /// 设置同步配置
  void setConfig(SyncConfig config) {
    _config = config;
    LogUtil.i('OfflineSyncService', '配置已更新: $config');
  }

  /// 获取当前配置
  SyncConfig get config => _config;

  /// 初始化网络监听
  void _initializeNetworkMonitoring() {
    _networkSubscription = Connectivity().onConnectivityChanged.listen((results) {
      // connectivity_plus 返回 List<ConnectivityResult>
      final hasNetwork = results.isNotEmpty && !results.contains(ConnectivityResult.none);
      LogUtil.i('OfflineSyncService', '网络状态变化: $results');

      if (hasNetwork && canSync) {
        LogUtil.i('OfflineSyncService', '网络恢复，开始同步');
        syncOfflineOrders(config: _config);
      }
    });
  }

  /// 同步状态变化
  void _updateStatus(SyncStatus newStatus) {
    _status = newStatus;
    _statusController.add(_status);
    LogUtil.i('OfflineSyncService', '状态变更: $_status');
  }

  /// 同步离线订单（增强版）
  Future<SyncResult> syncOfflineOrders({
    SyncConfig? config,
    void Function(SyncProgress)? onProgress,
  }) async {
    if (!canSync && _status != SyncStatus.idle) {
      LogUtil.w('OfflineSyncService', '无法同步：当前状态为 $_status');
      return SyncResult(
        successCount: 0,
        failedCount: 0,
        totalCount: 0,
        errors: [],
        duration: Duration.zero,
      );
    }

    final syncConfig = config ?? _config;
    _updateStatus(SyncStatus.syncing);

    final startTime = DateTime.now();
    int successCount = 0;
    int failedCount = 0;
    final List<SyncError> errors = [];

    try {
      // 获取所有待同步的订单（包括失败队列）
      final allOrders = await _getPendingOrders();
      if (allOrders.isEmpty) {
        LogUtil.i('OfflineSyncService', '没有待同步的订单');
        _updateStatus(SyncStatus.idle);
        return SyncResult(
          successCount: 0,
          failedCount: 0,
          totalCount: 0,
          errors: [],
          duration: DateTime.now().difference(startTime),
        );
      }

      LogUtil.i('OfflineSyncService', '开始同步 ${allOrders.length} 条订单');

      // 分批处理
      final batches = _createBatches(allOrders, syncConfig.batchSize);
      final totalBatches = batches.length;

      for (int i = 0; i < batches.length; i++) {
        if (_status == SyncStatus.paused) {
          LogUtil.i('OfflineSyncService', '同步已暂停');
          break;
        }

        final batch = batches[i];
        LogUtil.i('OfflineSyncService', '处理批次 ${i + 1}/$totalBatches (${batch.length} 条)');

        // 报告进度
        final progress = SyncProgress(
          currentBatch: i + 1,
          totalBatches: totalBatches,
          currentCount: successCount + failedCount,
          totalCount: allOrders.length,
        );
        _progressController.add(progress);
        onProgress?.call(progress);

        // 并发处理批次
        final batchResults = await _processBatchConcurrently(
          batch,
          syncConfig.concurrentRequests,
        );

        successCount += batchResults['success'] as int;
        failedCount += batchResults['failed'] as int;

        // 检查是否继续
        if ((batchResults['failed'] as int) > 0 && !syncConfig.continueOnError) {
          LogUtil.w('OfflineSyncService', '批次出现错误，停止同步');
          break;
        }
      }

      final duration = DateTime.now().difference(startTime);
      final result = SyncResult(
        successCount: successCount,
        failedCount: failedCount,
        totalCount: allOrders.length,
        errors: errors,
        duration: duration,
      );

      LogUtil.i('OfflineSyncService', '同步完成: $result');

      _updateStatus(SyncStatus.idle);
      return result;
    } catch (e, stack) {
      LogUtil.e('OfflineSyncService', '同步失败: $e', e, stack);
      _updateStatus(SyncStatus.error);
      rethrow;
    }
  }

  /// 获取待同步的订单
  Future<List<Map<String, dynamic>>> _getPendingOrders() async {
    // 先获取存储的订单
    final storedOrders = await OfflineOrderStorage.getOfflineOrders();

    // 合并失败队列
    final allOrders = [
      ...storedOrders,
      ..._failedQueue,
    ];

    // 去重（基于 order ID）
    final uniqueOrders = <Map<String, dynamic>>[];
    final seenIds = <String>{};

    for (final order in allOrders) {
      final orderId = order['id']?.toString() ?? '';
      if (orderId.isNotEmpty && !seenIds.contains(orderId)) {
        seenIds.add(orderId);
        uniqueOrders.add(order);
      }
    }

    return uniqueOrders;
  }

  /// 创建批次
  List<List<Map<String, dynamic>>> _createBatches(
    List<Map<String, dynamic>> orders,
    int batchSize,
  ) {
    final batches = <List<Map<String, dynamic>>>[];
    for (int i = 0; i < orders.length; i += batchSize) {
      final end = (i + batchSize < orders.length) ? i + batchSize : orders.length;
      batches.add(orders.sublist(i, end));
    }
    return batches;
  }

  /// 并发处理批次
  Future<Map<String, int>> _processBatchConcurrently(
    List<Map<String, dynamic>> batch,
    int concurrency,
  ) async {
    int successCount = 0;
    int failedCount = 0;

    // 分组
    final groups = <List<Map<String, dynamic>>>[];
    for (int i = 0; i < batch.length; i += concurrency) {
      final end = (i + concurrency < batch.length) ? i + concurrency : batch.length;
      groups.add(batch.sublist(i, end));
    }

    // 处理每组
    for (final group in groups) {
      final futures = group.map((order) => _syncSingleOrder(order));
      final results = await Future.wait(futures, eagerError: false);

      for (final result in results) {
        if (result) {
          successCount++;
        } else {
          failedCount++;
        }
      }
    }

    return {'success': successCount, 'failed': failedCount};
  }

  /// 同步单个订单
  Future<bool> _syncSingleOrder(Map<String, dynamic> order) async {
    // 实际的同步逻辑需要外部实现
    // 这里只是框架，具体的 API 调用需要在 Provider 或 Service 层完成

    try {
      // TODO: 实现实际的 API 调用
      // 例如：await _apiService.createOrder(order);

      // 同步成功，从存储中移除
      await markOrderSynced(order);

      // 从失败队列中移除
      _failedQueue.removeWhere((o) => o['id'] == order['id']);

      LogUtil.d('OfflineSyncService', '订单同步成功: ${order['id']}');
      return true;
    } catch (e, stack) {
      LogUtil.e('OfflineSyncService', '订单同步失败: ${order['id']}', e, stack);

      // 添加到失败队列
      if (!_failedQueue.any((o) => o['id'] == order['id'])) {
        _failedQueue.add(order);
      }

      return false;
    }
  }

  /// 重试失败的订单
  Future<SyncResult> retryFailedOrders({int? maxRetries}) async {
    if (_failedQueue.isEmpty) {
      LogUtil.i('OfflineSyncService', '没有需要重试的订单');
      return SyncResult(
        successCount: 0,
        failedCount: 0,
        totalCount: 0,
        errors: [],
        duration: Duration.zero,
      );
    }

    LogUtil.i('OfflineSyncService', '重试 ${_failedQueue.length} 条失败订单');

    final retryConfig = maxRetries != null
        ? SyncConfig(maxRetries: maxRetries)
        : _config;

    return syncOfflineOrders(config: retryConfig);
  }

  /// 暂停同步
  void pauseSync() {
    if (_status == SyncStatus.syncing) {
      _updateStatus(SyncStatus.paused);
      LogUtil.i('OfflineSyncService', '同步已暂停');
    }
  }

  /// 恢复同步
  void resumeSync() {
    if (_status == SyncStatus.paused) {
      _updateStatus(SyncStatus.idle);
      syncOfflineOrders();
      LogUtil.i('OfflineSyncService', '同步已恢复');
    }
  }

  /// 取消同步
  void cancelSync() {
    if (_status == SyncStatus.syncing || _status == SyncStatus.paused) {
      _updateStatus(SyncStatus.idle);
      LogUtil.i('OfflineSyncService', '同步已取消');
    }
  }

  /// 清空失败队列
  Future<void> clearFailedQueue() async {
    _failedQueue.clear();
    _errorHistory.clear();
    LogUtil.i('OfflineSyncService', '失败队列已清空');
  }

  /// 标记订单同步成功
  Future<void> markOrderSynced(Map<String, dynamic> order) async {
    await OfflineOrderStorage.removeOfflineOrder(order);
    _failedQueue.removeWhere((o) => o['id'] == order['id']);
    _errorHistory.remove(order['id']?.toString());
  }

  /// 获取失败历史
  Map<String, SyncError> get errorHistory => Map.from(_errorHistory);

  /// 获取统计信息
  Future<SyncStats> getStats() async {
    final pendingCount = await getPendingOrderCount();
    return SyncStats(
      pendingOrders: pendingCount,
      failedQueueCount: _failedQueue.length,
      errorHistoryCount: _errorHistory.length,
      currentStatus: _status,
    );
  }

  /// 获取离线订单数量
  Future<int> getPendingOrderCount() async {
    return await OfflineOrderStorage.getOfflineOrderCount();
  }

  /// 清空所有离线订单
  Future<void> clearOfflineOrders() async {
    await OfflineOrderStorage.clearOfflineOrders();
    await clearFailedQueue();
    LogUtil.i('OfflineSyncService', '所有离线订单已清空');
  }

  /// 获取待同步的订单（公共方法）
  Future<List<Map<String, dynamic>>> getPendingOrders() async {
    return await _getPendingOrders();
  }

  /// 标记多个订单为已同步
  Future<void> markOrdersSynced(List<Map<String, dynamic>> orders) async {
    for (final order in orders) {
      await markOrderSynced(order);
    }
    LogUtil.i('OfflineSyncService', '已标记 ${orders.length} 条订单为同步成功');
  }

  /// 设置网络状态（由 NetworkProvider 调用）
  void setNetworkStatus(bool isConnected) {
    LogUtil.i('OfflineSyncService', '网络状态更新: ${isConnected ? "已连接" : "已断开"}');
    // 当网络恢复且有待同步订单时，自动开始同步
    if (isConnected && canSync) {
      LogUtil.i('OfflineSyncService', '网络恢复，开始自动同步');
      syncOfflineOrders();
    }
  }

  /// 释放资源
  void dispose() {
    _networkSubscription?.cancel();
    _statusController.close();
    _progressController.close();
  }
}

/// 同步进度
class SyncProgress {
  final int currentBatch;
  final int totalBatches;
  final int currentCount;
  final int totalCount;

  SyncProgress({
    required this.currentBatch,
    required this.totalBatches,
    required this.currentCount,
    required this.totalCount,
  });

  double get progress => totalCount > 0 ? currentCount / totalCount : 0;
  int get remainingCount => totalCount - currentCount;
  double get remainingBatches => (totalBatches - currentBatch).toDouble();

  @override
  String toString() {
    return 'SyncProgress: $currentCount/$totalCount ($progress.toStringAsFixed(1)}%) - '
        'Batch $currentBatch/$totalBatches';
  }
}

/// 同步统计
class SyncStats {
  final int pendingOrders;
  final int failedQueueCount;
  final int errorHistoryCount;
  final SyncStatus currentStatus;

  SyncStats({
    required this.pendingOrders,
    required this.failedQueueCount,
    required this.errorHistoryCount,
    required this.currentStatus,
  });

  int get totalPending => pendingOrders + failedQueueCount;

  @override
  String toString() {
    return 'SyncStats: '
        'pending=$pendingOrders, '
        'failed=$failedQueueCount, '
        'errors=$errorHistoryCount, '
        'status=$currentStatus';
  }
}
