// 访问后端返现数据
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';

class ApiRefundService {
  //用户获取退款记录
  Future<Map<String, dynamic>> getRefunds(BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );
      List<RefundModel> refunds = [];

      Response response = await dioProvider.dio.get('/api/refund-request/list');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1 && responseData['data'] != null) {
        List<dynamic> ordersRequest = responseData['data'];
        for (var i = 0; i < ordersRequest.length; i++) {
          Map<String, dynamic> ordersresult = ordersRequest[i];
          RefundModel refund = RefundModel.fromJson(ordersresult, successMessageKey: 'get_refunds_success');
          refunds.add(refund);
        }
        return {'success': true, 'data': refunds, 'message': 'get_refunds_success'};
      } else {
        return {'success': false, 'data': [], 'message': message ?? 'get_refunds_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      print("Dio错误详情:");
      print("请求URL: ${e.requestOptions.uri}");
      print("请求方法: ${e.requestOptions.method}");
      print("请求头: ${e.requestOptions.headers}");
      print("请求体: ${e.requestOptions.data}");
      print("响应状态码: ${e.response?.statusCode}");
      print("响应数据: ${e.response?.data}");

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
      print('未知错误: $e');
      return {'success': false, 'data': [], 'message': 'unknown_error'};
    }
  }

  // 管理员获取退款记录
  Future<Map<String, dynamic>> getAllRefunds(BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );
      List<RefundModel> refunds = [];

      Response response = await dioProvider.dio.post('/api/refund/getAll');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1 && responseData['result'] != null) {
        List<dynamic> ordersRequest = responseData['result'];
        for (var i = 0; i < ordersRequest.length; i++) {
          Map<String, dynamic> ordersresult = ordersRequest[i];
          RefundModel refund = RefundModel.fromJson(ordersresult, successMessageKey: 'get_refunds_success');
          refunds.add(refund);
        }
        return {'success': true, 'data': refunds, 'message': 'get_refunds_success'};
      } else {
        return {'success': false, 'data': [], 'message': message ?? 'get_refunds_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      print("Dio错误详情:");
      print("请求URL: ${e.requestOptions.uri}");
      print("请求方法: ${e.requestOptions.method}");
      print("请求头: ${e.requestOptions.headers}");
      print("请求体: ${e.requestOptions.data}");
      print("响应状态码: ${e.response?.statusCode}");
      print("响应数据: ${e.response?.data}");

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
      print('未知错误: $e');
      return {'success': false, 'data': [], 'message': 'unknown_error'};
    }
  }
}
