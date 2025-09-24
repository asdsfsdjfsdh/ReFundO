import 'package:shared_preferences/shared_preferences.dart';

class UserStorage{
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';
  static const String _keyEmail = 'email';

  static Future<void> saveUsername(String username) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }

  static Future<String?> getUsername() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<void> savePassword(String username) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPassword, username);
  }

  static Future<String?> getPassword() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword);
  }

  static Future<void> saveEmail(String username) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, username);
  }

  static Future<String?> getEmail() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }
}