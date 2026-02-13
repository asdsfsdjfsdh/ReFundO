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
  int _totalOrders = 0;

  // 获取总订单数
  int get totalOrders => _totalOrders;

  // 获取订单数（支持分页）
  Future<List<OrderModel>> getOrders(
    BuildContext context,
    bool isRefund, {
    int page = 1,
    int pageSize = 20,
  }) async {
    DioProvider dioProvider = DioProvider.globalInstance;
    List<OrderModel> _orders = [];

    if (kDebugMode) {
      print('📋 获取订单列表: isRefund=$isRefund, page=$page, pageSize=$pageSize');
    }

    Response response = await dioProvider.dio.get(
      '/api/scan/records',
      queryParameters: {
        "pageNum": page,
        "pageSize": pageSize,
        "orderBy": "create_time",
        "orderDirection": "desc",
      },
    );

    if (kDebugMode) {
      print('📋 订单列表响应: ${response.data}');
    }

    // 处理后端返回的数据结构: {Code, Data: {records: [...], total, pageNum, pageSize, pages}}
    final code = response.data['code'];
    if (code != 1) {
      if (kDebugMode) {
        print('❌ 后端返回错误码: $code');
      }
      return _orders;
    }

    final data = response.data['data'];
    final records = data?['records'];
    _totalOrders = data?['total'] ?? 0;

    if (kDebugMode) {
      print('📋 总订单数: $_totalOrders');
    }

    if (kDebugMode) {
      print('📋 解析后的records: $records');
      print('📋 records类型: ${records.runtimeType}');
      if (records is List) {
        print('📋 records长度: ${records.length}');
      }
    }

    if (records != null && records is List) {
      for (var orderData in records) {
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
      Response response = await dioProvider.dio.get(
        '/api/scan/records',
        queryParameters: {
          "pageNum": 1,
          "pageSize": 1,
          "orderBy": "create_time",
          "orderDirection": "desc",
        },
      );

      // 从响应中获取 total
      final code = response.data['code'];
      if (code == 1) {
        final data = response.data['data'];
        return data?['total'] ?? 0;
      }
      return 0;
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
        "productId": product.ProductId,
        "originalPrice": product.price.toString(),
        "refundRatio": product.RefundPercent,
        "hash": product.Hash,
        "value": product.RefundAmount.toString(),
      };

      if (kDebugMode) {
        print('📦 发送订单数据: $requestData');
      }

      Response response = await dioProvider.dio.post(
        '/api/scan/insert',
        data: requestData,
      );

      if (kDebugMode) {
        print('📦 订单响应: ${response.data}');
      }

      // 检查响应状态码
      if (response.statusCode == 200) {
        final data = response.data;
        final code = data['code'];

        // 检查是否有业务错误
        if (code != 1) {
          final message = data['message'] ?? '操作失败';
          if (kDebugMode) {
            print('业务错误: $message (code: $code)');
          }
          return {"message": message, "result": null};
        }

        // 成功响应
        return {"message": "操作成功", "result": null};
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
        message = '请求超时: ${e.message}';
      } else if (e.type == DioExceptionType.connectionError) {
        message = '网络连接失败: 无法连接到服务器';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;

        if (responseData is Map) {
          message = responseData['Message'] ?? responseData['message'] ??
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
      print('未知错误: $e');
      String message = '未知错误: ${e.toString()}';
      return {"message": message, "result": null};
    }
  }

  // 检查退款条件 - 计算退款金额
  Future<Map<String, dynamic>> checkRefundConditions(BuildContext context, Set<OrderModel> orders) async {
    DioProvider dioProvider = DioProvider.globalInstance;
    try {
      // 将订单ID转换为逗号分隔的字符串
      String scanIds = orders.map((o) => o.orderid.toString()).join(',');

      if (kDebugMode) {
        print('📦 计算退款金额 scanIds: $scanIds');
      }

      Response response = await dioProvider.dio.get(
        '/api/refund-request/calculate-amount',
        queryParameters: {
          "scanIds": scanIds,
        },
      );

      final code = response.data['code'];
      if (code == 1) {
        final amount = response.data['data'];
        return {"success": true, "amount": amount};
      } else {
        final message = response.data['message'] ?? '计算失败';
        return {"success": false, "message": message};
      }
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
        final statusCode = e.response!.statusCode;
        return {"success": false, "message": "服务器返回错误状态码: $statusCode"};
      } else {
        return {"success": false, "message": "网络连接失败"};
      }
    } catch (e) {
      if (kDebugMode) {
        print('未知错误: $e');
      }
      return {"success": false, "message": "未知错误: ${e.toString()}"};
    }
  }

  // 退款功能
  Future<int> Refund(BuildContext context, Set<OrderModel> orders, int refundType, String refundAccount) async {
    DioProvider dioProvider = DioProvider.globalInstance;
    try {
      // 将订单ID转换为逗号分隔的字符串
      String scanIds = orders.map((o) => o.orderid.toString()).join(',');

      if (kDebugMode) {
        print('📦 退款请求 scanIds: $scanIds, refundType: $refundType, account: $refundAccount');
        print('📦 订单数量: ${orders.length}');
        for (var order in orders) {
          print('  - 订单ID: ${order.orderid}, 订单号: ${order.orderNumber}');
        }
      }

      final requestData = {
        "scanIds": scanIds,
        "paymentMethod": refundType,
        "paymentNumber": refundAccount,
      };

      if (kDebugMode) {
        print('📦 发送的JSON数据: $requestData');
      }

      Response response = await dioProvider.dio.post(
        "/api/refund-request",
        data: requestData,
      );

      if (kDebugMode) {
        print('📦 响应状态码: ${response.statusCode}');
        print('📦 退款响应: ${response.data}');
      }

      // 检查响应状态码
      if (response.statusCode == 200) {
        final data = response.data;
        final code = data['code'];

        if (code != 1) {
          final message = data['message'] ?? data['Message'] ?? '操作失败';
          if (kDebugMode) {
            print('❌ 退款业务错误: $message (code: $code)');
          }
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
        message = '请求超时: ${e.message}';
        return -1;
      } else if (e.type == DioExceptionType.connectionError) {
        message = '网络连接失败: 无法连接到服务器';
        return -1;
      } else if (e.response != null) {
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
      if (kDebugMode) {
        print('未知错误: $e');
      }
      String message = '未知错误: $e';
      Map<String, dynamic> result = {"message": message, "order": null};
      return 0;
    }
  }
}
