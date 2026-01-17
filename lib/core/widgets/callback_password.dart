import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/showToast.dart';
import 'package:refundo/features/main/pages/setting/provider/email_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(l10n!.callback_password),
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_pageController.page == 0 || _pageController.page == 2) {
              Navigator.pop(context);
            } else {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return GestureDetector(
      onTap: () {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Container(
              width: screenWidth * 0.75,
              child: TextField(
                focusNode: _focusNode,
                controller: _controller,
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
                  hintText: l10n!.hint_enter_email,
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
                  if (color == Colors.blue) {
                    if (!isValidEmail(email)) {
                      ShowToast.showCenterToast(
                        context,
                        l10n.invalid_email_format,
                      );
                    } else {
                      Provider.of<EmailProvider>(
                        context,
                        listen: false,
                      ).setEmail(email);
                      widget.onNext(email);
                    }
                  } else {
                    ShowToast.showCenterToast(
                      context,
                      l10n.invalid_email_format,
                    );
                  }
                },
                child: Text(l10n.next_step),
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
    final l10n = AppLocalizations.of(context);
    final email = Provider.of<EmailProvider>(context, listen: false).Email;

    return GestureDetector(
      onTap: () {
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
                    child: Text(
                      l10n!.verification_code,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _controller,
                      maxLength: 6,
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
                        hintText: l10n.hint_enter_verification_code,
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 200, 200, 200),
                        ),
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      style: TextStyle(fontSize: 20.0),
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
                                  onPressed: () async {
                                    if (sendColor == Colors.blue) {
                                      final message =
                                          await Provider.of<EmailProvider>(
                                            context,
                                            listen: false,
                                          ).sendEmail(email, context, 1);
                                      if (message == 1) {
                                        ShowToast.showCenterToast(
                                          context,
                                          l10n.verification_code_sent,
                                        );
                                        if (mounted) {
                                          setState(() {
                                            sendColor = Colors.grey;
                                            _startCountdown();
                                          });
                                        }
                                      } else if (message == 0) {
                                        ShowToast.showCenterToast(
                                          context,
                                          l10n.email_send_failed,
                                        );
                                      } else if (message == 412) {
                                        ShowToast.showCenterToast(
                                          context,
                                          l10n.user_info_not_unique,
                                        );
                                      } else if (message == 400) {
                                        ShowToast.showCenterToast(
                                          context,
                                          l10n.no_user_found_for_email,
                                        );
                                      } else {
                                        ShowToast.showCenterToast(
                                          context,
                                          l10n.email_service_unavailable,
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    _countdown != 0
                                        ? l10n.resend_with_countdown(_countdown)
                                        : l10n.resend_verification_code,
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
                                  onPressed: () async {
                                    final int? message =
                                        await Provider.of<EmailProvider>(
                                          context,
                                          listen: false,
                                        ).sendEmail(email, context, 1);

                                    if (message == 1) {
                                      ShowToast.showCenterToast(
                                        context,
                                        l10n.verification_code_sent_success,
                                      );
                                      _startCountdown();
                                    } else {
                                      ShowToast.showCenterToast(
                                        context,
                                        l10n.send_failed,
                                      );
                                    }
                                    if (mounted) {
                                      setState(() {
                                        isSend = true;
                                        button_flex = 6;
                                        sendColor = Colors.grey;
                                      });
                                    }
                                  },
                                  child: Text(
                                    l10n.get_verification_code,
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
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  if (Code.isEmpty)
                    ShowToast.showCenterToast(
                      context,
                      l10n.please_enter_code_first,
                    );
                  else {
                    if (isSend) {
                      final message = await Provider.of<EmailProvider>(
                        context,
                        listen: false,
                      ).checkCode(email, Code, context);
                      if (message == 410) {
                        ShowToast.showCenterToast(
                          context,
                          l10n.verification_code_expired,
                        );
                      } else if (message == 200) {
                        widget.onNext(Code);
                        ShowToast.showCenterToast(
                          context,
                          l10n.verification_code_correct,
                        );
                      } else if (message == 411) {
                        ShowToast.showCenterToast(
                          context,
                          l10n.verification_code_incorrect,
                        );
                      } else if (message == 400) {
                        ShowToast.showCenterToast(
                          context,
                          l10n.invalid_request_format,
                        );
                      } else {
                        ShowToast.showCenterToast(
                          context,
                          l10n.verification_service_unavailable,
                        );
                      }
                    } else {
                      ShowToast.showCenterToast(
                        context,
                        l10n.please_get_code_first,
                      );
                    }
                  }
                },
                child: Text(
                  l10n.next_step,
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

class SetPasswrod extends StatefulWidget {
  final Function() onBack;
  final Function() onfinish;
  const SetPasswrod({super.key, required this.onBack, required this.onfinish});

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
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

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
              alignment: Alignment.topLeft,
              child: Text(
                l10n!.set_new_password,
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Container(
                    width: 100.0,
                    child: Text(
                      l10n.new_password,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _controller1,
                      focusNode: _focusNode1,
                      decoration: InputDecoration(
                        hintText: l10n.hint_enter_new_password,
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
            Divider(color: Colors.grey[200]),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Container(
                    width: 100.0,
                    child: Text(
                      l10n.confirm_password,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _controller2,
                      focusNode: _focusNode2,
                      decoration: InputDecoration(
                        hintText: l10n.hint_confirm_new_password,
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
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (newPasswrod == confirmPasswrod) {
                    ShowToast.showCenterToast(
                      context,
                      l10n.password_set_success,
                    );
                    Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).updateUserInfo(newPasswrod, 2, context);
                  } else {
                    ShowToast.showCenterToast(
                      context,
                      l10n.passwords_do_not_match,
                    );
                  }
                  widget.onfinish();
                },
                child: Text(
                  l10n.confirm,
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
