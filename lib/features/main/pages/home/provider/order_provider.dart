import 'package:decimal/decimal.dart';
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
          final result = await _orderService.getOrders(context, false);
          if (result['success'] == true) {
            _orders = result['data'] as List<OrderModel>;
          } else {
            _orders = [];
          }
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
    } finally {
      notifyListeners();
    }
  }

  // 添加订单信息
  Future<Map<String, dynamic>> insertOrder(ProductModel product, BuildContext context) async {
    try {
      if (kDebugMode) {
        print(product);
      }
      //检查产品信息完整性
      if (product.ProductId != 0 &&
          product.Hash.isNotEmpty &&
          product.Value != Decimal.zero &&
          product.OriginalPrice != Decimal.zero &&
          product.RefundRatio != Decimal.zero) {
        //插入订单

        OrderModel result = await _orderService.insertOrder(product, context);
        if (kDebugMode) {
          print(result);
        }
        final orderResult = await _orderService.getOrders(context, false);
        if (orderResult['success'] == true) {
          _orders = orderResult['data'] as List<OrderModel>;
        }

        if (result.errorMessage.isNotEmpty) {
          return {'success': false, 'message': result.errorMessage};
        } else {
          return {'success': true, 'data': result, 'messageKey': result.successMessageKey};
        }
      } else {
        return {'success': false, 'message': 'invalid_product'};
      }
    } catch (e) {
      print("添加订单失败: $e");
      return {'success': false, 'message': 'unknown_error'};
    }finally {
      notifyListeners();
    }
  }

  // 清除订单信息
  void clearOrders() {
    _orders = [];
    notifyListeners();
  }
}
