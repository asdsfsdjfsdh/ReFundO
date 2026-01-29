import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:refundo/presentation/providers/network_provider.dart';
import 'package:refundo/core/services/offline_sync_service.dart';
import 'package:refundo/core/utils/storage/offline_order_storage.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/data/models/Product_model.dart';
import 'package:refundo/data/models/order_model.dart';
import 'package:refundo/data/models/refund_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 订单的provider方法
class OrderProvider with ChangeNotifier {
  List<OrderModel>? _orders;
  final ApiOrderService _orderService = ApiOrderService();
  final NetworkProvider _networkProvider = NetworkProvider.instance;
  final OfflineSyncService _syncService = OfflineSyncService.instance;

  // 离线订单数量
  int _offlineOrderCount = 0;

  List<OrderModel>? get orders => _orders;

  // 离线订单数量
  int get offlineOrderCount => _offlineOrderCount;

  // 获取订单信息
  Future<void> getOrders(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('access_token') ?? '';
      if (kDebugMode) {
        print("token: $token");
        print(token.isEmpty);
      }
      if (token.isNotEmpty) {
        try {
          _orders = await _orderService.getOrders(context, false);
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
      }
    } catch (e) {
      if (kDebugMode) {
        print("获取订单失败: $e");
      }
      _orders = [];

    }finally {
      notifyListeners();
    }
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

  /// 同步离线订单到服务器
  Future<Map<String, int>> syncOfflineOrders(BuildContext context) async {
    int successCount = 0;
    int failedCount = 0;

    try {
      // 获取所有待同步的离线订单
      List<Map<String, dynamic>> offlineOrders =
          await _syncService.getPendingOrders();

      if (offlineOrders.isEmpty) {
        return {'success': 0, 'failed': 0};
      }

      if (kDebugMode) {
        print('开始同步 ${offlineOrders.length} 条离线订单');
      }

      List<Map<String, dynamic>> syncedOrders = [];

      // 逐个同步订单
      for (var orderData in offlineOrders) {
        try {
          // 提取产品信息
          final productData = orderData['product'] as Map<String, dynamic>;
          final ProductModel product = ProductModel.fromJson(productData);

          // 发送到服务器
          Map<String, dynamic> result = await _orderService.insertOrder(product, context);
          String message = result['message'];
          OrderModel? order = result['result'];

          if (order != null) {
            // 同步成功，添加到订单列表
            _orders ??= [];
            _orders!.add(order);
            successCount++;
            syncedOrders.add(orderData);
            if (kDebugMode) {
              print('订单同步成功: ${product.ProductId}');
            }
          } else {
            failedCount++;
            if (kDebugMode) {
              print('订单同步失败: ${message}');
            }
          }
        } catch (e) {
          failedCount++;
          if (kDebugMode) {
            print('订单同步异常: $e');
          }
        }
      }

      // 删除已同步成功的订单
      if (syncedOrders.isNotEmpty) {
        await _syncService.markOrdersSynced(syncedOrders);
        _updateOfflineOrderCount();
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
      return {'success': successCount, 'failed': failedCount};
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
