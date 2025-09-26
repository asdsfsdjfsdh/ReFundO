import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 订单的provider方法
class OrderProvider with ChangeNotifier{
  List<OrderModel>? _orders;
  final ApiOrderService _orderService = ApiOrderService();

  List<OrderModel>? get orders => _orders;

  // 获取订单信息
  Future<void> getOrders() async{
   try{
     final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token') ?? '';
    print("token: $token");
    print(token.isEmpty);
    if(token.isNotEmpty){
     
      try{
         _orders = await _orderService.getOrders();
          notifyListeners();
      }on DioException catch(e){
        print(token);
        print("Dio错误详情:");
        print("请求URL: ${e.requestOptions.uri}");
        print("请求方法: ${e.requestOptions.method}");
        print("请求头: ${e.requestOptions.headers}");
        print("请求体: ${e.requestOptions.data}");
        print("响应状态码: ${e.response?.statusCode}");
        print("响应数据: ${e.response?.data}");
        rethrow;
      }
   }else{
    _orders = [];
     notifyListeners();
   }
   }catch(e){
      print("获取订单失败: $e");
       _orders = [];
       notifyListeners();
   }
  }

  // 清除订单信息
  void clearOrders(){
    _orders = [];
    notifyListeners();
  }
}