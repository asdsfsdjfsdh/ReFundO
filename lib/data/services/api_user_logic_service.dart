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
        // 新格式处理
        UserModel user = UserModel.fromJson(responseData);
        if (user.token != null) {
          await dioProvider.saveToken(user.token!);
        }
        return user;
      } else {
        // 如果不是新格式，返回错误信息
        String message = responseData['message'] ?? '未知错误';
        return UserModel.fromJson({}, errorMessage: message);
      }
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
      return UserModel.fromJson({}, errorMessage: message);
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
      String message = '未知错误: $e';
      return UserModel.fromJson({}, errorMessage: message);
    }
    // return UserModel(username: username, userAccount: username, AmountSum: 30,RefundedAmount:100,Email:'',CardNumber:'');
  }

  //获取用户信息
  Future<UserModel> getUserInfo(BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);
      Response response = await dioProvider.dio.post(
        "/api/user/info",
      );
      Map<String, dynamic> responseData = response.data;
      
      // 完全按照新格式处理：{"message": null, "data": {...}, "code": 1}
      if (responseData['code'] != null && responseData['code'] == 1 && responseData['data'] != null) {
        // 新格式处理
        return UserModel.fromJson(responseData);
      } else {
        String message = responseData['message'] ?? '获取用户信息失败';
        return UserModel.fromJson({}, errorMessage: message);
      }
    }  on DioException catch (e) {
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
      Response response = await Provider.of<DioProvider>(context, listen: false).dio.post(
        "/api/user/register",
        data: {"name": username, "email": userEmail, "password": password},
      );
      final Map<String, dynamic> responseData = response.data;
      
      // 完全按照新格式处理：{"message": null, "data": {...}, "code": 1}
      if (responseData['code'] != null && responseData['code'] == 1 && responseData['data'] != null) {
        // 新格式处理
        UserModel user = UserModel.fromJson(responseData);
        if (user.token != null) {
          await Provider.of<DioProvider>(context, listen: false).saveToken(user.token!);
        }
        return user;
      } else {
        // 如果不是新格式，返回错误信息
        String message = responseData['message'] ?? '注册失败';
        return UserModel.fromJson({}, errorMessage: message);
      }
    }  on DioException catch (e) {
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
    BuildContext context
  ) async {
    try {
      Response response = await Provider.of<DioProvider>(context, listen: false).dio.put(
        "/api/user",
        data: userModel.toJson(),
      );
      Map<String, dynamic> responseData = response.data;
      
      // 完全按照新格式处理：{"message": null, "data": {...}, "code": 1}
      if (responseData['code'] != null && responseData['code'] == 1 && responseData['data'] != null) {
        // 新格式处理
        return UserModel.fromJson(responseData);
      } else {
        String message = responseData['message'] ?? '更新用户信息失败';
        return UserModel.fromJson({}, errorMessage: message);
      }
    }on DioException catch (e) {
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
      Map<String, dynamic> result = {"message": message, "order": null};
      if (kDebugMode) {
        print("Dio错误详情:");
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