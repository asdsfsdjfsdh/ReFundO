import 'package:flutter/cupertino.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/data/services/api_refund_service.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';

// 订单的provider方法
class RefundProvider with ChangeNotifier{
  List<RefundModel>? _refunds;
  ApiRefundService refundService = ApiRefundService();

  List<RefundModel>? get refunds => _refunds;

  // 获取订单信息
  Future<void> getRefunds() async{
    _refunds = await refundService.getRefunds();
  }
}