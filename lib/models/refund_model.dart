import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:refundo/l10n/app_localizations.dart';

class RefundModel {
  // 提现申请编号
  final int requestId;
  final String requestNumber;
  final int requestStatus;
  final String rejectreason;
  final Decimal amount;
  final String voucherUrl;
  final String scanIds;
  final String paymentNumber;
  final int paymentMethod;
  final String createTime;
  final String updateTime;

  // 初始化方法
  RefundModel({
    required this.requestId,
    required this.scanIds,
    required this.requestNumber,
    required this.paymentNumber,
    required this.requestStatus,
    required this.rejectreason,
    required this.paymentMethod,
    required this.voucherUrl,
    required this.createTime,
    required this.updateTime,
    required this.amount,
  });

  String get_refundMethod(BuildContext context) {
    if (paymentMethod == 1) {
      return AppLocalizations.of(context)!.phone_payment;
    } else if (paymentMethod == 2) {
      return AppLocalizations.of(context)!.sanke_money;
    } else {
      return AppLocalizations.of(context)!.wave_payment;
    }
  }

  // 配置转化Json方法
  Map<String, dynamic> toJson() => {
    "requestId": requestId,
    "voucherUrl": voucherUrl,
    "scanIds": scanIds,
    "paymentNumber": paymentNumber,
    "paymentMethod": paymentMethod,
    "createTime": createTime,
    "updateTime": updateTime,
    "requestNumber": requestNumber,
    "requestStatus": requestStatus,
    "rejectReason": rejectreason,
    "amount": amount,
  };

  // 从Json的转化方法
  factory RefundModel.fromJson(Map<String, dynamic> json) {

    return RefundModel(
      requestId: json['requestId'] as int? ?? 0,
      scanIds: json['scanIds'] as String? ?? '',
      requestNumber: json['requestNumber'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as int? ?? 0,
      paymentNumber: json['paymentNumber'] as String? ?? '',
      createTime: json['createTime'] as String? ?? '',
      amount: Decimal.parse(json['amount']?.toString() ?? '0'),
      rejectreason: json['rejectReason'] as String? ?? '',
      updateTime: json['updateTime'] as String? ?? '',
      requestStatus: json['requestStatus'] as int? ?? 0,
      voucherUrl: json['voucherUrl'] as String? ?? '',
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "申请编号：$requestId，申请编号：$requestNumber，金额：$amount，申请时间：$createTime，状态：$requestStatus，拒绝理由：$rejectreason";
  }
}

enum RefundStates { approval, success, padding }
