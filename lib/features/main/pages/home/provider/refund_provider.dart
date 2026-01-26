import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/data/services/api_refund_service.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        final refundDate = DateTime.parse(refund.createTime);
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
      return refund.requestStatus != 2;
    }).length;
  }

  // 获取订单信息
  Future<void> getRefunds(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('access_token') ?? '';
      if (kDebugMode) {
        print("token: $token");
        print(token.isEmpty);
      }
      if (token.isNotEmpty) {
        try {
            final result = await refundService.getRefunds(context);
            if (result['success'] == true) {
              _refunds = result['data'] as List<RefundModel>;
            } else {
              _refunds = [];
            }
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
      // 使用value字段代替原来的refundAmount字段
      all += Decimal.parse(value.value.toString());
      print(all.toString());
    });
    print(all.toString());
    return all;
  }

  void removeOrder(int orderId) {
    _orders ??= <OrderModel>{};
    _orders!.removeWhere((order) => order.scanId == orderId);
    notifyListeners();
  }
  
  // 检查退款条件
  Future<Map<String, dynamic>> checkRefundConditions(BuildContext context) async {
    try {
      final result = await _orderService.checkRefundConditions(context,_orders!);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print("检查退款条件失败: $e");
      }
      return {'success': false, 'message': 'unknown_error'};
    }
  }

// 退款
  Future<Map<String, dynamic>> Refund(BuildContext context,int refundType,String refundAccount,String voucherUrl) async {
    try {
      if (_orders!.isNotEmpty) {
        final result = await _orderService.Refund(context, _orders!,refundType,refundAccount,voucherUrl);
        if (result['success'] == true) {
          Provider.of<OrderProvider>(context,listen: false).getOrders(context);
          this.getRefunds(context);
          Provider.of<UserProvider>(context,listen: false).Info(context);
          return {'success': true, 'messageKey': 'create_refund_success'};
        } else {
          return result;
        }
      } else {
        return {'success': false, 'message': 'no_orders_selected'};
      }
    } catch (e) {
      if (kDebugMode) {
        print("ERROR:$e");
      }
      return {'success': false, 'message': 'unknown_error'};
    }
  }

  // 清除退款信息
  void clearRefunds(){
    _refunds = [];
    notifyListeners();
  }
}