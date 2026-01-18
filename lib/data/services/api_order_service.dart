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
import 'package:refundo/models/refund_model.dart';
import 'package:refundo/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiOrderService {
  bool _isInitialized = false;

  // 获取订单数
  Future<List<OrderModel>> getOrders(BuildContext context,bool isRefund) async {
    DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);
    List<OrderModel> _orders = [];

    Response response = await dioProvider.dio.get('/api/scan/records');

    // 解析新的响应结构
    String? message = response.data['message'];
    int code = response.data['code'] as int? ?? 0;
    
    if (code == 1 && response.data['data'] != null) {
      List<dynamic> ordersRequest = response.data['data'];
      for (var i = 0; i < ordersRequest.length; i++) {
        Map<String, dynamic> ordersresult = ordersRequest[i];
        OrderModel order = OrderModel.fromJson(ordersresult);
        _orders.add(order);
      }
    } else {
      if (kDebugMode) {
        print('获取订单失败: $message');
      }
    }

    return _orders;
  }

  // 添加订单
  Future<String> insertOrder(
    ProductModel product,
    BuildContext context,
  ) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );
      Response response = await dioProvider.dio.post(
        '/api/scan/insert',
        data: {
            "productId": product.ProductId,
            "hash": product.Hash,
            "value": product.Value,
            "originalPrice": product.OriginalPrice,
            "refundRatio": product.RefundRatio,
        },
      );
      if (kDebugMode) {
        print(response);
      }
      String? message = response.data['message'] as String ? ?? '';
      if (response.data['code'] == 1) {
        message = "添加订单成功";
      } 
      return message;
    } on DioException catch (e) {
      String message = '网络异常';
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
        return message;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = '网络连接失败: 无法连接到服务器';
        return message;
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
      return message;
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: $e';
      Map<String, dynamic> result = {"message": message, "order": null};
      return message;
    }
  }

  // 检查退款条件
  Future<int> checkRefundConditions(BuildContext context, Set<OrderModel> orders) async {
    DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);
    try {
      List<Map<String, dynamic>> ordersJson = orders.map((order) => order.toJson()).toList();
      Response response = await dioProvider.dio.post('/api/orders/check',
        data: {
          "orders" : ordersJson
        }
      );
      return response.statusCode ?? -1;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Dio错误详情:");
        print("请求URL: ${e.requestOptions.uri}");
        print("请求方法: ${e.requestOptions.method}");
        print("请求头: ${e.requestOptions.headers}");
        print("请求体: ${e.requestOptions.data}");
        print("响应状态码: ${e.response?.statusCode}");
        print("响应数据: ${e.response?.data}");
      }
      
      if (e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    } catch (e) {
      // 处理其他异常
      if (kDebugMode) {
        print('未知错误: $e');
      }
      return -1;
    }
  }

  // 退款功能
  Future<int> Refund(BuildContext context,Set<OrderModel> orders,int refundType,String refundAccount) async{
    DioProvider dioProvider = Provider.of<DioProvider>(context,listen: false);
    try{
      //提取ScanId拼接成字符串，用,分隔
      String scanIds = orders.map((order) => order.scanId).join(',');
      // List<Map<String, dynamic>> ordersJson = orders.map((order) => order.toJson()).toList();
      // if (kDebugMode) {
      //   print(ordersJson);
      // }
      Response response = await dioProvider.dio.post(
        "/api/refund-request",
        data: {
          "scanIds" : scanIds,
          "paymentMethod" : refundType,
          "paymentNumber": refundAccount,
        }

      );

      int code = response.data['code'];
      return code;
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