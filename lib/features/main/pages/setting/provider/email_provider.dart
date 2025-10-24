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

  Future<String> sendEmail (String email,BuildContext context) async {
    try{
      print(email);
      String message = await _service.sendEmail(email,context);
      _email = email;
      return message;
    } catch (e) {
      _email = '';
      print(e.toString());
      return "Error";
    }finally{
      notifyListeners();
    }
  }

  Future<String> checkCode(String email,String code,BuildContext context) async {
    try{
      String message = await _service.CheckCode(email,code,context);
      _email = email;
      return message;
    } catch (e) {
      _email = '';
      print(e.toString());
      return "Error";
    }finally{
      notifyListeners();
    }
  }
}