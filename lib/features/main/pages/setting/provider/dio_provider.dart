import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider extends ChangeNotifier {
 Dio _dio = Dio();

 Dio get dio => _dio;

 DioProvider() {
  // http://10.0.2.2
  _dio.options.baseUrl = "http://192.168.1.17:4040";
  _dio.options.contentType = Headers.jsonContentType; 

  // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 从 SharedPreferences 获取 Token
          String token = await getToken();

          if (token.isNotEmpty) {
            print('Token: $token');
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('响应状态码: ${response.statusCode}');
          print('响应数据: ${response.data}');
          return handler.next(response);
        },
        onError: (e, handler) async {
          // 处理 Token 过期
          if (e.response?.statusCode == 401) {
            // 重新获取 Token 或跳转到登录页
            print('Token expired, redirecting to login');
            // 在这里处理 Token 过期逻辑
          }
          return handler.next(e);
        },
      ),
    );
 }

  // 保存token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    print('Token saved successfully');
  }

  // 获取token
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }
}