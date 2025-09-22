import 'package:flutter/foundation.dart';

class LogUtil{

  // 提示弹幕
  static void d(String tag,dynamic msg){
    if (kDebugMode) {
      print('🐛 $tag:$msg');
    }
  }

  // 错误弹幕
  static void e(String tag, dynamic msg, [dynamic error,StackTrace? stackTrace]){
    if (kDebugMode) {
      print('❌ $tag: $msg ${error != null ? '\nError: $error' : ''}');
      if(stackTrace != null) print(stackTrace);
    }
  }
}