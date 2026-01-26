import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
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
            final l10n = AppLocalizations.of(context);
            setState(() {
              _message = l10n!.invalid_email_format; // 使用现有键作为临时解决方案
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
    final l10n = AppLocalizations.of(context);
    String? decodedText = result.text;
    print(decodedText);

    try {
      Map<String, dynamic> productData = _parseKeyValueFormat(decodedText!);

      ProductModel product = ProductModel.fromJson(productData);
      OrderProvider orderProvider = Provider.of<OrderProvider>(
        context,
        listen: false,
      );
      var resultMsg = await orderProvider.insertOrder(product, context);
      Provider.of<UserProvider>(context, listen: false).Info(context);

      if (resultMsg['success']) {
        setState(() {
          _message = l10n!.create_order_success;
        });
      } else {
        setState(() {
          _message = resultMsg['message'] ?? l10n!.unknown_error;
        });
      }
      _showDialog(context, _message);
    } catch (e) {
      setState(() {
        _message = '二维码格式错误';
      });
      _showDialog(context, _message);
    }
  }

  void _showDialog(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context);
   showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(l10n!.notification),
          content: Text(_message, style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              child: Text(l10n.confirm),
              onPressed: () {
                Navigator.of(ctx).pop();
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
    // 尝试解析为 JSON
    final Map<String, dynamic> jsonData = json.decode(text);
    return jsonData;
  }
}
