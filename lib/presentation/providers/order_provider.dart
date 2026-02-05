import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:refundo/presentation/providers/network_provider.dart';
import 'package:refundo/core/services/offline_sync_service.dart';
import 'package:refundo/core/services/secure_storage_service.dart';
import 'package:refundo/core/utils/storage/offline_order_storage.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/data/models/Product_model.dart';
import 'package:refundo/data/models/order_model.dart';
import 'package:refundo/data/models/refund_model.dart';

// 订单的provider方法
class OrderProvider with ChangeNotifier {
  List<OrderModel>? _orders;
  final ApiOrderService _orderService = ApiOrderService();
  final NetworkProvider _networkProvider = NetworkProvider.instance;
  final OfflineSyncService _syncService = OfflineSyncService.instance;

  // 离线订单数量
  int _offlineOrderCount = 0;

  // 分页相关
  int _currentPage = 1;
  int _pageSize = 20;
  int _totalOrders = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  List<OrderModel>? get orders => _orders;

  // 离线订单数量
  int get offlineOrderCount => _offlineOrderCount;

  // 分页状态
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  int get currentPage => _currentPage;

  // 获取订单信息（首次加载或刷新）
  Future<void> getOrders(BuildContext context) async {
    try {
      // 使用 SecureStorageService 获取token
      String token = await SecureStorageService.instance.getAccessToken();
      if (kDebugMode) {
        print("token: $token");
        print(token.isEmpty);
      }
      if (token.isNotEmpty) {
        try {
          // 重置分页状态
          _currentPage = 1;
          _hasMore = true;
          _orders = await _orderService.getOrders(
            context,
            false,
            page: _currentPage,
            pageSize: _pageSize,
          );

          // 注释：后端暂未提供订单总数接口，使用返回的订单数量判断
          // _totalOrders = await _orderService.getOrdersCount(context, false);
          _totalOrders = _orders!.length;
          _hasMore = false; // 暂时分页功能禁用
        } on DioException catch (e) {
          if (kDebugMode) {
            print(token);
            print("Dio错误详情:");
            print("请求URL: ${e.requestOptions.uri}");
            print("请求方法: ${e.requestOptions.method}");
            print("请求头: ${e.requestOptions.headers}");
            print("请求体: ${e.requestOptions.data}");
            print("响应状态码: ${e.response?.statusCode}");
            print("响应数据: ${e.response?.data}");
          }
          rethrow;
        }
      } else {
        _orders = [];
        _hasMore = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("获取订单失败: $e");
      }
      _orders = [];
      _hasMore = false;

    }finally {
      notifyListeners();
    }
  }

  // 加载更多订单
  Future<void> loadMoreOrders(BuildContext context) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newOrders = await _orderService.getOrders(
        context,
        false,
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (newOrders.isEmpty) {
        _hasMore = false;
      } else {
        _orders ??= [];
        _orders!.addAll(newOrders);
        _hasMore = _orders!.length < _totalOrders;
      }
    } catch (e) {
      if (kDebugMode) {
        print("加载更多订单失败: $e");
      }
      _currentPage--; // 回退页码
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // 刷新订单列表
  Future<void> refreshOrders(BuildContext context) async {
    await getOrders(context);
  }

  // 添加订单信息
  Future<String> insertOrder(ProductModel product, BuildContext context) async {
    try {
      if (kDebugMode) {
        print(product);
      }
      //检查产品信息完整性
      if (product.ProductId != '' &&
          product.Hash != '' &&
          product.RefundAmount != -1 &&
          product.price != -1 &&
          product.RefundPercent != -1) {
        //检查网络状态
        bool hasNetwork = await _networkProvider.checkNetwork();

        if (hasNetwork) {
          // 有网络，直接提交到服务器
          Map<String, dynamic> result = await _orderService.insertOrder(product, context);
          if (kDebugMode) {
            print(result);
          }
          String message = result['message'];
          OrderModel? order = result['result'];
          if(order != null){
            _orders!.add(result['result']);
            Provider.of<UserProvider>(context, listen: false).Info(context);
            notifyListeners();
          }
          return message;
        } else {
          // 无网络，保存到本地缓存
          bool saved = await OfflineOrderStorage.saveOfflineOrder(product);
          if (saved) {
            _updateOfflineOrderCount();
            if (kDebugMode) {
              print('订单已保存到离线缓存');
            }
            return '网络未连接，订单已保存到本地，将在网络恢复后自动同步';
          } else {
            return '保存离线订单失败';
          }
        }
      } else {
        return "无效产品";
      }
    } catch (e) {
      // 如果是网络异常，尝试保存到离线缓存
      if (e is DioException ||
          e.toString().contains('网络') ||
          e.toString().contains('连接')) {
        if (kDebugMode) {
          print('网络异常，保存到离线缓存: $e');
        }
        bool saved = await OfflineOrderStorage.saveOfflineOrder(product);
        if (saved) {
          _updateOfflineOrderCount();
          return '网络异常，订单已保存到本地，将在网络恢复后自动同步';
        }
      }
      print("添加订单失败: $e");
      return "添加订单失败: $e";
    }
  }

  /// 同步单个订单（带重试机制）
  Future<Map<String, dynamic>> _syncSingleOrder(
    Map<String, dynamic> orderData,
    BuildContext context, {
    int maxRetries = 2,
  }) async {
    int attempt = 0;
    while (attempt <= maxRetries) {
      try {
        final productData = orderData['product'] as Map<String, dynamic>;
        final ProductModel product = ProductModel.fromJson(productData);

        final result = await _orderService.insertOrder(product, context);
        final order = result['result'] as OrderModel?;

        if (order != null) {
          return {'success': true, 'order': order, 'data': orderData};
        } else {
          attempt++;
          if (attempt > maxRetries) {
            return {'success': false, 'data': orderData};
          }
        }
      } catch (e) {
        attempt++;
        if (kDebugMode) {
          print('订单同步异常 (尝试 $attempt/$maxRetries): $e');
        }
        if (attempt > maxRetries) {
          return {'success': false, 'data': orderData};
        }
        // 等待一段时间后重试
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
    return {'success': false, 'data': orderData};
  }

  /// 同步离线订单到服务器（并行处理）
  Future<Map<String, int>> syncOfflineOrders(BuildContext context) async {
    try {
      // 获取所有待同步的离线订单
      List<Map<String, dynamic>> offlineOrders =
          await _syncService.getPendingOrders();

      if (offlineOrders.isEmpty) {
        return {'success': 0, 'failed': 0};
      }

      if (kDebugMode) {
        print('开始并行同步 ${offlineOrders.length} 条离线订单');
      }

      // 并行处理所有订单，但限制并发数为5
      const concurrencyLimit = 5;
      final results = <Map<String, dynamic>>[];
      final syncedOrders = <Map<String, dynamic>>[];

      for (int i = 0; i < offlineOrders.length; i += concurrencyLimit) {
        final batch = offlineOrders.skip(i).take(concurrencyLimit).toList();
        final futures = batch.map((orderData) =>
          _syncSingleOrder(orderData, context)
        );

        final batchResults = await Future.wait(futures);
        results.addAll(batchResults);

        // 报告进度
        final completed = (i + batch.length).clamp(0, offlineOrders.length);
        if (kDebugMode) {
          print('同步进度: $completed/${offlineOrders.length}');
        }
      }

      // 统计结果
      int successCount = 0;
      int failedCount = 0;

      for (final result in results) {
        if (result['success'] == true) {
          successCount++;
          syncedOrders.add(result['data']);
          final order = result['order'] as OrderModel;
          _orders ??= [];
          _orders!.add(order);
          if (kDebugMode) {
            print('订单同步成功: ${order.orderNumber}');
          }
        } else {
          failedCount++;
        }
      }

      // 删除已同步成功的订单
      if (syncedOrders.isNotEmpty) {
        await _syncService.markOrdersSynced(syncedOrders);
        await _updateOfflineOrderCount();
        Provider.of<UserProvider>(context, listen: false).Info(context);
        notifyListeners();
      }

      if (kDebugMode) {
        print('同步完成: 成功 $successCount 条, 失败 $failedCount 条');
      }

      return {'success': successCount, 'failed': failedCount};
    } catch (e) {
      if (kDebugMode) {
        print('同步离线订单失败: $e');
      }
      return {'success': 0, 'failed': 0};
    }
  }

  /// 更新离线订单数量
  Future<void> _updateOfflineOrderCount() async {
    _offlineOrderCount = await OfflineOrderStorage.getOfflineOrderCount();
    notifyListeners();
  }

  /// 初始化时加载离线订单数量
  Future<void> initialize() async {
    await _updateOfflineOrderCount();
    // 初始化网络监听
    _networkProvider.initializeConnectivity();
  }

  // 清除订单信息
  void clearOrders() {
    _orders = [];
    notifyListeners();
  }
}
