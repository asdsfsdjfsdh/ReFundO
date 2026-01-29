import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:provider/provider.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/data/models/Product_model.dart';

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
        title: Text(AppLocalizations.of(context)!.scan_the_QR),
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


  //解析二维码数据
  Map<String, dynamic> _parseKeyValueFormat(String text) {
     try {
    // 尝试解析为 JSON
    final Map<String, dynamic> jsonData = json.decode(text);
    return jsonData;
  } on FormatException catch (e) {
    // 如果不是合法 JSON，返回空 map 或抛出异常
    _showDialog(context, '二维码内容非法');
    throw Exception('二维码内容不是有效的 JSON 格式');
  }
  }
}
