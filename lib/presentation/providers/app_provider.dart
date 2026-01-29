import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  Locale _locale = const Locale('zh', 'CN'); // 默认中文

  Locale get locale => _locale;

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
}