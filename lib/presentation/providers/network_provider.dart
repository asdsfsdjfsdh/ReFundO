import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:refundo/core/services/offline_sync_service.dart';

/// 网络状态Provider
/// 监听网络连接状态，并在网络恢复时触发离线订单同步
class NetworkProvider {
  static NetworkProvider? _instance;
  static NetworkProvider get instance => _instance ??= NetworkProvider._();

  NetworkProvider._() {
    _initializeConnectivity();
  }

  final Connectivity _connectivity = Connectivity();
  final OfflineSyncService _syncService = OfflineSyncService.instance;

  bool _hasNetwork = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// 当前是否有网络
  bool get hasNetwork => _hasNetwork;

  /// 初始化网络连接监听
  Future<void> _initializeConnectivity() async {
    try {
      // 获取初始网络状态
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);

      // 监听网络状态变化
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
      );
    } catch (e) {
      if (kDebugMode) {
        print('网络监听初始化失败: $e');
      }
      _hasNetwork = true; // 默认假设有网络
    }
  }

  /// 更新网络连接状态
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final bool isConnected =
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn) ||
        result.contains(ConnectivityResult.other);

    if (_hasNetwork != isConnected) {
      _hasNetwork = isConnected;
      if (kDebugMode) {
        print('网络状态变化: ${isConnected ? "已连接" : "已断开"}');
      }

      // 通知同步服务网络状态变化
      _syncService.setNetworkStatus(isConnected);
    }
  }

  /// 检查当前网络状态
  Future<bool> checkNetwork() async {
    try {
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet) ||
          result.contains(ConnectivityResult.vpn) ||
          result.contains(ConnectivityResult.other);
    } catch (e) {
      if (kDebugMode) {
        print('检查网络状态失败: $e');
      }
      return false;
    }
  }

  /// 取消网络监听
  void dispose() {
    _connectivitySubscription?.cancel();
  }

  /// 同步离线订单到服务器
  /// 需要传入context用于调用API
  static Future<void> syncOfflineOrders(BuildContext context) async {
    try {
      final syncService = OfflineSyncService.instance;
      final offlineOrders = await syncService.getPendingOrders();

      if (offlineOrders.isEmpty) {
        return;
      }

      if (kDebugMode) {
        print('网络恢复，开始同步 ${offlineOrders.length} 条离线订单');
      }

      // 这里需要通过OrderProvider来同步，因为需要context
      // 实际同步逻辑由OrderProvider.syncOfflineOrders处理
    } catch (e) {
      if (kDebugMode) {
        print('同步离线订单失败: $e');
      }
    }
  }
}

