// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/utils/storage/setting_storage.dart';
import 'package:refundo/core/utils/storage/user_storage.dart';
import 'package:refundo/data/services/api_user_logic_service.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final ApiUserLogicService _service = ApiUserLogicService();
  bool _isLogin = false;

  Function(double)? onloginSuccess;
  Function()? onlogout;
  Function()? onOrder;

  UserModel? get user => _user;
  bool get isLogin => _isLogin;

  // 初始化用户系统
  Future<void> initProvider(BuildContext context) async {
    bool? isRemember = await SettingStorage.getRememberAccount();
    try {
      if (isRemember!) {
        String? username = await UserStorage.getUsername();
        String? password = await UserStorage.getPassword();
        String? Email = await UserStorage.getEmail();
        LogUtil.d("初始化：", "自动登入");
        login(username!, password!,context);
      
      }else{
         final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
      }
    } catch (e) {
      SettingStorage.saveRememberAccount(false);
    }
  }

  // 向后端请求登入
  Future<UserModel> login(String username, String password,BuildContext context) async {
    try {
      _user = await _service.logic(username, password,context);
      if (_user!.errorMessage.isNotEmpty) {
        LogUtil.e("登入", _user!.errorMessage);
        _isLogin = false;
      } else {
        LogUtil.d("登入", "成功登入");
        _isLogin = true;
      }
      // print("开始回调第一个函数");
      // onloginSuccess?.call(_user!.AmountSum);
      // print("第一个函数回调结束，开始回调第二个函数");
      // onOrder?.call();
      // print("第二个函数回调结束");
      Provider.of<OrderProvider>(context, listen: false).getOrders(context);
      return _user!;
    } catch (e) {
      LogUtil.e("登入", e.toString());
      return UserModel.fromJson({}, errorMessage: e.toString());
    } finally {
      notifyListeners();
    }
  }

  // 向后端请求注册
  Future<void> register(
    String username,
    String userEmail,
    String password,
    BuildContext context
  ) async {
    try {
      await _service.register(username, userEmail, password,context);
      LogUtil.d("注册", "成功注册账号");
    } catch (e) {
      LogUtil.e("注册", e.toString());
    } finally {
      notifyListeners();
    }
  }

  // 注销账号,清除token
  Future<void> logOut(BuildContext context) async {
    try {
      _isLogin = false;
      _user = null;
      SettingStorage.saveRememberAccount(false);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token'); // 移除 key 为 'access_token' 的存储
      //清除订单信息
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.clearOrders();
      print('Token cleared successfully');
    } catch (e) {
      LogUtil.d("账号", "注销失败$e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> Info(BuildContext context) async {
    try {
      _user = await _service.getUserInfo(context);
      print("_user:" + _user.toString());

    } catch (e) {
      LogUtil.e("获取用户信息", e.toString());
    } finally {
      notifyListeners();
    }
  } 
}
