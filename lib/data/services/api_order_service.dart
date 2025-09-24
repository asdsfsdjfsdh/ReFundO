// 访问后端订单扫描数据
import 'package:refundo/models/order_model.dart';

class ApiOrderService{

  // 获取订单数
  Future<List<OrderModel>> getOrders() async{
    // 暂时占位
    List<OrderModel> orders = [
      OrderModel(id: "1", value: 10, refundAmount: 3, timestamp: DateTime.timestamp(), isRefund: false),
      OrderModel(id: "2", value: 20, refundAmount: 3, timestamp: DateTime.timestamp(), isRefund: false),
      OrderModel(id: "3", value: 30, refundAmount: 3, timestamp: DateTime.timestamp(), isRefund: true),
      OrderModel(id: "4", value: 40, refundAmount: 3, timestamp: DateTime.timestamp(), isRefund: true),
    ];
    return orders;
  }
}