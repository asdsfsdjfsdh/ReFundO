import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('扫描二维码')),
      body: ReaderWidget(
        cropPercent: 1.0,
        onScan: (result) async {
          // 处理扫描结果
          if (result.isValid && result.format == (1 << 13)) {
            _showTextResultDialog(context, result);
          } else {
            // 显示错误提示
            _showCenterToast(context, "无效的二维码");
          }
        },
      ),
    );
  }

  void _showTextResultDialog(BuildContext context, Code result) {
    String? decodedText = result.text;
    print(decodedText);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('扫描结果'),
          content: SelectableText(
            decodedText!
          ), // 使用SelectableText允许用户复制文本
          actions: <Widget>[
            TextButton(
              child: const Text('复制'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: decodedText));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('已复制到剪贴板')));
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //中心提示框
  void _showCenterToast(BuildContext context, String message) {
    final overlayEntry = OverlayEntry(
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
              style: TextStyle(color: Colors.white, fontSize: 16,
              decoration: TextDecoration.none,),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
