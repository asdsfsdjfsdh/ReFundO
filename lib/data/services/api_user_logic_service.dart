import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/models/user_model.dart';

class ApiUserLogicService{
  // 登入
  Future<UserModel> logic(String username,String password) async {
    return UserModel(username: username, userAccount: username, refundAll: 30,refundedAll:100);
  }

  // 注册
  Future<void> register(String username,String userEmail,String password) async {
    LogUtil.d("注册", "成功");
  }
}