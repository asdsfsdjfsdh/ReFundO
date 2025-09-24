class OrderModel{
  // 订单号
  final String ProductId;
  // 产品价格
  final double price;
  // 返还金额
  final double refundAmount;
  // 扫描时间
  final DateTime OrderTime;
  // 是否提现,hash值
  final bool isRefund;

  // 初始化方法
  OrderModel({
    required this.ProductId,
    required this.price,
    required this.refundAmount,
    required this.OrderTime,
    required this.isRefund
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() =>{
    'ProductId': ProductId,
    'price': price,
    'refundAmount': refundAmount,
    'OrderTime': OrderTime,
    'isRefund': isRefund
  };

  // 从Json的转化方法
  factory OrderModel.fromJson(Map<String,dynamic> json){
    return OrderModel(
      ProductId: json['ProductId'],
      price: json['price'],
      refundAmount: json['refundAmount'],
      OrderTime: json['OrderTime'],
      isRefund: json['isRefund']
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "订单号：$ProductId，订单价格：$price，返还金额：$refundAmount,订单扫描时间：$OrderTime,是否提现:$isRefund";
  }
}