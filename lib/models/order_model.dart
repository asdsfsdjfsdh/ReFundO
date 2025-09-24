class OrderModel{
  // 订单号
  final String id;
  // 产品价格
  final double value;
  // 返还金额
  final double refundAmount;
  // 扫描时间
  final DateTime timestamp;
  // 是否提现
  final bool isRefund;

  // 初始化方法
  OrderModel({
    required this.id,
    required this.value,
    required this.refundAmount,
    required this.timestamp,
    required this.isRefund
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() =>{
    'id': id,
    'value': value,
    'refundAmount': refundAmount,
    'timestamp': timestamp,
    'isRefund': isRefund
  };

  // 从Json的转化方法
  factory OrderModel.fromJson(Map<String,dynamic> json){
    return OrderModel(
      id: json['id'],
      value: json['value'],
      refundAmount: json['refundAmount'],
      timestamp: json['timestamp'],
      isRefund: json['isRefund']
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "订单号：$id，订单价格：$value，返还金额：$refundAmount,订单扫描时间：$timestamp,是否提现:$isRefund";
  }
}