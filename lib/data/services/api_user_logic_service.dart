import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/models/user_model.dart';
import 'package:dio/dio.dart';

class ApiUserLogicService {
  // 登入
  Future<UserModel> logic(String username, String password,BuildContext context ) async {
    try {
      print(username + password);
      DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);
      Response response = await dioProvider.dio.post(
        "/api/user/login",
        data: {"userName": username, "password": password},
      );
      final Map<String, dynamic> responseData = response.data;

      // 完全按照新格式处理：{"message": null, "data": {...}, "code": 1}
      if (responseData['code'] != null && responseData['code'] == 1 && responseData['data'] != null) {
        // 新格式处理 - 传递 successMessageKey
        UserModel user = UserModel.fromJson(responseData, successMessageKey: 'login_success');
        if (user.token != null) {
          await dioProvider.saveToken(user.token!);
        }
        return user;
      } else {
        // 如果不是新格式，返回错误信息
        String message = responseData['message'] ?? 'unknown_error';
        return UserModel.fromJson({}, errorMessage: message);
      }
    } on DioException catch (e) {
      String message = '占位错误';
      print("Dio错误详情:");
      print("请求URL: ${e.requestOptions.uri}");
      print("请求方法: ${e.requestOptions.method}");
      print("请求头: ${e.requestOptions.headers}");
      print("请求体: ${e.requestOptions.data}");
      print("响应状态码: ${e.response?.statusCode}");
      print("响应数据: ${e.response?.data}");
      // 处理Dio相关的异常 - 使用本地化键
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // 请求超时
        message = 'network_timeout';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = 'network_error';
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        } else {
          message = 'unknown_error';
        }
      } else {
        message = 'network_error';
      }
      return UserModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      return UserModel.fromJson({}, errorMessage: 'unknown_error');
    }
    // return UserModel(username: username, userAccount: username, AmountSum: 30,RefundedAmount:100,Email:'',CardNumber:'');
  }

  //获取用户信息
  Future<UserModel> getUserInfo(BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);
      Response response = await dioProvider.dio.get(
        "/api/user",
      );
      Map<String, dynamic> responseData = response.data;

      // 完全按照新格式处理：{"message": null, "data": {...}, "code": 1}
      if (responseData['code'] != null && responseData['code'] == 1 && responseData['data'] != null) {
        // 新格式处理 - 传递 successMessageKey
        return UserModel.fromJson(responseData, successMessageKey: 'get_user_info_success');
      } else {
        String message = responseData['message'] ?? 'unknown_error';
        return UserModel.fromJson({}, errorMessage: message);
      }
    }  on DioException catch (e) {
      String message = '占位错误';
      print("Dio错误详情:");
      print("请求URL: ${e.requestOptions.uri}");
      print("请求方法: ${e.requestOptions.method}");
      print("请求头: ${e.requestOptions.headers}");
      print("请求体: ${e.requestOptions.data}");
      print("响应状态码: ${e.response?.statusCode}");
      print("响应数据: ${e.response?.data}");
      // 处理Dio相关的异常 - 使用本地化键
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // 请求超时
        message = 'network_timeout';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = 'network_error';
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        } else {
          message = 'unknown_error';
        }
      } else {
        message = 'network_error';
      }
      return UserModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      return UserModel.fromJson({}, errorMessage: 'unknown_error');
    }
  }

  // 注册
  Future<UserModel> register(
    String username,
    String userEmail,
    String password,
    String verificationCode,
    BuildContext context
  ) async {
    try {
      Response response = await Provider.of<DioProvider>(context, listen: false).dio.post(
        "/api/user/signup",
        data: {"userName": username, "email": userEmail, "password": password, "verificationCode": verificationCode},
      );
      final Map<String, dynamic> responseData = response.data;

      // 完全按照新格式处理：{"message": null, "data": {...}, "code": 1}
      if (responseData['code'] != null && responseData['code'] == 1 && responseData['data'] != null) {
        // 新格式处理 - 传递 successMessageKey
        UserModel user = UserModel.fromJson(responseData, successMessageKey: 'register_success');
        if (user.token != null) {
          await Provider.of<DioProvider>(context, listen: false).saveToken(user.token!);
        }
        return user;
      } else {
        // 如果不是新格式，返回错误信息
        String message = responseData['message'] ?? 'unknown_error';
        return UserModel.fromJson({}, errorMessage: message);
      }
    }  on DioException catch (e) {
      String message = '占位错误';
      print("Dio错误详情:");
      print("请求URL: ${e.requestOptions.uri}");
      print("请求方法: ${e.requestOptions.method}");
      print("请求头: ${e.requestOptions.headers}");
      print("请求体: ${e.requestOptions.data}");
      print("响应状态码: ${e.response?.statusCode}");
      print("响应数据: ${e.response?.data}");
      // 处理Dio相关的异常 - 使用本地化键
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // 请求超时
        message = 'network_timeout';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = 'network_error';
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        } else {
          message = 'unknown_error';
        }
      } else {
        message = 'network_error';
      }
      return UserModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      return UserModel.fromJson({}, errorMessage: 'unknown_error');
    }
  }

  //修改用户数据
  Future<UserModel> updateUserInfo(
    UserModel userModel,
    BuildContext context,
    {String successMessageKey = 'update_success'}
  ) async {
    try {
      Response response = await Provider.of<DioProvider>(context, listen: false).dio.put(
        "/api/user",
        data: userModel.toJson(),
      );
      Map<String, dynamic> responseData = response.data;

      // 完全按照新格式处理：{"message": null, "data": {...}, "code": 1}
      if (responseData['code'] != null && responseData['code'] == 1 && responseData['data'] != null) {
        // 新格式处理 - 传递 successMessageKey
        return UserModel.fromJson(responseData, successMessageKey: successMessageKey);
      } else {
        String message = responseData['message'] ?? 'unknown_error';
        return UserModel.fromJson({}, errorMessage: message);
      }
    }on DioException catch (e) {
      String message = '占位错误';
      print("Dio错误详情:");
      print("请求URL: ${e.requestOptions.uri}");
      print("请求方法: ${e.requestOptions.method}");
      print("请求头: ${e.requestOptions.headers}");
      print("请求体: ${e.requestOptions.data}");
      print("响应状态码: ${e.response?.statusCode}");
      print("响应数据: ${e.response?.data}");
      // 处理Dio相关的异常 - 使用本地化键
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // 请求超时
        message = 'network_timeout';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = 'network_error';
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        } else {
          message = 'unknown_error';
        }
      } else {
        message = 'network_error';
      }
      return UserModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      return UserModel.fromJson({}, errorMessage: 'unknown_error');
    }
  }

  //用户信息验证
  Future<String> verifyUserInfo(
    String email,
    String password,
    BuildContext context
  ) async {
    try {
      Response response = await Provider.of<DioProvider>(context, listen: false).dio.post(
        "/api/user/check",
        data: {
          "email": email,
          "password": password,
        }
      );
      String message = response.data["code"].toString();
      return message;
    } on DioException catch (e) {
      String message = '占位错误';
      if (kDebugMode) {
        print("Dio错误详情:");
        print("请求URL: ${e.requestOptions.uri}");
        print("请求方法: ${e.requestOptions.method}");
        print("请求头: ${e.requestOptions.headers}");
        print("请求体: ${e.requestOptions.data}");
        print("响应状态码: ${e.response?.statusCode}");
        print("响应数据: ${e.response?.data}");
      }
      // 处理Dio相关的异常 - 使用本地化键
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // 请求超时
        message = 'network_timeout';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        // 服务器不可达或网络连接失败
        message = 'network_error';
      } else if (e.response != null) {
        // 服务器返回错误状态码
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        } else {
          message = 'unknown_error';
        }
      } else {
        message = 'network_error';
      }
      return message;
    } catch (e) {
      // 处理其他异常
      if (kDebugMode) {
        print('未知错误: $e');
      }
      return 'unknown_error';
    }
  }
}