import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/features/main/pages/home/home_page.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiUserLogicService {
  // 登入
  Future<UserModel> logic(String username, String password,BuildContext context ) async {
    try {
      print(username + password);
      DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);
      Response response = await dioProvider.dio.post(
        "/api/user/login",
        data: {"name": username, "password": password, "email": username},
      );
      final Map<String, dynamic> responseData = response.data;
      String message = responseData['message'];
      if (responseData['result'] == null) {
        return  UserModel.fromJson({}, errorMessage: message);
      } else {
        await dioProvider.saveToken(responseData['result']['token']);
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
    BuildContext context
  ) async {
    try {
      Response response = await Provider.of<DioProvider>(context, listen: false).dio.post(
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
