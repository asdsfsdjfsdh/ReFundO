import 'package:decimal/decimal.dart';

class OrderModel {
  // 订单号
  final int orderid;
  // 订单编号
  final String orderNumber;
  // 产品id
  final String ProductId;
  // 产品价格
  final Decimal price;
  // 返还金额
  final Decimal refundAmount;
  // 返还比例
  final Decimal refundpercent;
  // 扫描时间
  final String OrderTime;
  // 是否提现
  final bool isRefund;
  // 退款状态
  final bool refundState;
  // 退款时间
  final String refundTime;

  final String errorMessage;

  // Getter for backward compatibility (orderTime -> OrderTime)
  String get orderTime => OrderTime;

  // 初始化方法
  OrderModel({
    required this.orderid,
    required this.orderNumber,
    required this.ProductId,
    required this.price,
    required this.refundAmount,
    required this.refundpercent,
    required this.OrderTime,
    required this.isRefund,
    required this.refundState,
    required this.refundTime,
    this.errorMessage = '',
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() => {
    'orderid': orderid,
    'orderNumber': orderNumber,
    'productid': ProductId,
    'price': price.toString(),
    'refundamount': refundAmount.toString(),
    'refundpercent': refundpercent.toDouble(),
    'isrefund': isRefund,
    'refundState': refundState,
  };

  // 从Json的转化方法
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderid: json['orderid'] as int? ?? 0,
      orderNumber: json['orderNumber'] as String? ?? '',
      ProductId: json['productid'] as String? ?? '',
      price: Decimal.parse(json['price']?.toString() ?? '0'),
      refundAmount: Decimal.parse(json['refundamount']?.toString() ?? '0'),
      refundpercent: Decimal.parse(json['refundpercent']?.toString() ?? '0'),
      OrderTime: json['date'] as String? ?? '',
      isRefund: json['isRefund'] as bool? ?? false,
      refundState: json['refundState'] as bool? ?? false,
      refundTime: json['refundTime'] as String? ?? '',
      errorMessage: json['errorMessage'] as String? ?? '',
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "订单号：$orderid，订单编号：$orderNumber,产品id：$ProductId,订单价格：$price，返还金额：$refundAmount,订单扫描时间：$OrderTime,是否提现:$isRefund,订单状态：$refundState, 退款时间：$refundTime,错误信息：$errorMessage";
  }
}
