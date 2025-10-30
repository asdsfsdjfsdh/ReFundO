// utils/app_background_util.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppBackgroundUtil {
  static const MethodChannel _channel = MethodChannel('app_background_channel');

  /// 将应用移动到后台（替代 move_to_background 的功能）
  static Future<void> moveToBackground() async {
    try {
      // 对于 Android 平台
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _channel.invokeMethod('moveToBackground');
      }
      // 对于 iOS 平台，可以使用不同的实现或保持当前行为
      else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // iOS 通常不需要特殊处理，系统会自动处理返回键
        // 或者你可以实现特定的 iOS 逻辑
        await _channel.invokeMethod('moveToBackground');
      }
    } on PlatformException catch (e) {
      print("移动应用到后台失败: ${e.message}");
    } catch (e) {
      print("移动应用到后台发生错误: $e");
    }
  }
}