// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/utils/storage/setting_storage.dart';
import 'package:refundo/core/utils/storage/user_storage.dart';
import 'package:refundo/data/services/api_user_logic_service.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/home/provider/refund_provider.dart';
import 'package:refundo/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final ApiUserLogicService _service = ApiUserLogicService();
  bool _isLogin = false;
  bool _isManager = true;
  String _errorMessage = "";

  Function(double)? onloginSuccess;
  Function()? onlogout;
  Function()? onOrder;

  UserModel? get user => _user;
  bool get isLogin => _isLogin;
  String get errorMessage => _errorMessage;
  bool get isManager => _isManager;

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
  Future<Map<String, dynamic>> login(String username, String password,BuildContext context) async {
    try {
      UserModel user = await _service.logic(username, password,context);
      if (user.errorMessage.isNotEmpty) {
        LogUtil.e("登入", user.errorMessage);
        _isLogin = false;
        return {'success': false, 'message': user.errorMessage};
      } else {
        LogUtil.d("登入", "成功登入");
        _isLogin = true;
        _user = user;
        Provider.of<OrderProvider>(context, listen: false).getOrders(context);
        Provider.of<RefundProvider>(context, listen: false).getRefunds(context);
        return {'success': true, 'data': user, 'messageKey': user.successMessageKey};
      }
    } catch (e) {
      LogUtil.e("登入", e.toString());
      print(e.toString());
      return {'success': false, 'message': 'unknown_error'};
    } finally {
      notifyListeners();
    }
  }

  // 向后端请求注册
  Future<Map<String, dynamic>> register(
    String username,
    String userEmail,
    String password,
    String verificationCode,
    BuildContext context
  ) async {
    try {
      UserModel user =  await _service.register(username, userEmail, password, verificationCode, context);
      if (user.errorMessage.isNotEmpty) {
        _errorMessage = user.errorMessage;
        return {'success': false, 'message': user.errorMessage};
      } else {
        _user = user;
        _isLogin = true;
        return {'success': true, 'data': user, 'messageKey': user.successMessageKey};
      }
    } catch (e) {
      LogUtil.e("注册", e.toString());
      return {'success': false, 'message': 'unknown_error'};
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
      final refundProvider = Provider.of<RefundProvider>(context, listen: false);
      refundProvider.clearRefunds();
      orderProvider.clearOrders();
      print('Token cleared successfully');
    } catch (e) {
      LogUtil.d("账号", "注销失败$e");
    } finally {
      notifyListeners();
    }
  }

  // 获取用户信息
  Future<void> Info(BuildContext context) async {
    try {
      _user = await _service.getUserInfo(context);
      if (kDebugMode) {
        print("_user:$_user");
      }

    } catch (e) {
      LogUtil.e("获取用户信息", e.toString());
    } finally {
      notifyListeners();
    }
  }

  // 更新用户信息
  Future<Map<String, dynamic>> updateUserInfo(
    String info,
    int updateType,
    BuildContext context,
    [String? email]
  ) async {
    try {
      UserModel? user = _user;
      String successMessageKey;

      switch (updateType) {
        case 1:
          user?.userName = info;
          successMessageKey = 'update_username_success';
          break;
        case 2:
          user?.password = info;
          successMessageKey = 'update_password_success';
          break;
        case 3:
          print("email:$info");
          user?.email = info;
          successMessageKey = 'update_email_success';
          break;
        case 4:
          user?.phoneNumber = info;
          successMessageKey = 'update_phone_success';
          break;

        default:
          return {'success': false, 'message': 'unknown_error'};
      }

      user = await _service.updateUserInfo(user!, context, successMessageKey: successMessageKey);

      if(user.errorMessage.isEmpty){
        _user = user;
        return {'success': true, 'data': user, 'messageKey': successMessageKey};
      } else{
        LogUtil.e("更新用户信息", user.errorMessage);
        return {'success': false, 'message': user.errorMessage};
      }
    } catch (e) {
      LogUtil.e("更新用户信息", e.toString());
      return {'success': false, 'message': 'unknown_error'};
    } finally {
      notifyListeners();
    }
  } 

  //验证用户身份
  Future<Map<String, dynamic>> verifyUserIdentity(
    String email,
    String password,
    BuildContext context
  ) async {
    try {
      String message = await _service.verifyUserInfo(email, password, context);
      if(message == "1"){
        return {'success': true, 'message': 'verification_success'};
      } else {
        LogUtil.e("验证用户身份", message);
        return {'success': false, 'message': message};
      }
    } catch (e) {
      LogUtil.e("验证用户身份", e.toString());
      return {'success': false, 'message': 'unknown_error'};
    }
  }
}