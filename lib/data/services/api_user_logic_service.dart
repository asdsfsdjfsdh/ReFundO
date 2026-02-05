import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:refundo/core/utils/log_util.dart';

class ApiUserLogicService {
  // 登入
  Future<UserModel> logic(String username, String password, BuildContext context) async {
    try {
      LogUtil.n('API User Service', 'Login attempt: $username');
      DioProvider dioProvider = DioProvider.globalInstance;
      Response response = await dioProvider.dio.post(
        "/api/user/login",
        data: {"name": username, "password": password, "email": username},
      );
      final Map<String, dynamic> responseData = response.data;
      LogUtil.d('API Response', 'Full response: ${response.data}');

      // 处理后端返回的数据结构: {msg, code, data: {result: {token, user}}}
      final data = responseData['data'];
      final result = data?['result'];
      final message = responseData['msg'] ?? data?['message'] ?? 'Unknown error';

      if (result == null) {
        LogUtil.e('API User Service', 'Login failed: $message');
        return UserModel.fromJson({}, errorMessage: message);
      }

      // 安全地访问token和user
      final token = result['token'];
      final userData = result['user'];

      if (token != null) {
        await dioProvider.saveToken(token);
        LogUtil.d('API User Service', 'Token saved: ${token.substring(0, 20)}...');
      }

      if (userData != null) {
        UserModel user = UserModel.fromJson(userData);
        LogUtil.d('API User Service', 'Login successful for user: ${user.username}');
        return user;
      } else {
        LogUtil.e('API User Service', 'User data is null in response');
        return UserModel.fromJson({}, errorMessage: '用户数据为空');
      }
    } on DioException catch (e) {
      String message = '占位错误';
      if (kDebugMode) {
        LogUtil.e('API User Service', 'Dio错误详情:');
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
          message = '请求超时: ${e.message}';
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
      }
      return UserModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: $e';
      return UserModel.fromJson({}, errorMessage: message);
    }
  }

  //获取用户信息
  Future<UserModel> getUserInfo(BuildContext context) async {
    try {
      DioProvider dioProvider = DioProvider.globalInstance;
      Response response = await dioProvider.dio.post(
        "/api/user/info",
      );
      Map<String, dynamic> responseData = response.data;
      LogUtil.d('API Response', 'getUserInfo response: ${response.data}');

      // 处理后端返回的数据结构: {msg, code, data: {result: {...}}}
      final data = responseData['data'];
      final result = data?['result'];
      final message = responseData['msg'] ?? data?['message'] ?? 'Unknown error';

      if (result != null) {
        return UserModel.fromJson(result);
      } else {
        return UserModel.fromJson({}, errorMessage: message);
      }
    } on DioException catch (e) {
      String message = '占位错误';
      if (kDebugMode) {
        LogUtil.e('API User Service', 'Dio错误详情:');
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
          message = '请求超时: ${e.message}';
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
      }
      return UserModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: $e';
      return UserModel.fromJson({}, errorMessage: message);
    }
  }

  // 注册
  Future<UserModel> register(
    String username,
    String userEmail,
    String password,
    BuildContext context
  ) async {
    try {
      Response response = await DioProvider.globalInstance.dio.post(
        "/api/user/register",
        data: {"name": username, "email": userEmail, "password": password},
      );
      Map<String, dynamic> responseData = response.data;
      LogUtil.d('API Response', 'Register response: ${response.data}');

      // 处理后端返回的数据结构: {msg, code, data}
      final message = responseData['msg'] ?? responseData['message'] ?? '注册成功';
      return UserModel.fromJson({}, errorMessage: message);
    } on DioException catch (e) {
      String message = '占位错误';
      if (kDebugMode) {
        LogUtil.e('API User Service', 'Dio错误详情:');
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
          message = '请求超时: ${e.message}';
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
      }
      return UserModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误';
      return UserModel.fromJson({}, errorMessage: message);
    }
  }

  //修改用户数据
  Future<UserModel> updateUserInfo(
    UserModel userModel,
    int updateType,
    BuildContext context
  ) async {
    try {
      Response response = await DioProvider.globalInstance.dio.post(
        "/api/user/update",
        data: {
          "user": userModel.toJson(),
          "updateType": updateType
        }
      );
      Map<String, dynamic> responseData = response.data;
      LogUtil.d('API Response', 'Update user response: ${response.data}');

      // 处理后端返回的数据结构: {msg, code, data: {result: {...}}}
      final data = responseData['data'];
      final result = data?['result'];
      final message = responseData['msg'] ?? data?['message'] ?? '更新成功';

      if (result != null) {
        return UserModel.fromJson(result);
      } else {
        return UserModel.fromJson({}, errorMessage: message);
      }
    } on DioException catch (e) {
      String message = '占位错误';
      if (kDebugMode) {
        LogUtil.e('API User Service', 'Dio错误详情:');
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
          message = '请求超时: ${e.message}';
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
      }
      return UserModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: $e';
      return UserModel.fromJson({}, errorMessage: message);
    }
  }

  //用户信息验证
  Future<String> verifyUserInfo(
    String email,
    String password,
    BuildContext context
  ) async {
    try {
      Response response = await DioProvider.globalInstance.dio.post(
        "/api/user/check",
        data: {
          "email": email,
          "password": password,
        }
      );
      String message = response.data;
      return message;
    } on DioException catch (e) {
      String message = '占位错误';
      if (kDebugMode) {
        LogUtil.e('API User Service', 'Dio错误详情:');
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
      return message;
    } catch (e) {
      // 处理其他异常
      if (kDebugMode) {
        print('未知错误: $e');
      }
      String message = '未知错误: $e';
      return message;
    }
  }
}
