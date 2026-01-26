import 'package:flutter/material.dart';

class ShowToast {
  static OverlayEntry? _overlayEntry;

  // 显示成功消息（绿色文本）
  static void showSuccess(BuildContext context, String message) {
    _showColoredToast(context, message, Colors.green);
  }

  // 显示错误消息（红色文本）
  static void showError(BuildContext context, String message) {
    _showColoredToast(context, message, Colors.red);
  }

  // 显示带颜色的Toast
  static void _showColoredToast(BuildContext context, String message, Color textColor) {
    // 安全地移除现有的 overlay entry
    if (_overlayEntry != null) {
      try {
        if (_overlayEntry!.mounted) {
          _overlayEntry!.remove();
        }
      } catch (e) {
        debugPrint('OverlayEntry may have already been removed: $e');
      }
      _overlayEntry = null;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(Duration(seconds: 2), () {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    });
  }

  // 显示普通消息（白色文本）- 保持原有方法不变
  static void showCenterToast(BuildContext context, String message) {
    // 安全地移除现有的 overlay entry
    if (_overlayEntry != null) {
      try {
        // 检查 OverlayEntry 是否仍然挂载
        if (_overlayEntry!.mounted) {
          _overlayEntry!.remove();
        }
      } catch (e) {
        // 忽略已经移除的 entry 引发的错误
        debugPrint('OverlayEntry may have already been removed: $e');
      }
      _overlayEntry = null;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(Duration(seconds: 2), () {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    });
  }

}