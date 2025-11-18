import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_approval_service.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/home/provider/refund_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';

class ApprovalProvider extends ChangeNotifier {
  ApiApprovalService _apiApprovalService = ApiApprovalService();

  Future<int?> Approval(BuildContext context,RefundModel? refund ,bool ApproveType) async {
    try {
      if (refund != null) {
        final message = await _apiApprovalService.Approval(
          context,
          refund,
          ApproveType,
        );
        // 移动getRefunds调用到这里，并等待它完成
        // if (message == 200) {
        //   await Provider.of<RefundProvider>(context, listen: false).getRefunds(context); 
        // }
        return message;
      } else
        return 10086;
    } catch (e) {
      if (kDebugMode) {
        print("ERROR:$e");
      }
      return -1;
    }
  }

}