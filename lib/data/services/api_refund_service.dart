// 访问后端返现数据
import 'package:flutter/material.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';

class ApiRefundService{

  // 获取订单数
  Future<List<RefundModel>> getRefunds(BuildContext context,bool isRefund) async{
    // 暂时占位
    List<RefundModel> orders = [
      RefundModel(refundAmount: 5, timestamp: DateTime.timestamp(), refundState: RefundStates.success),
      RefundModel(refundAmount: 10, timestamp: DateTime.timestamp(), refundState: RefundStates.success),
      RefundModel(refundAmount: 50, timestamp: DateTime.timestamp(), refundState: RefundStates.approval),

    ];

    List<OrderModel> O = await ApiOrderService().getOrders(context,isRefund);
    return orders;
  }
}