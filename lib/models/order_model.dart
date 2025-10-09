class OrderModel{
  // 订单号
  final int orderid;
  // 产品价格
  final double price;
  // 返还金额
  final double refundAmount;
  // 扫描时间
  final String OrderTime;
  // 是否提现,hash值
  final bool isRefund;

  // 初始化方法
  OrderModel({
    required this.orderid,
    required this.price,
    required this.refundAmount,
    required this.OrderTime,
    required this.isRefund
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() =>{
    'orderid': orderid,
    'price': price,
    'refundAmount': refundAmount,
    'OrderTime': OrderTime,
    'isRefund': isRefund
  };

  // 从Json的转化方法
  factory OrderModel.fromJson(Map<String,dynamic> json){
    return OrderModel(
      orderid: json['orderid'] as int ? ?? 0,
      price: json['price'] as double ? ?? 0.0,
      refundAmount: json['refundamount'] as double ? ?? 0.0,
      OrderTime: json['date'] as String ? ?? '',
      isRefund: json['isRefund'] as bool ? ?? false,
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "订单号：$orderid，订单价格：$price，返还金额：$refundAmount,订单扫描时间：$OrderTime,是否提现:$isRefund";
  }
}