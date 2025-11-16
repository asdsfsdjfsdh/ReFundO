import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/data/services/api_refund_service.dart';
import 'package:refundo/data/services/api_user_logic_service.dart';
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
      return refund.refundState == RefundStates.padding;
    }).length;
  }

  // 获取订单信息
  Future<void> getRefunds(BuildContext context) async {
    try {
      bool isAdmin = Provider.of<UserProvider>(context,listen: false).user!.role;
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('access_token') ?? '';
      print("token: $token");
      print(token.isEmpty);
      if (token.isNotEmpty) {
        try {
          if(!isAdmin)
            _refunds = await refundService.getRefunds(context);
          else
            _refunds = await refundService.getAllRefunds(context);
        } on DioException catch (e) {
          print(token);
          print("Dio错误详情:");
          print("请求URL: ${e.requestOptions.uri}");
          print("请求方法: ${e.requestOptions.method}");
          print("请求头: ${e.requestOptions.headers}");
          print("请求体: ${e.requestOptions.data}");
          print("响应状态码: ${e.response?.statusCode}");
          print("响应数据: ${e.response?.data}");
          rethrow;
        }
      } else {
        _refunds = [];
      }
    } catch (e) {
      print("获取订单失败: $e");
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

  void removeOrder(int orderId) {
    _orders ??= <OrderModel>{};
    _orders!.removeWhere((order) => order.orderid == orderId);
    notifyListeners();
  }
  
  // 检查退款条件
  Future<int> checkRefundConditions(BuildContext context) async {
    try {
      final statusCode = await _orderService.checkRefundConditions(context,_orders!);
      return statusCode;
    } catch (e) {
      print("检查退款条件失败: $e");
      return -1;
    }
  }

// 退款
  Future<int> Refund(BuildContext context) async {
    try {
      if (_orders!.isNotEmpty) {
        // 先检查退款条件
        final statusCode = await checkRefundConditions(context);
        if (statusCode != 200) {
          // 条件不满足，返回状态码
          return statusCode; // 直接返回状态码
        }
        
        int message = await _orderService.Refund(context, _orders!);
        if(message == 1){
          Provider.of<OrderProvider>(context,listen: false).getOrders(context);
          this.getRefunds(context);
          Provider.of<UserProvider>(context,listen: false).Info(context);
        }
        return message;
      } else
        return 10086;
    } catch (e) {
      print("ERROR:" + e.toString());
      return -1;
    }
  }

  // 清除退款信息
  void clearRefunds(){
    _refunds = [];
    notifyListeners();
  }
}