import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/models/Product_model.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 订单的provider方法
class OrderProvider with ChangeNotifier {
  List<OrderModel>? _orders;
  final ApiOrderService _orderService = ApiOrderService();

  List<OrderModel>? get orders => _orders;

  // 获取订单信息
  Future<void> getOrders(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('access_token') ?? '';
      if (kDebugMode) {
        print("token: $token");
        print(token.isEmpty);
      }
      if (token.isNotEmpty) {
        try {
          _orders = await _orderService.getOrders(context, false);
        } on DioException catch (e) {
          if (kDebugMode) {
            print(token);
            print("Dio错误详情:");
            print("请求URL: ${e.requestOptions.uri}");
            print("请求方法: ${e.requestOptions.method}");
            print("请求头: ${e.requestOptions.headers}");
            print("请求体: ${e.requestOptions.data}");
            print("响应状态码: ${e.response?.statusCode}");
            print("响应数据: ${e.response?.data}");
          }
          rethrow;
        }
      } else {
        _orders = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("获取订单失败: $e");
      }
      _orders = [];

    }finally {
      notifyListeners();
    }
  }

  // 添加订单信息
  Future<String> insertOrder(ProductModel product, BuildContext context) async {
    try {
      if (kDebugMode) {
        print(product);
      }
      //检查产品信息完整性
      if (product.ProductId != '' &&
          product.Hash != '' &&
          product.RefundAmount != -1 &&
          product.price != -1 &&
          product.RefundPercent != -1) {
        //插入订单
        
        Map<String, dynamic> result = await _orderService.insertOrder(product, context);
        if (kDebugMode) {
          print(result);
        }
        String message = result['message'];
        OrderModel? order = result['result'];
        if(order != null){
          _orders!.add(result['result']);
          Provider.of<UserProvider>(context, listen: false).Info(context);
          notifyListeners();
        }
        return message;
      } else {
        return "无效产品";
      }
    } catch (e) {
      print("添加订单失败: $e");
      return "添加订单失败: $e";
    }
  }

  // 清除订单信息
  void clearOrders() {
    _orders = [];
    notifyListeners();
  }
}
