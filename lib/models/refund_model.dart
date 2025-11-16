import 'package:decimal/decimal.dart';

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
    required this.refundState
  });

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

  // 从Json的转化方法
  factory RefundModel.fromJson(Map<String,dynamic> json){
    RefundStates state;
    if(json['refund']['state'] != null)
        state = json['refund']['state'] ? RefundStates.success : RefundStates.approval;
    else
        state = RefundStates.padding;

    return RefundModel(
        recordId: json['refund']['refundId'] as int ? ?? 0 ,
        orderId: json['refund']['orderId'] as int ? ?? 0,
        orderNumber: json['refund']['orderNumber'] as String ? ?? '',
        refundMethod: json['refund']['method'] as int ? ?? 0,
        account: json['refund']['account'] as String ? ?? '',
        phone: json['phoneNumber'] as String ? ?? '',
        userId: json['refund']['uid'] as int ? ?? 0,
        nickName: json['userName'] as String ? ?? '',
        email: json['email'] as String ? ?? '',
        refundAmount: Decimal.parse(json['amount']?.toString() ?? '0' ),
        timestamp: json['refund']['time'] as String ? ?? '',
        productId: json['refund']['productId'] as String ? ?? '',
        refundState: state
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "返还金额：$refundAmount，提现时间：$timestamp，审批状态:$refundState";
  }

}

enum RefundStates{
  approval,
  success,
  padding
}