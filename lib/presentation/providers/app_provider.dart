import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  Locale _locale = const Locale('zh', 'CN'); // 默认中文
  bool _isDarkMode = false; // 深色模式开关

  Locale get locale => _locale;
  bool get isDarkMode => _isDarkMode;

  // 从本地存储加载语言设置
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'zh';
    final countryCode = prefs.getString('countryCode') ?? 'CN';

    setLocale(Locale(languageCode, countryCode));
  }

  // 设置新语言
  Future<void> setLocale(Locale newLocale) async {
    if (_locale != newLocale) {
      _locale = newLocale;

      // 保存到本地存储
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);
      if (newLocale.countryCode != null) {
        await prefs.setString('countryCode', newLocale.countryCode!);
      }

      notifyListeners();
    }
  }

  // 更改语言
  void changeLocale(String languageCode) {
    switch (languageCode) {
      case 'zh':
        setLocale(const Locale('zh', 'CN'));
        break;
      case 'en':
        setLocale(const Locale('en', 'US'));
        break;
      case 'fr':
        setLocale(const Locale('fr', 'FR'));
        break;
      default:
        setLocale(const Locale('zh', 'CN'));
    }
  }

  // 切换深色模式
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }

  // 从本地存储加载深色模式设置
  Future<void> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = prefs.getBool('darkMode') ?? false;

    // 只在值变化时通知监听器
    if (_isDarkMode != newValue) {
      _isDarkMode = newValue;
      notifyListeners();
    }
  }

  // 设置深色模式（用于外部直接设置）
  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('darkMode', value);
      notifyListeners();
    }
  }
}