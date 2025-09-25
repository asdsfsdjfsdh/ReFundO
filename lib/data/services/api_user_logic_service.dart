import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiUserLogicService {
  final Dio _dio = Dio();

  ApiUserLogicService() {
    _dio.options.baseUrl = "http://10.0.2.2:4040";
    _dio.options.contentType = Headers.jsonContentType; //

    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 从 SharedPreferences 获取 Token
          String token = await _getToken();

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('请求地址: ${options.uri}');
          print('请求头: ${options.headers}');
          print('请求参数: ${options.data}');

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
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    print('Token saved successfully');
  }

  // 获取token
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  //清除token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token'); // 移除 key 为 'access_token' 的存储
    print('Token cleared successfully');
  }

  // 登入
  Future<UserModel> logic(String username, String password) async {
    try {
      print(username + password);
      Response response = await _dio.post(
        "/api/user/login",
        data: {"name": username, "password": password, "email": username},
      );
      final Map<String, dynamic> responseData = response.data;
      String message = responseData['message'];
      print(message);
      print(responseData['result']);
      if (responseData['result'] == null) {
        print(111);
        return  UserModel.fromJson({}, errorMessage: message);
      } else {
        print(responseData['result']['user']);
        await _saveToken(responseData['result']['token']);
        return UserModel.fromJson(responseData['result']['user']);
      }
    } catch (e) {
      // print(111);
      return Future.error(e.toString());
    }
    // return UserModel(username: username, userAccount: username, AmountSum: 30,RefundedAmount:100,Email:'',CardNumber:'');
  }

  // 注册
  Future<void> register(
    String username,
    String userEmail,
    String password,
  ) async {
    try {
      Response response = await _dio.post(
        "/api/user/register",
        data: {"name": username, "email": userEmail, "password": password},
      );
      final String responseData = response.data;

      print(responseData);
    } catch (e) {
      return Future.error(e.toString());
    }
    LogUtil.d("注册", "成功");
  }
}
