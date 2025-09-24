// 访问后端订单扫描数据
import 'package:refundo/models/order_model.dart';

class ApiOrderService{

  // 获取订单数
  Future<List<OrderModel>> getOrders() async{
    // 暂时占位
    List<OrderModel> orders = [
      OrderModel(ProductId: "1", price: 10, refundAmount: 3, OrderTime: DateTime.timestamp(), isRefund: false),
      OrderModel(ProductId: "2", price: 20, refundAmount: 3, OrderTime: DateTime.timestamp(), isRefund: false),
      OrderModel(ProductId: "3", price: 30, refundAmount: 3, OrderTime: DateTime.timestamp(), isRefund: true),
      OrderModel(ProductId: "4", price: 40, refundAmount: 3, OrderTime: DateTime.timestamp(), isRefund: true),
    ];
    return orders;
  }
}