import 'package:shared_preferences/shared_preferences.dart';

class SettingStorage{
  static const String _keyRememberAccount = 'rememberAccount';

  static Future<void> saveRememberAccount(bool isRememberAccount) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberAccount, isRememberAccount);
  }

  static Future<bool?> getRememberAccount() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberAccount);
  }
}