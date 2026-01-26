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
  Future<Map<String, dynamic>> getOrders(BuildContext context,bool isRefund) async {
    DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);
    List<OrderModel> _orders = [];

    try {
      Response response = await dioProvider.dio.get('/api/scan/records');

      // 解析新的响应结构
      String? message = response.data['message'];
      int code = response.data['code'] as int? ?? 0;

      if (code == 1 && response.data['data'] != null) {
        List<dynamic> ordersRequest = response.data['data'];
        for (var i = 0; i < ordersRequest.length; i++) {
          Map<String, dynamic> ordersresult = ordersRequest[i];
          OrderModel order = OrderModel.fromJson(ordersresult, successMessageKey: 'get_orders_success');
          _orders.add(order);
        }
        return {'success': true, 'data': _orders, 'message': 'get_orders_success'};
      } else {
        String errorMessage = message ?? 'unknown_error';
        if (kDebugMode) {
          print('获取订单失败: $message');
        }
        return {'success': false, 'data': [], 'message': errorMessage};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      if (kDebugMode) {
        print("Dio错误详情:");
        print("请求URL: ${e.requestOptions.uri}");
        print("请求方法: ${e.requestOptions.method}");
        print("响应状态码: ${e.response?.statusCode}");
      }
      // 处理Dio相关的异常 - 使用本地化键
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'network_timeout';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        }
      }
      return {'success': false, 'data': [], 'message': message};
    } catch (e) {
      if (kDebugMode) {
        print('未知错误: $e');
      }
      return {'success': false, 'data': [], 'message': 'unknown_error'};
    }
  }

  // 添加订单
  Future<OrderModel> insertOrder(
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
      String? message = response.data['message'] as String? ?? '';
      if (response.data['code'] == 1) {
        // 成功 - 返回带有 successMessageKey 的 OrderModel
        return OrderModel.fromJson({}, successMessageKey: 'create_order_success');
      }
      // 失败 - 返回带有 errorMessage 的 OrderModel
      return OrderModel.fromJson({}, errorMessage: message);
    } on DioException catch (e) {
      String message = 'network_error';
      if (kDebugMode) {
        print("Dio错误详情:");
        print("请求URL: ${e.requestOptions.uri}");
        print("请求方法: ${e.requestOptions.method}");
        print("请求头: ${e.requestOptions.headers}");
        print("请求体: ${e.requestOptions.data}");
        print("响应状态码: ${e.response?.statusCode}");
        print("响应数据: ${e.response?.data}");
      }
      // 处理Dio相关的异常 - 使用本地化键
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // 请求超时
        message = 'network_timeout';
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        } else {
          message = 'unknown_error';
        }
      } else {
        message = 'unknown_error';
      }
      return OrderModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      return OrderModel.fromJson({}, errorMessage: 'unknown_error');
    }
  }

  // 检查退款条件
  Future<Map<String, dynamic>> checkRefundConditions(BuildContext context, Set<OrderModel> orders) async {
    DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);
    try {
      List<Map<String, dynamic>> ordersJson = orders.map((order) => order.toJson()).toList();
      Response response = await dioProvider.dio.post('/api/orders/check',
        data: {
          "orders" : ordersJson
        }
      );

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1) {
        return {'success': true, 'message': 'check_refund_success'};
      } else {
        return {'success': false, 'message': message ?? 'check_refund_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      if (kDebugMode) {
        print("Dio错误详情:");
        print("请求URL: ${e.requestOptions.uri}");
        print("请求方法: ${e.requestOptions.method}");
        print("请求头: ${e.requestOptions.headers}");
        print("请求体: ${e.requestOptions.data}");
        print("响应状态码: ${e.response?.statusCode}");
        print("响应数据: ${e.response?.data}");
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'network_timeout';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        }
      }
      return {'success': false, 'message': message};
    } catch (e) {
      if (kDebugMode) {
        print('未知错误: $e');
      }
      return {'success': false, 'message': 'unknown_error'};
    }
  }

  // 退款功能
  Future<Map<String, dynamic>> Refund(BuildContext context,Set<OrderModel> orders,int refundType,String refundAccount,String voucherUrl) async{
    DioProvider dioProvider = Provider.of<DioProvider>(context,listen: false);
    try{
      //提取ScanId拼接成字符串，用,分隔
      String scanIds = orders.map((order) => order.scanId).join(',');

      Map<String, dynamic> requestData = {
        "scanIds" : scanIds,
        "paymentMethod" : refundType,
        "paymentNumber": refundAccount,
      };

      // 如果有优惠凭证URL，添加到请求中
      if (voucherUrl.isNotEmpty) {
        requestData["voucherUrl"] = voucherUrl;
      }

      Response response = await dioProvider.dio.post(
        "/api/refund-request",
        data: requestData,
      );

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1) {
        return {'success': true, 'message': 'refund_success'};
      } else {
        return {'success': false, 'message': message ?? 'refund_failed'};
      }
    }on DioException catch (e) {
      String message = 'network_error';
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
        message = 'network_timeout';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        }
      }
      return {'success': false, 'message': message};
    } catch (e) {
      if (kDebugMode) {
        print('未知错误: $e');
      }
      return {'success': false, 'message': 'unknown_error'};
    }
  }
}