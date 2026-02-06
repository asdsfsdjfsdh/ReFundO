import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';

class ApiEmailService {

  /// 发送验证码（找回密码/注册通用）
  /// 使用统一的后端接口: POST /api/verification-code/send
  Future<int?> sendVerificationCode(String email, BuildContext context) async {
    try {
      print('开始发送验证码邮件到: $email');
      Response response = await Provider.of<DioProvider>(context, listen: false).dio.post(
        '/api/verification-code/send',
        data: {
          'email': email
        }
      );
      print('验证码邮件发送成功，状态码: ${response.statusCode}');
      return response.statusCode;
    } on DioException catch (e) {
      String message = _handleDioError(e, '发送验证码');
      print('发送验证码失败: $message');
      return e.response?.statusCode ?? -1;
    } catch (e) {
      print('发送验证码未知错误: $e');
      return -1;
    }
  }

  /// 验证验证码
  /// 使用后端接口: POST /api/verification-code/verify
  Future<int?> verifyCode(String email, String code, BuildContext context) async {
    try {
      print('开始验证验证码: email=$email, code=$code');
      Response response = await Provider.of<DioProvider>(context, listen: false).dio.post(
        '/api/verification-code/verify',
        data: {
          'email': email,
          'code': code
        }
      );
      print('验证码验证成功，状态码: ${response.statusCode}');
      return response.statusCode;
    } on DioException catch (e) {
      String message = _handleDioError(e, '验证验证码');
      print('验证验证码失败: $message');
      return e.response?.statusCode ?? -1;
    } catch (e) {
      print('验证验证码未知错误: $e');
      return -1;
    }
  }

  /// 兼容旧方法：发送找回密码验证码
  @Deprecated('使用 sendVerificationCode 代替')
  Future<int?> sendEmail_findback(String email, BuildContext context) async {
    return sendVerificationCode(email, context);
  }

  /// 兼容旧方法：发送注册验证码
  @Deprecated('使用 sendVerificationCode 代替')
  Future<int?> sendEmail_register(String email, BuildContext context) async {
    return sendVerificationCode(email, context);
  }

  /// 兼容旧方法：检查验证码
  @Deprecated('使用 verifyCode 代替')
  Future<int?> CheckCode(String email, String code, BuildContext context) async {
    return verifyCode(email, code, context);
  }

  /// 统一的Dio错误处理
  String _handleDioError(DioException e, String operation) {
    print("Dio错误详情 [$operation]:");
    print("请求URL: ${e.requestOptions.uri}");
    print("请求方法: ${e.requestOptions.method}");
    print("请求头: ${e.requestOptions.headers}");
    print("请求体: ${e.requestOptions.data}");
    print("响应状态码: ${e.response?.statusCode}");
    print("响应数据: ${e.response?.data}");

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return '请求超时: ${e.message}';
    } else if (e.type == DioExceptionType.connectionError) {
      return '网络连接失败: 无法连接到服务器';
    } else if (e.response != null) {
      final statusCode = e.response!.statusCode;
      if (statusCode == 404) {
        return "服务器返回404错误: 请求的资源未找到";
      } else if (statusCode == 500) {
        return '服务器返回500错误: 服务器内部错误';
      } else {
        return '服务器返回错误状态码: $statusCode';
      }
    } else {
      return '网络请求异常: ${e.message}';
    }
  }
}
