import 'package:flutter/foundation.dart';

class LogUtil{

  // 提示弹幕
  static void d(String tag, dynamic msg){
    if (kDebugMode) {
      print('🐛 $tag:$msg');
    }
  }

  // 信息日志
  static void i(String tag, dynamic msg){
    if (kDebugMode) {
      print('ℹ️ $tag: $msg');
    }
  }

  // 警告日志
  static void w(String tag, dynamic msg){
    if (kDebugMode) {
      print('⚠️ $tag: $msg');
    }
  }

  // 错误弹幕
  static void e(String tag, dynamic msg, [dynamic error,StackTrace? stackTrace]){
    if (kDebugMode) {
      print('❌ $tag: $msg ${error != null ? '\nError: $error' : ''}');
      if(stackTrace != null) print(stackTrace);
    }
  }

  // 性能日志（仅在性能分析时启用）
  static void p(String tag, dynamic msg){
    if (kDebugMode) {
      print('⚡ $tag: $msg');
    }
  }

  // 网络请求日志
  static void n(String tag, dynamic msg){
    if (kDebugMode) {
      print('🌐 $tag: $msg');
    }
  }
}
