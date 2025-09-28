// 访问后端订单扫描数据
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_user_logic_service.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/models/Product_model.dart';
import 'package:refundo/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiOrderService {
  bool _isInitialized = false;

  List<OrderModel> _orders = [];

  // 获取订单数
  Future<List<OrderModel>> getOrders(BuildContext context) async {
    DioProvider dioProvider = Provider.of<DioProvider>(
      context,
      listen: false,
    );
    _orders = [];

    Response response = await dioProvider.dio.post('/api/orders/init');
    // print(response);
    String message = response.data['message'];
    List<dynamic> ordersRequest = response.data['result'];
    for (var i = 0; i < ordersRequest.length; i++) {
      Map<String, dynamic> ordersresult = ordersRequest[i];
      OrderModel order = OrderModel.fromJson(ordersresult);
      _orders.add(order);
    }
    // print(_orders);
    return _orders;
  }

  // 添加订单
  Future<Map<String, dynamic>> insertOrder(ProductModel product, BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
      context,
      listen: false,
    );
      Response response = await dioProvider.dio.post(
        '/api/orders/insert',
        data: {
          "price": product.price,
          "productId": product.ProductId,
          "refundAmount": product.RefundAmount,
          "hash": product.Hash,
          "refundPercent": product.RefundPercent,
        },
      );
      print(response);
      OrderModel order = OrderModel.fromJson(response.data['result']);
      String message = response.data['message'];
      Map<String, dynamic> result = {
        "message": message,
        "result": order,
      };
      return result;
    } on DioException catch (e) {
      String message = '占位错误';
      Map<String, dynamic> result = {
        "message": message,
        "order": null,
      };
      print("Dio错误详情:");
      print("请求URL: ${e.requestOptions.uri}");
      print("请求方法: ${e.requestOptions.method}");
      print("请求头: ${e.requestOptions.headers}");
      print("请求体: ${e.requestOptions.data}");
      print("响应状态码: ${e.response?.statusCode}");
      print("响应数据: ${e.response?.data}");
      // 处理Dio相关的异常
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // 请求超时
        message = '请求超时: + ${e.message}';
        return result;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = '网络连接失败: 无法连接到服务器';
        return result;
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          print('服务器返回404错误: 请求的资源未找到');
        } else if (statusCode == 500) {
          print('服务器返回500错误: 服务器内部错误');
        } else {
          print('服务器返回错误状态码: $statusCode');
        }
      } else {
        print('网络请求异常: ${e.message}');
      }
      return result;
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: $e';
      Map<String, dynamic> result = {
        "message": message,
        "order": null,
      };
      return result;
    }
  }
}
