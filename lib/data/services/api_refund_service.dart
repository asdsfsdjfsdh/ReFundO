// 访问后端返现数据
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_order_service.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/data/models/order_model.dart';
import 'package:refundo/data/models/refund_model.dart';

class ApiRefundService {
  //用户获取退款记录
  Future<List<RefundModel>> getRefunds(BuildContext context) async {
    try {
      DioProvider dioProvider = DioProvider.globalInstance;
      List<RefundModel> refunds = [];

      Response response = await dioProvider.dio.post('/api/refund/get');

      // 处理后端返回的数据结构: {msg, code, data: {result: [...]}}
      final data = response.data['data'];
      final result = data?['result'];

      if (result != null && result is List) {
        for (var refundData in result) {
          Map<String, dynamic> refundResult = refundData;
          RefundModel refund = RefundModel.fromJson(refundResult);
          refunds.add(refund);
        }
      }

      return refunds;
    } on DioException catch (e) {
      String message = '占位错误';
      Map<String, dynamic> result = {"message": message, "order": null};
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
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = '网络连接失败: 无法连接到服务器';
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "服务器返回404错误: 请求的资源未找到";
        } else if (statusCode == 500) {
          message = '服务器返回500错误: 服务器内部错误';
        } else {
          message = '服务器返回错误状态码: $statusCode';
        }
      } else {
        message = '网络请求异常: ${e.message}';
      }
      return [];
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: $e';
      return [];
    }
  }

  // 管理员获取退款记录
  Future<List<RefundModel>> getAllRefunds(BuildContext context) async {
    try {
      DioProvider dioProvider = DioProvider.globalInstance;
      List<RefundModel> refunds = [];

      Response response = await dioProvider.dio.post('/api/refund/getAll');

      // 处理后端返回的数据结构: {msg, code, data: {result: [...]}}
      final data = response.data['data'];
      final result = data?['result'];

      if (result != null && result is List) {
        for (var refundData in result) {
          Map<String, dynamic> refundResult = refundData;
          RefundModel refund = RefundModel.fromJson(refundResult);
          refunds.add(refund);
        }
      }

      return refunds;
    } on DioException catch (e) {
      String message = '占位错误';
      Map<String, dynamic> result = {"message": message, "order": null};
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
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = '网络连接失败: 无法连接到服务器';
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "服务器返回404错误: 请求的资源未找到";
        } else if (statusCode == 500) {
          message = '服务器返回500错误: 服务器内部错误';
        } else {
          message = '服务器返回错误状态码: $statusCode';
        }
      } else {
        message = '网络请求异常: ${e.message}';
      }
      return [];
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: $e';
      return [];
    }
  }
}
