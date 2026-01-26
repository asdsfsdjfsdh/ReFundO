// 访问后端反馈数据
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/models/feedback_model.dart';

class ApiFeedbackService {
  /// 提交反馈
  Future<Map<String, dynamic>> submitFeedback({
    required String content,
    required int feedbackType,
    String? contactInfo,
    String? attachmentUrl,
    required BuildContext context,
  }) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );

      final formData = FormData.fromMap({
        'content': content,
        'feedbackType': feedbackType,
        if (contactInfo != null && contactInfo.isNotEmpty) 'contactInfo': contactInfo,
        if (attachmentUrl != null && attachmentUrl.isNotEmpty) 'attachmentUrl': attachmentUrl,
      });

      Response response = await dioProvider.dio.post(
        '/api/feedback/submit',
        data: formData,
      );

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1) {
        return {'success': true, 'message': 'feedback_submit_success'};
      } else {
        return {'success': false, 'message': message ?? 'feedback_submit_failed'};
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
      return {'success': false, 'message': message};
    } catch (e) {
      print('未知错误: $e');
      return {'success': false, 'message': 'unknown_error'};
    }
  }

  /// 上传附件 (使用已有的 CommonController)
  Future<Map<String, dynamic>> uploadAttachment(File file, BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });

      Response response = await dioProvider.dio.post(
        '/api/common/upload',
        data: formData,
      );

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;

      if (code == 1 && responseData['data'] != null) {
        return {'success': true, 'data': responseData['data'] as String};
      }
      return {'success': false, 'message': 'error_upload_failed'};
    } on DioException catch (e) {
      print('上传文件Dio错误: $e');
      return {'success': false, 'message': 'network_error'};
    } catch (e) {
      print('上传文件未知错误: $e');
      return {'success': false, 'message': 'unknown_error'};
    }
  }

  /// 获取我的反馈列表
  Future<Map<String, dynamic>> getMyFeedbacks(BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );
      List<FeedbackModel> feedbacks = [];

      Response response = await dioProvider.dio.get('/api/feedback/my-feedbacks');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1 && responseData['data'] != null) {
        List<dynamic> feedbackList = responseData['data'];
        for (var item in feedbackList) {
          Map<String, dynamic> feedbackData = item as Map<String, dynamic>;
          FeedbackModel feedback = FeedbackModel.fromJson(feedbackData);
          feedbacks.add(feedback);
        }
        return {'success': true, 'data': feedbacks, 'message': 'get_feedbacks_success'};
      } else {
        return {'success': false, 'data': [], 'message': message ?? 'get_feedbacks_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      print("Dio错误详情:");
      print("请求URL: ${e.requestOptions.uri}");
      print("请求方法: ${e.requestOptions.method}");
      print("请求头: ${e.requestOptions.headers}");
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

  /// 撤回反馈
  Future<Map<String, dynamic>> withdrawFeedback(int feedbackId, BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );

      Response response = await dioProvider.dio.put('/api/feedback/withdraw/$feedbackId');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1) {
        return {'success': true, 'message': 'feedback_withdraw_success'};
      } else {
        return {'success': false, 'message': message ?? 'feedback_withdraw_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      print("Dio错误详情:");
      print("请求URL: ${e.requestOptions.uri}");
      print("请求方法: ${e.requestOptions.method}");
      print("请求头: ${e.requestOptions.headers}");
      print("响应体: ${e.requestOptions.data}");
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
      return {'success': false, 'message': message};
    } catch (e) {
      print('未知错误: $e');
      return {'success': false, 'message': 'unknown_error'};
    }
  }
}
