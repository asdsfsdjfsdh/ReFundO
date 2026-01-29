import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:refundo/core/utils/storage/offline_order_storage.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/data/models/Product_model.dart';

/// 离线订单同步服务
/// 当网络恢复时自动同步离线订单到服务器
class OfflineSyncService {
  static OfflineSyncService? _instance;
  static OfflineSyncService get instance => _instance ??= OfflineSyncService._();

  OfflineSyncService._() {
    _initializeSync();
  }

  final ApiOrderService _orderService = ApiOrderService();
  bool _isSyncing = false;
  bool _hasNetwork = true;
  StreamSubscription? _networkSubscription;
  final List<Map<String, dynamic>> _failedOrders = [];

  /// 初始化网络监听
  void _initializeSync() {
    // 网络监听将在NetworkMonitor中实现
    // 这里只提供同步方法
  }

  /// 设置网络状态
  void setNetworkStatus(bool hasNetwork) {
    _hasNetwork = hasNetwork;
    if (hasNetwork && !_isSyncing) {
      syncOfflineOrders();
    }
  }

  /// 同步离线订单
  /// 返回同步成功/失败的订单数量
  Future<Map<String, int>> syncOfflineOrders() async {
    if (_isSyncing) {
      return {'success': 0, 'failed': 0};
    }

    _isSyncing = true;

    int successCount = 0;
    int failedCount = 0;

    try {
      // 获取所有离线订单
      List<Map<String, dynamic>> offlineOrders = await OfflineOrderStorage.getOfflineOrders();

      if (offlineOrders.isEmpty) {
        if (kDebugMode) {
          print('没有离线订单需要同步');
        }
        return {'success': 0, 'failed': 0};
      }

      if (kDebugMode) {
        print('开始同步 ${offlineOrders.length} 条离线订单');
      }

      // 同步每一条订单
      List<Map<String, dynamic>> syncedOrders = [];
      for (var orderData in offlineOrders) {
        try {
          // 提取产品信息
          final productData = orderData['product'] as Map<String, dynamic>;
          final ProductModel product = ProductModel.fromJson(productData);

          // 发送到服务器（这里需要context，所以需要特殊处理）
          // 由于ApiOrderService需要context，我们需要外部调用syncSingleOrder
          // 这里只做标记，实际同步在外部处理
          syncedOrders.add(orderData);
        } catch (e) {
          if (kDebugMode) {
            print('解析离线订单失败: $e');
          }
          failedCount++;
        }
      }

      return {
        'success': successCount,
        'failed': failedCount,
        'pending': syncedOrders.length,
      };
    } catch (e) {
      if (kDebugMode) {
        print('同步离线订单失败: $e');
      }
      return {'success': 0, 'failed': 0};
    } finally {
      _isSyncing = false;
    }
  }

  /// 获取待同步的离线订单
  Future<List<Map<String, dynamic>>> getPendingOrders() async {
    return await OfflineOrderStorage.getOfflineOrders();
  }

  /// 获取离线订单数量
  Future<int> getPendingOrderCount() async {
    return await OfflineOrderStorage.getOfflineOrderCount();
  }

  /// 标记订单同步成功
  Future<void> markOrderSynced(Map<String, dynamic> order) async {
    await OfflineOrderStorage.removeOfflineOrder(order);
  }

  /// 标记多个订单同步成功
  Future<void> markOrdersSynced(List<Map<String, dynamic>> orders) async {
    await OfflineOrderStorage.removeOfflineOrders(orders);
  }

  /// 清空所有离线订单
  Future<void> clearOfflineOrders() async {
    await OfflineOrderStorage.clearOfflineOrders();
  }
}
