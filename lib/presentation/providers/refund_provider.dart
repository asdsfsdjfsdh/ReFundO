import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/services/secure_storage_service.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/data/services/api_refund_service.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/data/models/order_model.dart';
import 'package:refundo/data/models/refund_model.dart';

// 订单的provider方法
class RefundProvider with ChangeNotifier {
  // List<RefundModel>? _refunds;
  List<RefundModel>? _refunds;
  Set<OrderModel>? _orders = <OrderModel>{};
  ApiRefundService refundService = ApiRefundService();
  ApiOrderService _orderService = ApiOrderService();

  List<RefundModel>? get refunds => _refunds;
  Set<OrderModel>? get orders => _orders;

  // 获取今日提交的退款请求数量
  int get todayRefundCount {
    if (_refunds == null) return 0;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _refunds!.where((refund) {
      try {
        final refundDate = DateTime.parse(refund.timestamp);
        final refundDay = DateTime(refundDate.year, refundDate.month, refundDate.day);
        return refundDay.isAtSameMomentAs(today);
      } catch (e) {
        return false;
      }
    }).length;
  }

  // 获取未处理的退款请求数量
  int get pendingRefundCount {
    if (_refunds == null) return 0;
    
    return _refunds!.where((refund) {
      return refund.refundState == RefundStates.pending;
    }).length;
  }

  // 获取订单信息
  Future<void> getRefunds(BuildContext context) async {
    try {
      // 使用 SecureStorageService 获取token
      String token = await SecureStorageService.instance.getAccessToken();
      if (kDebugMode) {
        print("token: $token");
        print(token.isEmpty);
      }
      if (token.isNotEmpty) {
        try {
          // 刷新CSRF Token（因为CSRF token是一次性使用的）
          try {
            if (kDebugMode) {
              print('🔄 获取退款列表前刷新CSRF Token...');
            }
            await DioProvider.globalInstance.refreshCsrfToken();
            if (kDebugMode) {
              print('✅ CSRF Token刷新成功');
            }
          } catch (e) {
            if (kDebugMode) {
              print('⚠️ CSRF Token刷新失败: $e');
            }
            // CSRF Token刷新失败不阻止获取，继续尝试
          }

          _refunds = await refundService.getRefunds(context);
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
        _refunds = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("获取订单失败: $e");
      }
      _refunds = [];
    } finally {
      notifyListeners();
    }
  }

  void addOrder(OrderModel order) {
    _orders ??= <OrderModel>{};
    _orders!.add(order);
    notifyListeners();
  }

  Decimal allAmount(){
    Decimal all = Decimal.fromInt(0);
    _orders?.forEach((value){
      all += value.refundAmount;
      print(all.toString());
    });
    print(all.toString());
    return all;
  }

  void removeOrder(int orderId) {
    _orders ??= <OrderModel>{};
    _orders!.removeWhere((order) => order.orderid == orderId);
    notifyListeners();
  }
  
  // 检查退款条件 - 计算退款金额
  Future<Map<String, dynamic>> checkRefundConditions(BuildContext context) async {
    try {
      final result = await _orderService.checkRefundConditions(context, _orders!);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print("检查退款条件失败: $e");
      }
      return {"success": false, "message": "检查退款条件失败"};
    }
  }

// 退款
  Future<int> Refund(BuildContext context,int refundType,String refundAccount) async {
    try {
      if (_orders!.isNotEmpty) {
        // 刷新CSRF Token（因为CSRF token是一次性使用的）
        try {
          if (kDebugMode) {
            print('🔄 提交前刷新CSRF Token...');
          }
          await DioProvider.globalInstance.refreshCsrfToken();
          if (kDebugMode) {
            print('✅ CSRF Token刷新成功');
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ CSRF Token刷新失败: $e');
          }
          // CSRF Token刷新失败不阻止提交，后端会处理
        }

        int message = await _orderService.Refund(context, _orders!,refundType,refundAccount);
        if(message == 1){
          // 退款成功后清除选中的订单
          _orders!.clear();
          notifyListeners();

          Provider.of<OrderProvider>(context,listen: false).getOrders(context);
          this.getRefunds(context);
          Provider.of<UserProvider>(context,listen: false).Info(context);
        }
        return message;
      } else {
        return 10086;
      }
    } catch (e) {
      if (kDebugMode) {
        print("ERROR:$e");
      }
      return -1;
    }
  }

  // 清除退款信息
  void clearRefunds(){
    _refunds = [];
    notifyListeners();
  }

  // 清除选中的订单
  void clearSelectedOrders(){
    _orders?.clear();
    notifyListeners();
  }
}