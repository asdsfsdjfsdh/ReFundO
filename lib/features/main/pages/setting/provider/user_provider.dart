import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/utils/storage/setting_storage.dart';
import 'package:refundo/core/utils/storage/user_storage.dart';
import 'package:refundo/data/services/api_user_logic_service.dart';
import 'package:refundo/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final ApiUserLogicService _service = ApiUserLogicService();
  bool _isLogin = false;

  UserModel? get user => _user;
  bool get isLogin => _isLogin;

  // 初始化用户系统
  Future<void> initProvider() async {
    bool? isRemember = await SettingStorage.getRememberAccount();
    try {
      if (isRemember!) {
        String? username = await UserStorage.getUsername();
        String? password = await UserStorage.getPassword();
        String? Email = await UserStorage.getEmail();
        LogUtil.d("初始化：", "自动登入");
        login(username!, password!);
      }
    } catch (e) {
      SettingStorage.saveRememberAccount(false);
    }
  }

  // 向后端请求登入
  Future<UserModel> login(String username, String password) async {
    try {
      _user = await _service.logic(username, password);

      if (_user!.errorMessage.isNotEmpty) {
        LogUtil.e("登入", _user!.errorMessage);
        _isLogin = false;
      } else {
        LogUtil.d("登入", "成功登入");
        _isLogin = true;
      }

      return _user!;
    } catch (e) {
      LogUtil.e("登入", e.toString());
      return UserModel.fromJson({},errorMessage: e.toString());
    } finally {
      //
      notifyListeners();
    }
  }

  // 向后端请求注册
  Future<void> register(
    String username,
    String userEmail,
    String password,
  ) async {
    try {
      await _service.register(username, userEmail, password);
      LogUtil.d("注册", "成功注册账号");
    } catch (e) {
      LogUtil.e("注册", e.toString());
    } finally {
      notifyListeners();
    }
  }

  // 注销账号
  Future<void> logOut() async {
    try {
      _isLogin = false;
      _user = null;
      SettingStorage.saveRememberAccount(false);
    } catch (e) {
      LogUtil.d("账号", "注销失败$e");
    } finally {
      notifyListeners();
    }
  }
}
