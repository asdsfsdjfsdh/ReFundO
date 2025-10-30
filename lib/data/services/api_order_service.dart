// 访问后端订单扫描数据
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_user_logic_service.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/models/Product_model.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiOrderService {
  bool _isInitialized = false;

  // 获取订单数
  Future<List<OrderModel>> getOrders(BuildContext context,bool isRefund) async {
    DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);
    List<OrderModel> _orders = [];

    Response response = await dioProvider.dio.post('/api/orders/init',
    data: {
      "isRefund": isRefund
    });
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
  Future<Map<String, dynamic>> insertOrder(
    ProductModel product,
    BuildContext context,
  ) async {
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
      if (kDebugMode) {
        print(response);
      }
      if (response.data['result'] != null) {
        OrderModel order = OrderModel.fromJson(response.data['result']);
        String message = response.data['message'];
        Map<String, dynamic> result = {"message": message, "result": order};
        return result;
      } else {
        // 处理 result 为空的情况
        String message = response.data['message'];
        Map<String, dynamic> result = {"message": message, "result": null};
        return result;
      }
    } on DioException catch (e) {
      String message = '占位错误';
      Map<String, dynamic> result = {"message": message, "order": null};
      if (kDebugMode) {
        print("Dio错误详情:");
        print("请求URL: ${e.requestOptions.uri}");
        print("请求方法: ${e.requestOptions.method}");
        print("请求头: ${e.requestOptions.headers}");
        print("请求体: ${e.requestOptions.data}");
        print("响应状态码: ${e.response?.statusCode}");
        print("响应数据: ${e.response?.data}");
      }
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
          if (kDebugMode) {
            print('服务器返回404错误: 请求的资源未找到');
          }
        } else if (statusCode == 500) {
          if (kDebugMode) {
            print('服务器返回500错误: 服务器内部错误');
          }
        } else {
          if (kDebugMode) {
            print('服务器返回错误状态码: $statusCode');
          }
        }
      } else {
        if (kDebugMode) {
          print('网络请求异常: ${e.message}');
        }
      }
      return result;
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: $e';
      Map<String, dynamic> result = {"message": message, "order": null};
      return result;
    }
  }

  // 退款功能
  Future<int> Refund(BuildContext context,Set<OrderModel> orders) async{
    DioProvider dioProvider = Provider.of<DioProvider>(context,listen: false);
    try{
      List<Map<String, dynamic>> ordersJson = orders.map((order) => order.toJson()).toList();
      if (kDebugMode) {
        print(ordersJson);
      }
      Response response = await dioProvider.dio.post(
        "/api/orders/refund",
        data: ordersJson
      );
      String message = response.data['message'];
      // UserModel user = response.data['result'];

      return 1;
    }on DioException catch (e) {
      String message = '占位错误';
      Map<String, dynamic> result = {"message": message, "order": null};
      if (kDebugMode) {
        print("Dio错误详情:");
        print("请求URL: ${e.requestOptions.uri}");
        print("请求方法: ${e.requestOptions.method}");
        print("请求头: ${e.requestOptions.headers}");
        print("请求体: ${e.requestOptions.data}");
        print("响应状态码: ${e.response?.statusCode}");
        print("响应数据: ${e.response?.data}");
      }
      // 处理Dio相关的异常
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // 请求超时
        message = '请求超时: + ${e.message}';
        return -1;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = '网络连接失败: 无法连接到服务器';
        return -1;
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          if (kDebugMode) {
            print('服务器返回404错误: 请求的资源未找到');
          }
        } else if (statusCode == 500) {
          if (kDebugMode) {
            print('服务器返回500错误: 服务器内部错误');
          }
        } else {
          if (kDebugMode) {
            print('服务器返回错误状态码: $statusCode');
          }
        }
      } else {
        if (kDebugMode) {
          print('网络请求异常: ${e.message}');
        }
      }
      return -1;
    } catch (e) {
      // 处理其他异常
      if (kDebugMode) {
        print('未知错误: $e');
      }
      String message = '未知错误: $e';
      Map<String, dynamic> result = {"message": message, "order": null};
      return 0;
    }
  }
}
