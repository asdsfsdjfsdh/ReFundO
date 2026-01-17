import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/showToast.dart';
import 'package:refundo/core/widgets/floating_login.dart';
import 'package:refundo/features/main/pages/setting/provider/email_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart'; // 添加多语言支持

/// 悬浮窗注册组件
class FloatingRegister {
  static OverlayEntry? _overlayEntry;

  // 控制器和状态变量
  static final TextEditingController _usernameController =
      TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _verificationCodeController =
      TextEditingController();
  static final TextEditingController _passwordController =
      TextEditingController();
  static final TextEditingController _confirmPasswordController =
      TextEditingController();

  static bool _obscurePassword = true;
  static bool _obscureConfirmPassword = true;
  static bool _isLoading = false;
  static String? _errorMessage;
  static bool _isRegister = false;

  // 验证码倒计时相关变量
  static bool _isButtonDisabled = false;
  static int _countdownSeconds = 60;
  static Timer? _countdownTimer;

  // 注册逻辑
  static Future<void> onRegister(
    BuildContext context,
    String username,
    String userEmail,
    String password,
  ) async {
    Provider.of<UserProvider>(
      context,
      listen: false,
    ).register(username, userEmail, password, context);
  }

  /// 获取验证码按钮点击事件
  static void _getVerificationCode(
    StateSetter setState,
    BuildContext context,
  ) async {
    final l10n = AppLocalizations.of(context);
    String mail = _emailController.text;

    // 邮箱验证
    if (mail.isEmpty || !mail.contains('@')) {
      setState(() => _errorMessage = l10n!.please_enter_valid_email);
      return;
    }

    // 防止重复点击
    if (_isButtonDisabled) return;

    setState(() {
      _isButtonDisabled = true;
      _countdownSeconds = 60;
      _errorMessage = null;
    });

    try {
      // TODO: 调用验证码发送接口（此处为占位实现）
      if (kDebugMode) {
        final message = await Provider.of<EmailProvider>(
          context,
          listen: false,
        ).sendEmail(mail, context, 2);
        if (message == 1) {
          ShowToast.showCenterToast(context, "验证码已发送至您的邮箱，请查收");
        } else if (message == 411) {
          ShowToast.showCenterToast(context, "邮件发送失败，请检查邮箱地址或稍后重试");
        } else if (message == 412) {
          ShowToast.showCenterToast(context, "用户信息不唯一，请联系客服处理");
        } else if (message == 400) {
          ShowToast.showCenterToast(context, "未找到与该邮箱关联的用户账户");
        } else {
          ShowToast.showCenterToast(context, "邮件服务暂时不可用，请稍后重试");
        }
        print('向邮箱 $mail 发送验证码');
      }

      // 模拟API调用延迟
      await Future.delayed(const Duration(milliseconds: 500));

      // 这里替换为实际的验证码发送代码
      // DataResponse res = await AuthController().getVerification(mail);
      // if(res.code != 0) {
      //   setState(() => _errorMessage = res.msg ?? "验证码发送失败");
      //   return;
      // }

      _startCountdownTimer(setState);
    } catch (e) {
      setState(() {
        _isButtonDisabled = false;
        _errorMessage = l10n!.verification_code_send_failed;
      });
    }
  }

  /// 启动验证码倒计时
  static void _startCountdownTimer(StateSetter setState) {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _isButtonDisabled = false;
          _countdownTimer?.cancel();
        }
      });
    });
  }

  /// 显示注册悬浮窗
  static void show({required BuildContext context, Offset? position}) {
    // 先关闭可能已存在的悬浮窗
    hide();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final cardWidth = MediaQuery.of(context).size.width * 0.8;

        return Stack(
          children: [
            // 半透明遮罩
            GestureDetector(
              onTap: () {
                hide();
              },
              child: Container(
                color: Colors.black54,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            // 注册表单卡片
            StatefulBuilder(
              builder: (context, setState) {
                // 默认定位
                final double left =
                    position?.dx ?? MediaQuery.of(context).size.width * 0.1;
                final double top =
                    position?.dy ?? MediaQuery.of(context).size.height * 0.23;

                // 提交表单
                Future<void> _submitForm() async {
                  final username = _usernameController.text.trim();
                  final email = _emailController.text.trim();
                  final verificationCode = _verificationCodeController.text
                      .trim();
                  final password = _passwordController.text.trim();
                  final confirmPassword = _confirmPasswordController.text
                      .trim();

                  // 基本验证
                  if (username.isEmpty) {
                    setState(() => _errorMessage = l10n!.please_enter_username);
                    _isRegister = false;
                    return;
                  }
                  if (email.isEmpty || !email.contains('@')) {
                    setState(
                      () => _errorMessage = l10n!.please_enter_valid_email,
                    );
                    _isRegister = false;
                    return;
                  }
                  if (verificationCode.isEmpty) {
                    setState(
                      () =>
                          _errorMessage = l10n!.please_enter_verification_code,
                    );
                    _isRegister = false;
                    return;
                  } else {
                    final message =
                        await Provider.of<EmailProvider>(
                          context,
                          listen: false,
                        ).checkCode(
                          email,
                          _verificationCodeController.text,
                          context,
                        );
                    print(message);
                    if (message == 410) {
                      ShowToast.showCenterToast(context, "验证码已过期，请重新获取");
                      return;
                    } else if (message == 200) {
                    } else if (message == 411) {
                      ShowToast.showCenterToast(context, "验证码错误");
                      return;
                    } else if (message == 400) {
                      ShowToast.showCenterToast(context, "请求参数格式不正确");
                      return;
                    } else {
                      ShowToast.showCenterToast(context, "验证码服务暂时不可用，请稍后重试");
                      return;
                    }
                  }
                  if (password.isEmpty || password.length < 6) {
                    setState(
                      () => _errorMessage = l10n!.password_length_at_least_6,
                    );
                    _isRegister = false;
                    return;
                  }
                  if (password != confirmPassword) {
                    setState(
                      () => _errorMessage = l10n!.passwords_do_not_match,
                    );
                    _isRegister = false;
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });

                  try {
                    await onRegister(context, username, email, password);
                    final userProvider = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );
                    setState(() {
                      _errorMessage = userProvider.errorMessage;
                    });
                    _isRegister = true;
                  } catch (e) {
                    setState(() => _errorMessage = e.toString());
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }

                return Positioned(
                  left: left,
                  top: top,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 标题和关闭按钮
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n!.user_registration,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    hide();
                                    setState(() {
                                      _errorMessage = null;
                                      _passwordController.clear();
                                      _confirmPasswordController.clear();
                                      _usernameController.clear();
                                      _emailController.clear();
                                      _verificationCodeController.clear();
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // 错误消息显示
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _isRegister
                                      ? Colors.green[50]
                                      : Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: _isRegister
                                      ? Border.all(color: Colors.green[200]!)
                                      : Border.all(color: Colors.red[200]!),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: _isRegister
                                      ? TextStyle(color: Colors.green[700])
                                      : TextStyle(color: Colors.red[700]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // 用户名输入框
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: l10n.username,
                                prefixIcon: const Icon(Icons.person_outline),
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

                            // 邮箱输入框
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: l10n.email,
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

                            // 验证码输入行
                            Row(
                              children: [
                                // 验证码输入框
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _verificationCodeController,
                                    decoration: InputDecoration(
                                      labelText: l10n.verification_code,
                                      prefixIcon: const Icon(
                                        Icons.verified_user_outlined,
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // 获取验证码按钮
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    onPressed: _isButtonDisabled
                                        ? null
                                        : () => _getVerificationCode(
                                            setState,
                                            context,
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isButtonDisabled
                                          ? Colors.grey
                                          : Colors.blue[600],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      _isButtonDisabled
                                          ? '${l10n.countdown_seconds(_countdownSeconds)}'
                                          : l10n.get_verification_code,
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // 密码输入框
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: l10n.password,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

                            // 确认密码输入框
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: l10n.confirm_password,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submitForm(),
                            ),
                            const SizedBox(height: 24),

                            // 注册按钮
                            ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      l10n.register,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 10),
                            // 已有账号提示
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l10n.already_have_account),
                                TextButton(
                                  onPressed: () {
                                    hide();
                                    setState(() {
                                      _errorMessage = null;
                                      _passwordController.clear();
                                      _confirmPasswordController.clear();
                                      _usernameController.clear();
                                      _emailController.clear();
                                      _verificationCodeController.clear();
                                    });
                                    FloatingLogin.show(context: context);
                                  },
                                  child: Text(l10n.login_now),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// 隐藏悬浮窗
  static void hide() {
    _countdownTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
