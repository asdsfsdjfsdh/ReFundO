import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:refundo/core/utils/log_util.dart';

class ApiUserLogicService {
  // 登入
  Future<UserModel> logic(
    String username,
    String password,
    BuildContext context,
  ) async {
    try {
      LogUtil.n('API User Service', 'Login attempt: $username');
      DioProvider dioProvider = DioProvider.globalInstance;
      Response response = await dioProvider.dio.post(
        "/api/user/login",
        data: {"userName": username, "password": password, "email": username},
      );
      final Map<String, dynamic> responseData = response.data;
      LogUtil.d('API Response', 'Full response: ${response.data}');

      // 处理后端返回的数据结构: {msg, code, data: {result: UserLoginVO}}
      // UserLoginVO 直接包含: UserId, UserName, Balance, PhoneNumber, Email, Sangke, WAVE, Token
      final data = responseData['data'];
      final message = responseData?['message'];

      if (data == null) {
        LogUtil.e('API User Service', 'Login failed: $message');
        return UserModel.fromJson({}, errorMessage: message);
      }

      // result 直接是 UserLoginVO 结构
      final token = data['token'];
      if (token != null) {
        await dioProvider.saveToken(token);
        LogUtil.d(
          'API User Service',
          'Token saved: ${token.toString().substring(0, 20)}...',
        );
      }

      // 从 result 直接解析用户数据
      UserModel user = UserModel.fromJson(data);
      LogUtil.d(
        'API User Service',
        'Login successful for user: ${user.username} (userId: ${user.userId})',
      );
      return user;
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
      Response response = await dioProvider.dio.get("/api/user");
      Map<String, dynamic> responseData = response.data;
      LogUtil.d('API Response', 'getUserInfo response: ${response.data}');

      // 处理后端返回的数据结构: {msg, code, data: {result: {...}}}
      final data = responseData['data'];
      final message = responseData['message'];

      if (data != null) {
        return UserModel.fromJson(data);
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
    String verificationCode,
    BuildContext context,
  ) async {
    try {
      Response response = await DioProvider.globalInstance.dio.post(
        "/api/user/signup",
        data: {
          "userName": username,
          "email": userEmail,
          "password": password,
          "verificationCode": verificationCode,
        },
      );
      Map<String, dynamic> responseData = response.data;
      LogUtil.d('API Response', 'Register response: ${response.data}');

      // 处理后端返回的数据结构: {msg, code, data}
      final message = responseData['msg'] ?? responseData['message'] ?? AppLocalizations.of(context)!.registerSuccessDefault;
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
    BuildContext context,
  ) async {
    try {
      // 根据updateType构建请求数据，匹配UserUpdateDTO结构
      // 注意：密码修改请使用 updatePassword 方法
      Map<String, dynamic> requestData = {};
      switch (updateType) {
        case 1: // 用户名
          requestData = {"UserName": userModel.username};
          break;
        case 3: // 邮箱
          requestData = {"Email": userModel.email};
          break;
        case 4: // 手机号
          requestData = {"PhoneNumber": userModel.phoneNumber};
          break;
        default:
          requestData = {
            "UserName": userModel.username,
            "Email": userModel.email,
            "PhoneNumber": userModel.phoneNumber,
          };
      }
      Response response = await DioProvider.globalInstance.dio.put(
        "/api/user",
        data: userModel.toJson(),
      );
      Map<String, dynamic> responseData = response.data;
      LogUtil.d('API Response', 'Update user response: ${response.data}');

      // 处理后端返回的数据结构: {msg, code, data: {result: {...}}}
      final data = responseData['data'];
      final message = data?['message'] ?? AppLocalizations.of(context)!.updateSuccessMessage;

      if (data != null) {
        return UserModel.fromJson(data);
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
    BuildContext context,
  ) async {
    try {
      Response response = await DioProvider.globalInstance.dio.post(
        "/api/user/check",
        data: {"email": email, "password": password},
      );
      final l10n = AppLocalizations.of(context);
      String message = response.data['message'] ?? l10n!.verification_success;
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

  //更新密码（专用接口）
  Future<String> updatePassword(
    String newPassword,
    BuildContext context,
  ) async {
    try {
      Response response = await DioProvider.globalInstance.dio.put(
        "/api/user/password",
        queryParameters: {"newPassword": newPassword},
      );
      final l10n = AppLocalizations.of(context);
      Map<String, dynamic> responseData = response.data;
      final message = responseData['msg'] ?? l10n!.update_success;
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
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = '请求超时: ${e.message}';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = '网络连接失败: 无法连接到服务器';
      } else if (e.response != null) {
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
      if (kDebugMode) {
        print('未知错误: $e');
      }
      String message = '未知错误: $e';
      return message;
    }
  }

  //用户找回密码
  Future<UserModel?> resetPassword(String email, BuildContext context) async {
    try {
       LogUtil.n('API User Service', 'Reset password attempt: $email');
      DioProvider dioProvider = DioProvider.globalInstance;
      Response response = await dioProvider.dio.get(
        "/api/user/forget",
        queryParameters: {"email": email},
      );
      final Map<String, dynamic> responseData = response.data;
      LogUtil.d('API Response', 'Full response: ${response.data}');

      // 处理后端返回的数据结构: {msg, code, data: {result: UserLoginVO}}
      // UserLoginVO 直接包含: UserId, UserName, Balance, PhoneNumber, Email, Sangke, WAVE, Token
      final data = responseData['data'];
      final message =
          responseData['msg'] ?? data?['message'] ?? 'Unknown error';

      if (data == null) {
        LogUtil.e('API User Service', 'Login failed: $message');
        return UserModel.fromJson({}, errorMessage: message);
      }

      // result 直接是 UserLoginVO 结构
      final token = data['token'];
      if (token != null) {
        await dioProvider.saveToken(token);
        LogUtil.d(
          'API User Service',
          'Token saved: ${token.toString().substring(0, 20)}...',
        );
      }

      // 从 result 直接解析用户数据
      UserModel user = UserModel.fromJson(data);
      LogUtil.d(
        'API User Service',
        'Login successful for user: ${user.username} (userId: ${user.userId})',
      );
      return user;
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
}
