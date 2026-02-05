import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:refundo/l10n/app_localizations.dart';

enum RefundStates {
  pending,      // 0 - 待审核
  approved,     // 1 - 已批准
  rejected,     // 2 - 已拒绝
  processing,   // 3 - 处理中
  completed,    // 4 - 已完成
  transactionFailed, // 5 - 交易失败
}

class RefundModel {
  final int recordId;
  final String orderNumber;
  final int orderId;
  final String productId;
  final int refundMethod;
  final String account;
  final String phone;
  final int userId;
  final String nickName;
  final String email;
  final Decimal refundAmount;
  final String timestamp;
  RefundStates refundState;
  final String? remittanceReceipt;
  final String? scanIds;
  final String? voucherUrl;
  final String? rejectReason;

  RefundModel({
    required this.recordId,
    required this.orderNumber,
    required this.orderId,
    required this.productId,
    required this.refundMethod,
    required this.account,
    required this.phone,
    required this.userId,
    required this.nickName,
    required this.email,
    required this.refundAmount,
    required this.timestamp,
    required this.refundState,
    this.remittanceReceipt,
    this.scanIds,
    this.voucherUrl,
    this.rejectReason,
  });

  String get_refundMethod(BuildContext context) {
    if (refundMethod == 1) {
      return AppLocalizations.of(context)!.orange_money;
    } else if (refundMethod == 2) {
      return AppLocalizations.of(context)!.wave;
    } else {
      return AppLocalizations.of(context)!.phone_number_label;
    }
  }

  Map<String, dynamic> toJson() => {
    'requestId': recordId,
    'orderNumber': orderNumber,
    'refundMethod': refundMethod,
    'account': account,
    'phone': phone,
    'userId': userId,
    'nickName': nickName,
    'email': email,
    'refundAmount': refundAmount.toString(),
    'timestamp': timestamp,
    'refundState': refundState.index,
  };

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    // 辅助函数
    int getInt(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null) {
          if (value is int) return value;
          if (value is double) return value.toInt();
          if (value is String) return int.tryParse(value) ?? 0;
        }
      }
      return 0;
    }

    String getString(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
      return '';
    }

    Decimal getDecimal(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null) {
          try {
            return Decimal.parse(value.toString());
          } catch (e) {
            return Decimal.zero;
          }
        }
      }
      return Decimal.zero;
    }

    final requestStatus = getInt(['requestStatus', 'RequestStatus']);
    RefundStates state = _getStatusFromRequestStatus(requestStatus);

    final scanIdsStr = getString(['scanIds', 'ScanIds']);
    int parsedOrderId = 0;
    if (scanIdsStr.isNotEmpty) {
      final ids = scanIdsStr.split(',');
      if (ids.isNotEmpty) {
        parsedOrderId = int.tryParse(ids[0].trim()) ?? 0;
      }
    }

    return RefundModel(
      recordId: getInt(['requestId', 'RequestId']),
      orderNumber: getString(['requestNumber', 'RequestNumber']),
      orderId: parsedOrderId,
      productId: getString(['productId']),
      refundMethod: getInt(['paymentMethod', 'PaymentMethod']),
      account: getString(['paymentNumber', 'PaymentNumber']),
      phone: getString(['phoneNumber']),
      userId: getInt(['userId', 'UserId']),
      nickName: getString(['userName', 'username']),
      email: getString(['email']),
      refundAmount: getDecimal(['amount', 'Amount']),
      timestamp: getString(['createTime', 'CreateTime']),
      refundState: state,
      remittanceReceipt: getString(['remittanceReceipt']),
      scanIds: scanIdsStr.isNotEmpty ? scanIdsStr : null,
      voucherUrl: getString(['voucherUrl']),
      rejectReason: getString(['rejectReason']),
    );
  }

  static RefundStates _getStatusFromRequestStatus(int status) {
    switch (status) {
      case 0: return RefundStates.pending;
      case 1: return RefundStates.approved;
      case 2: return RefundStates.rejected;
      case 3: return RefundStates.processing;
      case 4: return RefundStates.completed;
      default: return RefundStates.pending;
    }
  }

  @override
  String toString() {
    return "返还金额：$refundAmount，提现时间：$timestamp，审批状态:$refundState";
  }
}
