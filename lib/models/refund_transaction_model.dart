/// 退款交易记录模型 - 包含退款请求和交易的完整信息
class RefundTransactionModel {
  final int transId;
  final int requestId;
  final String refundNumber;
  final int transStatus;
  final String remittanceReceipt;
  final String createTime;
  final String updateTime;
  // 退款请求信息（从 TransactionVO 获取）
  final double amount;
  final int paymentMethod;
  final String paymentNumber;

  RefundTransactionModel({
    required this.transId,
    required this.requestId,
    required this.refundNumber,
    required this.transStatus,
    required this.remittanceReceipt,
    required this.createTime,
    required this.updateTime,
    required this.amount,
    required this.paymentMethod,
    required this.paymentNumber,
  });

  factory RefundTransactionModel.fromJson(Map<String, dynamic> json) {
    return RefundTransactionModel(
      transId: json['transId'] as int? ?? 0,
      requestId: json['requestId'] as int? ?? 0,
      refundNumber: json['refundNumber'] as String? ?? '',
      transStatus: json['transStatus'] as int? ?? 0,
      remittanceReceipt: json['remittanceReceipt'] as String? ?? '',
      createTime: json['createTime'] as String? ?? '',
      updateTime: json['updateTime'] as String? ?? json['updateTime'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as int? ?? 0,
      paymentNumber: json['paymentNumber'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return "交易ID：$transId，退款编号：$refundNumber，状态：$transStatus，时间：$createTime";
  }
}
