import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/showToast.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';

class NameChangeSheet extends StatefulWidget {
  const NameChangeSheet({super.key});

  @override
  State<NameChangeSheet> createState() => _NameChangeSheetState();
}

class _NameChangeSheetState extends State<NameChangeSheet> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Color buttonText = Colors.grey[400]!;
  Color buttonColor = Colors.grey[300]!;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus != isFocused){
        setState(() {
          isFocused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.change_name),
        backgroundColor: Colors.grey[100],
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            onPressed: () async {
              print(_controller.text);
              if(_controller.text != ''){
                var result = await Provider.of<UserProvider>(context, listen: false).updateUserInfo(_controller.text, 1, context);
                if (result['success']) {
                  ShowToast.showCenterToast(context, l10n.update_username_success);
                  Navigator.pop(context);
                } else {
                  ShowToast.showCenterToast(context, result['message'] ?? l10n.modification_failed);
                }
              }else{
                ShowToast.showCenterToast(context, l10n.please_enter_name);
              }
            },
            child: Text(
              l10n.save,
              style: TextStyle(
                color: buttonText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (_focusNode.hasFocus) {
            _focusNode.unfocus();
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.grey[100]),
          child: Container(
              child: Column(
                children: [
                  TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: l10n.new_name,
                        border: InputBorder.none
                    ),
                    onChanged: (value) {
                      setState(() {
                        buttonText = Colors.white;
                        buttonColor = Colors.blue;
                      });
                    },
                  ),
                  Divider(
                    height: 1,
                    color: isFocused ? Colors.blue : Colors.grey[300],
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}