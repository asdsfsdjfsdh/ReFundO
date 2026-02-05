// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/utils/storage/setting_storage.dart';
import 'package:refundo/core/utils/storage/user_storage.dart';
import 'package:refundo/core/services/secure_storage_service.dart';
import 'package:refundo/data/services/api_user_logic_service.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/data/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final ApiUserLogicService _service = ApiUserLogicService();
  bool _isLogin = false;
  String _errorMessage = "";
  bool _isLoggingIn = false;  // 防止重复登录

  Function(double)? onloginSuccess;
  Function()? onlogout;
  Function()? onOrder;

  UserModel? get user => _user;
  bool get isLogin => _isLogin;
  String get errorMessage => _errorMessage;

  // 初始化用户系统
  Future<void> initProvider(BuildContext context) async {
    // 如果已经登录，直接返回
    if (_isLogin && _user != null) {
      LogUtil.d("初始化：", "用户已登录，跳过自动登入");
      return;
    }

    bool? isRemember = await SettingStorage.getRememberAccount();
    try {
      if (isRemember!) {
        String? username = await UserStorage.getUsername();
        String? password = await UserStorage.getPassword();
        String? Email = await UserStorage.getEmail();
        LogUtil.d("初始化：", "自动登入");
        await login(username!, password!, context);
      }else{
        // 使用安全存储清除认证信息
        await SecureStorageService.instance.clearAuthData();
      }
    } catch (e) {
      SettingStorage.saveRememberAccount(false);
    }
  }

  // 向后端请求登入
  Future<UserModel> login(String username, String password,BuildContext context) async {
    // 防止并发登录
    if (_isLoggingIn) {
      LogUtil.d("登入", "登录正在进行中，跳过重复请求");
      return _user ?? UserModel.fromJson({}, errorMessage: "登录正在进行中");
    }

    _isLoggingIn = true;

    try {
      LogUtil.d("登入", "开始登录请求");
      UserModel User = await _service.logic(username, password,context);
      if (User.errorMessage.isNotEmpty) {
        LogUtil.e("登入", User.errorMessage);
        _isLogin = false;
      } else {
        LogUtil.d("登入", "成功登入");
        _isLogin = true;
        _user = User;

        // 等待CSRF Token获取完成（通过短暂延迟确保异步操作完成）
        await Future.delayed(const Duration(milliseconds: 500));

        // 在context还有效时获取provider引用
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        final refundProvider = Provider.of<RefundProvider>(context, listen: false);

        // 使用WidgetsBinding确保在下一帧加载数据
        LogUtil.d("登入", "安排post-frame callback加载数据");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          LogUtil.d("登入", "Post-frame callback执行，开始加载订单和退款");
          // 先加载订单（不需要CSRF Token）
          orderProvider.getOrders(context).then((_) {
            // 订单加载完成后，直接加载退款（使用登录时获取的CSRF Token）
            LogUtil.d("登入", "订单加载完成，开始加载退款（使用现有CSRF Token）");
            refundProvider.getRefunds(context).catchError((e) {
              LogUtil.e("登入", "退款加载失败: $e");
            });
          });
        });
      }

      return User;
    } catch (e) {
      LogUtil.e("登入", e.toString());
      print(e.toString());
      return UserModel.fromJson({}, errorMessage: "Error");
    } finally {
      _isLoggingIn = false;
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
      UserModel User =  await _service.register(username, userEmail, password,context);
      _errorMessage = User.errorMessage;
      print(_errorMessage);
    } catch (e) {
      LogUtil.e("注册", e.toString());
      _errorMessage = "Error";
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

      // 使用安全存储清除 Token
      await SecureStorageService.instance.clearAuthData();

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
  Future<String> updateUserInfo(
    String Info,
    int updateType,
    BuildContext context,
    [String? email]
  ) async {
    try {
      UserModel? user = _user;

      switch (updateType) {
        case 1:
          user?.username = Info;
          break;
        case 2:
          if(email != null){
            user?.Email = email;
          }
          user?.password = Info;
          break;
        case 3:
          print("email:$Info");
          user?.Email = Info;
          break;
        case 4:
          user?.phoneNumber = Info;
          break;
        
        default:
          return "Error";
      }

      final updatedUser = await _service.updateUserInfo(user!,updateType,context);

      if(updatedUser.errorMessage.isEmpty){
        _user = updatedUser;
        return "修改成功";
      }else{
        LogUtil.e("更新用户信息", updatedUser.errorMessage);
        return updatedUser.errorMessage;
      }
    } catch (e) {
      LogUtil.e("更新用户信息", e.toString());
      return "Error";
    } finally {
      notifyListeners();
    }
  } 

  //验证用户身份
  Future<bool> verifyUserIdentity(
    String email,
    String password,
    BuildContext context
  ) async {
    try {
      String message = await _service.verifyUserInfo(email,password,context);
      if(message == "验证通过"){
        return true;
      } else {
        LogUtil.e("验证用户身份", message);
        return false;
      }
    } catch (e) {
      LogUtil.e("验证用户身份", e.toString());
      return false;
    }
  }

  // 注销账号（别名方法，保持命名一致性）
  Future<void> logout(BuildContext context) => logOut(context);
}
