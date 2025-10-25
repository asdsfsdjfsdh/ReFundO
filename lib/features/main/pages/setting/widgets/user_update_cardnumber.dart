// 新建文件 lib/features/main/pages/setting/widgets/email_change_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/passwordHasher.dart';
import 'package:refundo/core/utils/showToast.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/models/user_model.dart';

class CardChangeSheet extends StatefulWidget {
  @override
  _CardChangeSheetState createState() => _CardChangeSheetState();
}

class _CardChangeSheetState extends State<CardChangeSheet> {
  bool isTrue = false;
  bool isLoading = false;
  late TextEditingController _oldEmailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _newEmailController = TextEditingController();
  late FocusNode _focusNode1 = FocusNode();
  late FocusNode _focusNode2 = FocusNode();
  late FocusNode _focusNode3 = FocusNode();

  @override
  void initState() {
    super.initState();
    _oldEmailController = TextEditingController();
    _passwordController = TextEditingController();
    _newEmailController = TextEditingController();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
  }

  @override
  dispose() {
    _oldEmailController.dispose();
    _passwordController.dispose();
    _newEmailController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel User = Provider.of<UserProvider>(context).user!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      clipBehavior: Clip.hardEdge,
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      // transform: Matrix4.translationValues(0, -bottomInset, 0),
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: GestureDetector(
        onTap: () {
          if (_focusNode1.hasFocus) _focusNode1.unfocus();
          if (_focusNode2.hasFocus) _focusNode2.unfocus();
        },
        behavior: HitTestBehavior.opaque,

        child: Column(
          children: [
            SizedBox(height: 16),
            Text('悬浮窗内容', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),

            !isTrue
                ? Column(
                    children: [
                      _buildTextField(
                        "请输入邮箱",
                        Icons.email,
                        _oldEmailController,
                        _focusNode1,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        "请输入密码",
                        Icons.lock,
                        _passwordController,
                        _focusNode2,
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // 背景颜色
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            print(User);

                            if (_oldEmailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              ShowToast.showCenterToast(context, "请输入完整信息");
                              return;
                            }

                            if (!isLoading) {
                              setState(() {
                                isLoading = true;
                              });
                              if (await Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).verifyUserIdentity(
                                _oldEmailController.text,
                                _passwordController.text,
                                context,
                              )) {
                                ShowToast.showCenterToast(context, "验证成功");
                                setState(() {
                                  isTrue = true;
                                });
                              } else {
                                ShowToast.showCenterToast(context, "邮箱或密码错误");
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }

                          },
                          child: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  '确定',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      if (_focusNode3.hasFocus) _focusNode3.unfocus();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        _buildTextField(
                          "请输入新的银行卡号",
                          Icons.email,
                          _newEmailController,
                          _focusNode3,
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // 背景颜色
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              if (_newEmailController.text.isEmpty) {
                                ShowToast.showCenterToast(context, "请输入银行卡号");
                              } else {
                                String message =
                                    await Provider.of<UserProvider>(
                                      context,
                                      listen: false,
                                    ).updateUserInfo(
                                      _newEmailController.text,
                                      4,
                                      context,
                                    );
                                ShowToast.showCenterToast(context, message);
                                // 关闭页面
                                if(message == "修改成功")
                                  Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              '确定',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
