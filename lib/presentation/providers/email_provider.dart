import 'package:flutter/material.dart';
import 'package:refundo/data/services/api_email_service.dart';

class EmailProvider extends ChangeNotifier{
  String _email = '';
  final ApiEmailService _service = ApiEmailService();

  String get email => _email;
  //设置email
  setEmail(String email) {
    _email = email;
    print(_email);
    notifyListeners();
  }

  Future<int?> sendEmail (String email, BuildContext context, int sendType) async {
    try{
      print(email);
      // 使用统一的发送验证码接口
      final message = await _service.sendVerificationCode(email, context);
      _email = email;
      return message;
    } catch (e) {
      _email = '';
      print(e.toString());
      return -1;
    } finally{
      notifyListeners();
    }
  }

  Future<int?> checkCode(String email, String code, BuildContext context) async {
    try{
      // 使用新的验证验证码接口
      final message = await _service.verifyCode(email, code, context);
      if(message == 200) {
        _email = email;
      }
      return message;
    } catch (e) {
      _email = '';
      print(e.toString());
      return -1;
    } finally{
      notifyListeners();
    }
  }
}