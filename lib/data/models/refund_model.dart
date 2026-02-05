import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:refundo/l10n/app_localizations.dart';

class RefundModel{

  // 提现申请编号
  final int recordId;

  // 订单号
  final String orderNumber;

  // 订单编号
  final int orderId;

  // 商品ID
  final String productId;

  // 退款方式
  final int refundMethod;

  // 退款账号
  final String account;

  // 手机号码
  final String phone;

  // 用户ID
  final int userId;

  // 用户名
  final String nickName;

  // 用户邮箱
  final String email;

  // 返还金额
  final Decimal refundAmount;

  // 提现时间
  final String timestamp;

  // 提现审批状态
  RefundStates refundState;

  // 汇款凭证（交易凭证）
  final String? remittanceReceipt;

  // 初始化方法
  RefundModel({
    required this.recordId,
    required this.orderId,
    required this.orderNumber,
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
    this.remittanceReceipt
  });

  String get_refundMethod(BuildContext context){
    if (refundMethod == 1){
      return AppLocalizations.of(context)!.orange_money;
    }else if(refundMethod == 2){
      return AppLocalizations.of(context)!.wave;
    }else{
      return AppLocalizations.of(context)!.phone_number_label;
    }
  }

  // 配置转化Json方法
  Map<String, dynamic> toJson() =>{
    'recordId': recordId,
    'orderId': orderId,
    'orderNumber': orderNumber,
    'refundMethod': refundMethod,
    'account': account,
    'phone': phone,
    'userId': userId,
    'nickName': nickName,
    'email': email,
    'refundAmount': refundAmount.toString(),
    'timestamp': timestamp,
    'refundState': refundState.index
  };

  // 从Json的转化方法 - 匹配后端RefundResponse的数据结构
  factory RefundModel.fromJson(Map<String,dynamic> json){
    RefundStates state;

    // 后端返回的数据结构：{refund: {requestStatus, ...}, userName, email, phoneNumber, amount, remittanceReceipt}
    final refund = json['refund'];
    if (refund != null) {
      // requestStatus: Long类型，对应退款申请的5个状态
      // 0=待审核, 1=审批通过等待交易, 2=审批拒绝, 4=交易完成, 5=交易失败
      final requestStatus = refund['requestStatus'] as int?;
      state = _getStatusFromRequestStatus(requestStatus);

      // 调试日志
      print('📦 RefundModel.fromJson - requestStatus: $requestStatus, state: $state');
      print('📦 remittanceReceipt from json: ${json['remittanceReceipt']}');

      return RefundModel(
        recordId: refund['requestId'] as int? ?? 0,
        orderId: refund['orderId'] as int? ?? 0,
        orderNumber: refund['orderNumber'] as String? ?? '',
        productId: refund['productId'] as String? ?? '',
        refundMethod: refund['paymentMethod'] as int? ?? 0,
        account: refund['paymentNumber'] as String? ?? '',
        phone: json['phoneNumber'] as String? ?? '',
        userId: refund['userId'] as int? ?? 0,
        nickName: json['userName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        refundAmount: Decimal.parse((json['amount'] ?? refund['amount'] ?? 0).toString()),
        timestamp: refund['createTime'] as String? ?? '',
        refundState: state,
        remittanceReceipt: json['remittanceReceipt'] as String?
      );
    }

    // 兼容旧格式（如果不存在refund字段）
    state = RefundStates.pending;
    return RefundModel(
        recordId: json['refundId'] as int? ?? 0,
        orderId: 0,
        orderNumber: '',
        refundMethod: json['method'] as int? ?? 0,
        account: json['account'] as String? ?? '',
        phone: json['phoneNumber'] as String? ?? '',
        userId: 0,
        nickName: '',
        email: '',
        refundAmount: Decimal.parse(json['amount']?.toString() ?? '0'),
        timestamp: '',
        productId: '',
        refundState: state
    );
  }

  // 根据requestStatus获取对应的RefundStates
  static RefundStates _getStatusFromRequestStatus(int? requestStatus) {
    switch (requestStatus) {
      case 0:
        return RefundStates.pending;           // 待审核
      case 1:
        return RefundStates.approved;          // 审批通过，等待交易
      case 2:
        return RefundStates.rejected;          // 审批拒绝
      case 4:
        return RefundStates.completed;         // 交易完成
      case 5:
        return RefundStates.transactionFailed;  // 交易失败
      default:
        return RefundStates.pending;
    }
  }

  // 重写输出方法
  @override
  String toString() {
    return "返还金额：$refundAmount，提现时间：$timestamp，审批状态:$refundState";
  }

}

enum RefundStates{
  pending,           // 0 - 待审核
  approved,          // 1 - 审批通过，等待交易
  rejected,          // 2 - 审批拒绝
  completed,         // 4 - 交易完成
  transactionFailed  // 5 - 交易失败
}