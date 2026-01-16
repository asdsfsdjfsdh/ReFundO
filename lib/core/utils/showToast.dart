import 'package:flutter/material.dart';

class ShowToast {
  static OverlayEntry? _overlayEntry;

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