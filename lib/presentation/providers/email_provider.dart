import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/data/services/api_email_service.dart';

class EmailProvider extends ChangeNotifier{
  String _email = '';
  ApiEmailService _service = ApiEmailService();
  
  String get Email => _email;
  //设置email
  setEmail(String email) {
    _email = email;
    print(_email);
    notifyListeners();
  }

  Future<int?> sendEmail (String email,BuildContext context,int SendType) async {
    try{
      print(email);
      int? message = 0;
      if(SendType == 1)
          message = await _service.sendEmail_findback(email,context);
      else
          message = await _service.sendEmail_register(email,context);
      _email = email;
      return message;
    } catch (e) {
      _email = '';
      print(e.toString());
      return -1;
    }finally{
      notifyListeners();
    }
  }

  Future<int?> checkCode(String email,String code,BuildContext context) async {
    try{
      final message = await _service.CheckCode(email,code,context);
      if(message == 200)
        _email = email;
      return message;
    } catch (e) {
      _email = '';
      print(e.toString());
      return -1;
    }finally{
      notifyListeners();
    }
  }
}