import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/utils/storage/setting_storage.dart';
import 'package:refundo/core/utils/storage/user_storage.dart';
import 'package:refundo/core/widgets/floating_register.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart'; // 添加多语言支持
import 'package:refundo/models/user_model.dart';
import 'callback_password.dart';

/// 悬浮窗登录组件
class FloatingLogin {
  static OverlayEntry? _overlayEntry;

  // 控制器和状态变量
  static final TextEditingController _usernameController = TextEditingController();
  static final TextEditingController _passwordController = TextEditingController();

  static bool _obscurePassword = true;
  static bool _rememberMe = false;
  static bool _isLoading = false;
  static String? _errorMessage;

  // 登录逻辑
  static Future<void> onLogin(
      BuildContext context,
      String username,
      String password,
      bool rememberMe,
      ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel user = await userProvider.login(username, password, context);
    _errorMessage = user.errorMessage;
    SettingStorage.saveRememberAccount(rememberMe);

    if (rememberMe) {
      UserStorage.savePassword(password);
      UserStorage.saveUsername(username);
      LogUtil.d("登录:", "保存用户名和密码");
    } else {
      UserStorage.savePassword('');
      UserStorage.saveUsername('');
      LogUtil.d("登录:", "不保存用户名和密码");
    }

    if (_errorMessage == null) {
      hide();
    }
  }

  /// 显示悬浮登录窗
  static void show({
    required BuildContext context,
    Offset? position,
  }) {
    // 先关闭可能已存在的悬浮窗
    hide();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final l10n = AppLocalizations.of(context);

        return Stack(
          children: [
            // 半透明遮罩，点击可关闭
            GestureDetector(
              onTap: () {
                _errorMessage = null;
                _isLoading = false;
                hide();
              },
              child: Container(
                color: Colors.black54,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            // 登录表单悬浮窗
            StatefulBuilder(
              builder: (context, setState) {
                // 默认定位在屏幕中央
                final double left = position?.dx ?? MediaQuery.of(context).size.width * 0.1;
                final double top = position?.dy ?? MediaQuery.of(context).size.height * 0.3;
                final double cardWidth = MediaQuery.of(context).size.width * 0.8;

                // 提交表单逻辑
                Future<void> _submitForm() async {
                  final username = _usernameController.text.trim();
                  final password = _passwordController.text.trim();

                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n!.please_enter_username_and_password)),
                    );
                    return;
                  }

                  try {
                    setState(() => _isLoading = true);
                    await onLogin(context, username, password, _rememberMe);

                    if (_errorMessage == null || _errorMessage == '') {
                      hide();
                      setState(() => _errorMessage = null);
                    }
                  } finally {
                    setState(() => _isLoading = false);
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 标题和关闭按钮
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n!.user_login,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _errorMessage = null;
                                    _isLoading = false;
                                  });
                                  hide();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // 错误信息显示
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _isLoading ? Colors.green.shade50 : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: _isLoading
                                    ? Border.all(color: Colors.green.shade200!)
                                    : Border.all(color: Colors.red.shade200!),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: _isLoading
                                    ? TextStyle(color: Colors.green.shade700)
                                    : TextStyle(color: Colors.red.shade700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // 用户名输入框
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: l10n.username_or_email,
                              prefixIcon: const Icon(Icons.person_outline),
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
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
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submitForm(),
                          ),
                          const SizedBox(height: 16),

                          // 记住我和忘记密码
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() => _rememberMe = value ?? false);
                                    },
                                  ),
                                  Text(l10n.remember_me),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  hide();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CallbackPassword(),
                                    ),
                                  );
                                },
                                child: Text(l10n.forgot_password),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // 登录按钮
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isLoading ? null : _submitForm,
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
                              l10n.login,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 注册提示
                          TextButton(
                            onPressed: () {
                              LogUtil.d("登录", "点击注册账号");
                              hide();
                              FloatingRegister.show(context: context);
                            },
                            child: Text(l10n.no_account_register_now),
                          ),
                        ],
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

    // 将 OverlayEntry 插入到 Overlay 中
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// 隐藏悬浮登录窗
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _passwordController.clear();
    _errorMessage = null;
    _isLoading = false;
  }
}