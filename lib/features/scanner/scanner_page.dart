import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/models/Product_model.dart';

class ScannerPage extends StatelessWidget {
  ScannerPage({super.key});

  // //是否扫描到数据
  // bool _isScan = false;

  // void _scan(Code result) async {
  //   _isScan = true;

  // }

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

  void _showTextResultDialog(BuildContext context, Code result) async {
    String? decodedText = result.text;
    print(decodedText);
    Map<String, dynamic> productData = _parseKeyValueFormat(decodedText!);
    
    ProductModel product = ProductModel.fromJson(productData);
    OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    String message = await orderProvider.InsertOrder(product,context);
    print(message);

    _showCenterToast(context, message);
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

  //解析二维码数据
  Map<String, dynamic> _parseKeyValueFormat(String text) {
  Map<String, dynamic> data = {};
  List<String> lines = text.split('\n');
  
  for (String line in lines) {
    if (line.contains(':')) {
      List<String> parts = line.split(':');
      if (parts.length >= 2) {
        String key = parts[0].trim();
        String value = parts.sublist(1).join(':').trim(); // 处理值中可能包含冒号的情况
        
        // 尝试转换数字类型
        if (key == 'price' || key == 'RefundPercent' || key == 'RefundAmount') {
          try {
            data[key] = double.parse(value);
          } catch (e) {
            data[key] = value;
          }
        } else {
          data[key] = value;
        }
      }
    }
  }
  
  return data;
}

}
