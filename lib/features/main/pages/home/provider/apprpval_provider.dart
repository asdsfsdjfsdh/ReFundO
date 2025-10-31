import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_approval_service.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/models/order_model.dart';

class ApprovalProvider {
  Set<OrderModel>? _orders = <OrderModel>{};
  ApiApprovalService _apiApprovalService = ApiApprovalService();

  Future<int?> Approval(BuildContext context, bool ApproveType) async {
    try {
      if (_orders!.isNotEmpty) {
        final message = await _apiApprovalService.Approval(
          context,
          _orders!,
          ApproveType,
        );
        if (message == 1) {
          Provider.of<OrderProvider>(context, listen: false).getOrders(context);
          this.getRefunds(context);
        }
        return message;
      } else
        return 10086;
    } catch (e) {
      print("ERROR:" + e.toString());
      return -1;
    }
  }

  void getRefunds(BuildContext context) {}
}
