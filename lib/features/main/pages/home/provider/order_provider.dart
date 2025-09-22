import 'package:flutter/cupertino.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';

// 订单的provider方法
class OrderProvider with ChangeNotifier{
  List<OrderModel>? _orders;
  ApiOrderService _orderService = ApiOrderService();

  List<OrderModel>? get orders => _orders;

  // 获取订单信息
  Future<void> getOrders() async{
    _orders = await _orderService.getOrders();
  }
}