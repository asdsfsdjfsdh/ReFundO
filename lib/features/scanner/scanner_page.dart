import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/models/Product_model.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isScanning = true;
  String _message = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('扫描二维码'),
      ),
      body: ReaderWidget(
        cropPercent: 1.0,
        onScan: (result) async {
          // 处理扫描结果
          if(_isScanning){
            if (result.isValid && result.format == (1 << 13)) {
            _isScanning = false;
            _showTextResultDialog(context, result);
          } else {
            // 显示错误提示
            setState(() {
              _message = '无效的二维码';
              _isScanning = false;
            });
            _showDialog(context, _message);
          }
          }
        },
      )
    );
  }


  void _showTextResultDialog(BuildContext context, Code result) async {
    String? decodedText = result.text;
    print(decodedText);
    Map<String, dynamic> productData = _parseKeyValueFormat(decodedText!);

    ProductModel product = ProductModel.fromJson(productData);
    OrderProvider orderProvider = Provider.of<OrderProvider>(
      context,
      listen: false,
    );
    String message = await orderProvider.insertOrder(product, context);
    Provider.of<UserProvider>(context, listen: false).Info(context);
    

    setState(() {
      _message = message;
      _showDialog(context, _message);
    });

  }

  void _showDialog(BuildContext context, String message) {
   showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text(_message, style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isScanning = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Widget? _showCenterToast(BuildContext context, String message) {
  //   if (message == '') {
  //     return null;
  //   }
  //   return Center(
  //     child: Column(
  //       children: [
  //         Text(message, style: TextStyle(fontSize: 16)),
  //         //调整按钮位置在右下角
  //         SizedBox(height: 10),

  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             setState(() {
  //               _isScanning = true;
  //             });
  //           },
  //           child: Text('确定'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
          if (key == 'price' ||
              key == 'RefundPercent' ||
              key == 'RefundAmount') {
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
