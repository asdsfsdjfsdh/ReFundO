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
        onScan: (result) async {
          // 处理扫描结果
          if (result.isValid) {
            _showTextResultDialog(context,result.toString());
          }
        },
      ),
    );
  }
  void _showTextResultDialog(BuildContext context,String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('扫描结果'),
          content: SelectableText(result), // 使用SelectableText允许用户复制文本
          actions: <Widget>[
            TextButton(
              child: const Text('复制'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: result));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已复制到剪贴板')),
                );
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
}