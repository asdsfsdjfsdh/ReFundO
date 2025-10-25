// 找回密码Widget
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/showToast.dart';
import 'package:refundo/data/services/api_email_service.dart';
import 'package:refundo/features/main/pages/setting/provider/email_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/models/user_model.dart';

class CallbackPassword extends StatefulWidget {
  const CallbackPassword({super.key});

  @override
  State<CallbackPassword> createState() => _CallbackPasswordState();
}

class _CallbackPasswordState extends State<CallbackPassword> {
  late PageController _pageController;
  String? email;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("callbackPassword"),
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 根据当前页面位置决定返回逻辑
            if (_pageController.page == 0 || _pageController.page == 2) {
              // 当前在第一个页面，直接关闭整个流程
              Navigator.pop(context);
            } else {
              // 在其他页面，调用 onBack 回调
              _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          Callback(
            onNext: (value) {
              email = value;
              _nextPage();
            },
            onBack: () {},
          ),
          CheckCode(
            onNext: (value) {
              _nextPage();
            },
            onBack: () {
              _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          SetPasswrod(
            onBack: () {
              _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            onfinish: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// 找回密码输入绑定邮箱

class Callback extends StatefulWidget {
  final Function(String) onNext;
  final Function() onBack;
  const Callback({super.key, required this.onNext, required this.onBack});

  @override
  State<Callback> createState() => _CallbackState();
}

class _CallbackState extends State<Callback> {
  String email = '';
  
  Color? color = Colors.blue[200];
  final _focusNode = FocusNode();
  late TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[0-9a-zA-Z._%+-]+@[0-9a-zA-Z]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _showCenterToast(BuildContext context, String message) {
    _overlayEntry?.remove();

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width; // 屏幕宽度
    final screenHeight = size.height; // 屏幕高度

    return GestureDetector(
      onTap: () {
        // 点空白处失去焦点
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      },
      behavior: HitTestBehavior.opaque, // 添加此行，确保整个区域都能响应点击

      child: Container(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Container(
              width: screenWidth * 0.75,
              child: TextField(
                focusNode: _focusNode,
                controller: _controller,
                // 监控输入
                onChanged: (value) {
                  setState(() {
                    email = value;
                    color = value.length == 0 ? Colors.blue[200] : Colors.blue;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "请输入邮箱",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            Container(
              width: screenWidth * 0.75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Color.fromARGB(255, 220, 220, 220),

                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () async {
                  print(email);
                  if (color == Colors.blue) {
                    print(isValidEmail(email));
                    if (!isValidEmail(email)) {
                      ShowToast.showCenterToast(context, "邮箱格式错误");
                    } else {
                      print("email$email");
                      Provider.of<EmailProvider>(
                        context,
                        listen: false,
                      ).setEmail(email);
                      widget.onNext(email);
                    }
                  } else
                      ShowToast.showCenterToast(context, "邮箱格式错误");
                },

                child: Text("下一步"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckCode extends StatefulWidget {
  final Function(String) onNext;
  final Function() onBack;
  const CheckCode({super.key, required this.onNext, required this.onBack});

  @override
  State<CheckCode> createState() => _CheckCodeState();
}

// 验证码发送与验证

class _CheckCodeState extends State<CheckCode> {
  bool isSend = false;
  Color? sendColor = Colors.blue;
  String Code = "";
  Color? color = Colors.blue[200];
  int button_flex = 4;
  final _focusNode = FocusNode();
  late TextEditingController _controller = TextEditingController();
  int _countdown = 60;
  Timer? _timer;
  OverlayEntry? _overlayEntry;

  void _startCountdown() {
    _timer?.cancel();

    setState(() {
      _countdown = 5;
      isSend = true;
      button_flex = 6;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
          if (_countdown == 0) {
            _timer?.cancel();
            sendColor = Colors.blue;
          }
        }
      });
    });
  }

  void _showCenterToast(BuildContext context, String message) {
    _overlayEntry?.remove();

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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = Provider.of<EmailProvider>(context, listen: false).Email;

    return GestureDetector(
      onTap: () {
        // 点空白处失去焦点
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
              height: 50,
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    child: const Text("验证码:", style: TextStyle(fontSize: 20.0)),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _controller,
                      maxLength: 6,
                      // 监控输入
                      onChanged: (value) {
                        setState(() {
                          color = value.length == 6
                              ? Colors.blue
                              : Colors.blue[200];
                          Code = value;
                        });
                      },
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "请输入验证码",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 200, 200, 200),
                        ),
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      style: TextStyle(fontSize: 20.0),
                      onSubmitted: (value) {
                        print("验证码：" + value);
                      },
                    ),
                  ),
                  Expanded(
                    flex: button_flex,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Visibility(
                            visible: Code.isNotEmpty,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  Code = "";
                                  _controller.clear();
                                });
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: VerticalDivider(
                            indent: 10,
                            endIndent: 10,
                            color: Colors.grey,
                            thickness: 1,
                            width: 20,
                          ),
                        ),
                        isSend
                            ? Expanded(
                                flex: 7,
                                child: TextButton(
                                  key: ValueKey('resend'),
                                  onPressed: () {
                                    setState(() {
                                      if (sendColor == Colors.blue) {
                                        final message =
                                            Provider.of<EmailProvider>(
                                              context,
                                              listen: false,
                                            ).sendEmail(email, context);
                                        if (message != "Error") {
                                        ShowToast.showCenterToast(context, "验证码已发送");
                                          sendColor = Colors.grey;
                                          _startCountdown();
                                        } else {
                                        ShowToast.showCenterToast(context, "发送失败");
                                        }
                                      }
                                    });
                                  },
                                  child: Text(
                                    _countdown != 0
                                        ? "重新获取($_countdown)"
                                        : "重新获取",
                                    style: TextStyle(
                                      color: sendColor,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                flex: 7,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isSend = true;
                                      button_flex = 6;
                                      sendColor = Colors.grey;
                                      final message =
                                          Provider.of<EmailProvider>(
                                            context,
                                            listen: false,
                                          ).sendEmail(email, context);
                                      if (message != "Error") {
                                        ShowToast.showCenterToast(context, "验证码已发送");
                                        _startCountdown();
                                      } else {
                                        ShowToast.showCenterToast(context, "发送失败");
                                      }
                                    });
                                  },
                                  child: Text(
                                    "获取验证码",
                                    style: TextStyle(
                                      color: sendColor,
                                      fontSize: 15.0,
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

            SizedBox(height: 20.0),

            Container(
              width: 500.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // 背景颜色
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  if (Code.isEmpty)
                    ShowToast.showCenterToast(context, "请先输入验证码");
                  else {
                    if (isSend) {
                      final message = await Provider.of<EmailProvider>(
                        context,
                        listen: false,
                      ).checkCode(email, Code, context);
                      print(message);
                      if (message != "验证码正确") {
                       ShowToast.showCenterToast(context,message);
                      } else {
                        widget.onNext(Code);
                        ShowToast.showCenterToast(context, message);
                      }
                    } else {
                      ShowToast.showCenterToast(context, "请先获取验证码");
                    }
                  }
                  print("验证码：" + Code);
                },
                child: Text(
                  "下一步",
                  style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//重新设置密码

class SetPasswrod extends StatefulWidget {
  final Function() onBack;
  final Function() onfinish;
  const SetPasswrod({
    super.key,
    required this.onBack,
    required this.onfinish,
  });

  @override
  State<SetPasswrod> createState() => _SetPasswrodState();
}

class _SetPasswrodState extends State<SetPasswrod> {
  Color? color = Colors.blue[200];
  String newPasswrod = "";
  String confirmPasswrod = "";
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  late TextEditingController _controller1 = TextEditingController();
  late TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = Provider.of<EmailProvider>(context, listen: false).Email;

    final size = MediaQuery.of(context).size;
    final screenWidth = size.width; // 屏幕宽度
    final screenHeight = size.height; // 屏幕高度
    return GestureDetector(
      onTap: () {
        if (_focusNode1.hasFocus) _focusNode1.unfocus();
        if (_focusNode2.hasFocus) _focusNode2.unfocus();
      },
      behavior: HitTestBehavior.opaque,

      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Container(
              // 标题,置于左上角
              alignment: Alignment.topLeft,
              child: Text(
                "设置新密码",
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20.0),

            Container(
              decoration: BoxDecoration(color: Colors.white),
              // 输入框
              child: Row(
                children: [
                  Container(
                    width: 100.0,
                    child: Text("新密码", style: TextStyle(fontSize: 20.0)),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _controller1,
                      focusNode: _focusNode1,
                      decoration: InputDecoration(
                        hintText: "请输入新密码",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          newPasswrod = value;
                          if (newPasswrod.isNotEmpty &&
                              confirmPasswrod.isNotEmpty) {
                            color = Colors.blue;
                          } else {
                            color = Colors.blue[200];
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Visibility(
                      visible: newPasswrod.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            newPasswrod = "";
                            _controller1.clear();
                          });
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 横线组件
            Divider(color: Colors.grey[200]),

            Container(
              decoration: BoxDecoration(color: Colors.white),
              // 输入框
              child: Row(
                children: [
                  Container(
                    width: 100.0,
                    child: Text("确认密码", style: TextStyle(fontSize: 20.0)),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _controller2,
                      focusNode: _focusNode2,
                      decoration: InputDecoration(
                        hintText: "请再次输入新密码",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          confirmPasswrod = value;
                          if (newPasswrod.isNotEmpty &&
                              confirmPasswrod.isNotEmpty) {
                            color = Colors.blue;
                          } else {
                            color = Colors.blue[200];
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Visibility(
                      visible: confirmPasswrod.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            confirmPasswrod = "";
                            _controller2.clear();
                          });
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey[200]),

            Container(
              width: 500.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // 背景颜色
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (newPasswrod == confirmPasswrod) {
                    ShowToast.showCenterToast(context,"密码设置成功");

                    // 在这里调用修改密码的接口
                    Provider.of<UserProvider>(context, listen: false).updateUserInfo(newPasswrod, 2, context);

                  } else {
                    ShowToast.showCenterToast(context,"两次密码输入不一致");
                  }
                  widget.onfinish();
                  print("密码");
                },
                child: Text(
                  "确认",
                  style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
