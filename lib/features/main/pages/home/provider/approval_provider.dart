import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_approval_service.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/home/provider/refund_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';

class ApprovalProvider {
  ApiApprovalService _apiApprovalService = ApiApprovalService();

  Future<int?> Approval(BuildContext context,RefundModel? refund ,bool ApproveType) async {
    try {
      if (refund != null) {
        final message = await _apiApprovalService.Approval(
          context,
          refund,
          ApproveType,
        );
        if (message == 200) {
          Provider.of<RefundProvider>(context, listen: false).getRefunds(context); 
        }
        return message;
      } else
        return 10086;
    } catch (e) {
      print("ERROR:" + e.toString());
      return -1;
    }
  }

}
