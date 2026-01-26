import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';


/// 统一验证码API服务（注册、找回密码通用）
class ApiVerificationService {

  /// 发送验证码
  Future<Response> sendCode(String email, BuildContext context) async {
    final dio = Provider.of<DioProvider>(context, listen: false).dio;
    return await dio.post(
      '/api/verification-code/send',
      data: {'email': email},
    );
  }

  /// 验证验证码
  Future<Response> verifyCode(String email, String code, BuildContext context) async {
    final dio = Provider.of<DioProvider>(context, listen: false).dio;
    return await dio.post(
      '/api/verification-code/verify',
      data: {'email': email, 'code': code},
    );
  }
}
