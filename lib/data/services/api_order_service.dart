// 访问后端订单扫描数据
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_user_logic_service.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/data/models/Product_model.dart';
import 'package:refundo/data/models/order_model.dart';
import 'package:refundo/data/models/refund_model.dart';
import 'package:refundo/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiOrderService {
  bool _isInitialized = false;

  // 获取订单数（支持分页）
  Future<List<OrderModel>> getOrders(
    BuildContext context,
    bool isRefund, {
    int page = 1,
    int pageSize = 20,
  }) async {
    // 使用全局DioProvider实例
    DioProvider dioProvider = DioProvider.globalInstance;
    List<OrderModel> _orders = [];

    if (kDebugMode) {
      print('📋 获取订单列表: isRefund=$isRefund, page=$page, pageSize=$pageSize');
    }

    Response response = await dioProvider.dio.post(
      '/api/orders/init',
      data: {
        "isRefund": isRefund,
        "page": page,
        "pageSize": pageSize,
      },
    );

    if (kDebugMode) {
      print('📋 订单列表响应: ${response.data}');
    }

    // 处理后端返回的数据结构: {msg, code, data: {result: [...]}}
    final responseData = response.data;
    final data = responseData['data'];
    final result = data?['result'];

    if (kDebugMode) {
      print('📋 解析后的result: $result');
      print('📋 result类型: ${result.runtimeType}');
      if (result is List) {
        print('📋 result长度: ${result.length}');
      }
    }

    if (result != null && result is List) {
      for (var orderData in result) {
        Map<String, dynamic> ordersresult = orderData;
        OrderModel order = OrderModel.fromJson(ordersresult);
        _orders.add(order);
      }
    }

    if (kDebugMode) {
      print('📋 最终订单数量: ${_orders.length}');
    }

    return _orders;
  }

  // 获取订单总数
  Future<int> getOrdersCount(BuildContext context, bool isRefund) async {
    DioProvider dioProvider = DioProvider.globalInstance;

    try {
      Response response = await dioProvider.dio.post(
        '/api/orders/count',
        data: {
          "isRefund": isRefund,
        },
      );

      // 处理后端返回的数据结构: {msg, code, data: {result}}
      final data = response.data['data'];
      final result = data?['result'];
      return result ?? 0;
    } catch (e) {
      if (kDebugMode) {
        print('获取订单总数失败: $e');
      }
      return 0;
    }
  }

  // 添加订单
  Future<Map<String, dynamic>> insertOrder(
    ProductModel product,
    BuildContext context,
  ) async {
    try {
      DioProvider dioProvider = DioProvider.globalInstance;

      // 将Decimal转换为字符串以确保正确序列化
      final requestData = {
        "price": product.price.toString(),
        "productId": product.ProductId,
        "refundAmount": product.RefundAmount.toString(),
        "hash": product.Hash,
        "refundPercent": product.RefundPercent,
      };

      if (kDebugMode) {
        print('📦 发送订单数据: $requestData');
      }

      Response response = await dioProvider.dio.post(
        '/api/orders/insert',
        data: requestData,
      );

      if (kDebugMode) {
        print('📦 订单响应: ${response.data}');
      }

      // 检查响应状态码
      if (response.statusCode == 200) {
        final data = response.data;

        // 获取消息（支持 msg 和 message 两种字段名）
        String message = data['msg'] ?? data['message'] ?? '操作成功';

        // 检查是否有业务错误
        final code = data['code'];
        if (code != null && code != 200) {
          // 业务错误
          if (kDebugMode) {
            print('业务错误: $message (code: $code)');
          }
          return {"message": message, "result": null};
        }

        // 成功响应，解析订单数据
        final resultData = data['data'];
        final result = resultData?['result'];

        if (result != null) {
          OrderModel order = OrderModel.fromJson(result);
          return {"message": message, "result": order};
        } else {
          return {"message": message, "result": null};
        }
      } else {
        return {"message": "服务器返回异常状态码: ${response.statusCode}", "result": null};
      }
    } on DioException catch (e) {
      String message = '占位错误';
      Map<String, dynamic> result = {"message": message, "result": null};

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
        message = '请求超时: ${e.message}';
      } else if (e.type == DioExceptionType.connectionError) {
        // 服务器不可达或网络连接失败
        message = '网络连接失败: 无法连接到服务器';
      } else if (e.response != null) {
        // 服务器返回错误状态码，尝试提取错误消息
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;

        // 尝试从响应中提取错误消息
        if (responseData is Map) {
          message = responseData['msg'] ?? responseData['message'] ??
                   '服务器返回错误状态码: $statusCode';
        } else {
          message = '服务器返回错误状态码: $statusCode';
        }

        if (kDebugMode) {
          if (statusCode == 404) {
            print('服务器返回404错误: 请求的资源未找到');
          } else if (statusCode == 500) {
            print('服务器返回500错误: 服务器内部错误');
          } else {
            print('服务器返回错误状态码: $statusCode');
          }
        }
      } else {
        message = '网络请求异常: ${e.message}';
      }

      result["message"] = message;
      return result;
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: ${e.toString()}';
      return {"message": message, "result": null};
    }
  }

  // 检查退款条件
  Future<int> checkRefundConditions(BuildContext context, Set<OrderModel> orders) async {
    DioProvider dioProvider = DioProvider.globalInstance;
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
    DioProvider dioProvider = DioProvider.globalInstance;
    try{
      List<Map<String, dynamic>> ordersJson = orders.map((order) => order.toJson()).toList();
      if (kDebugMode) {
        print('📦 退款请求订单数据: $ordersJson');
      }

      Response response = await dioProvider.dio.post(
        "/api/refund/insert",
        data: {
          "orders" : ordersJson,
          "refundMethod" : refundType,
          "account": refundAccount,
        }
      );

      if (kDebugMode) {
        print('📦 退款响应: ${response.data}');
      }

      // 检查响应状态码
      if (response.statusCode == 200) {
        final data = response.data;

        // 获取消息（支持 msg 和 message 两种字段名）
        String message = data['msg'] ?? data['message'] ?? '操作成功';

        // 检查是否有业务错误
        final code = data['code'];
        if (code != null && code != 200) {
          // 业务错误
          if (kDebugMode) {
            print('❌ 退款业务错误: $message (code: $code)');
          }
          // 返回业务错误码
          if (code == 201) return 201; // 订单需满5个月
          if (code == 202) return 202; // 退款金额小于5000
          return -1;
        }

        // 成功
        if (kDebugMode) {
          print('✅ 退款申请成功');
        }
        return 1;
      } else {
        if (kDebugMode) {
          print('❌ 服务器返回异常状态码: ${response.statusCode}');
        }
        return -1;
      }
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
        message = '请求超时: ${e.message}';
        return -1;
      } else if (e.type == DioExceptionType.connectionError) {
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