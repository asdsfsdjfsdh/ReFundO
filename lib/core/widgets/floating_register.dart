import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/widgets/floating_login.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';

/// 悬浮窗注册组件
class FloatingRegister {
  static OverlayEntry? _overlayEntry;

  // 控制器和状态变量
  static final TextEditingController _usernameController = TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _passwordController = TextEditingController();
  static final TextEditingController _confirmPasswordController = TextEditingController();

  static bool _obscurePassword = true;
  static bool _obscureConfirmPassword = true;
  static bool _isLoading = false;
  static String? _errorMessage;
  static bool _isRegister = false;

  // 注册逻辑
  static Future<void> onRegister(BuildContext context, String username, String userEmail, String password) async{
    Provider.of<UserProvider>(context,listen: false).register(username, userEmail, password,context);
  }

  /// 显示注册悬浮窗
  static void show({
    required BuildContext context,
    Offset? position,
  }) {
    // 先关闭可能已存在的悬浮窗
    hide();

    _overlayEntry = OverlayEntry(
      builder: (context) =>
          Stack(
            children: [
              // 半透明遮罩
              GestureDetector(
                onTap: () {
                  hide();
                },
                child: Container(
                  color: Colors.black54,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                ),
              ),
              // 注册表单卡片
              StatefulBuilder(
                builder: (context, setState) {
                  // 默认定位
                  final double left = position?.dx ?? MediaQuery
                      .of(context)
                      .size
                      .width * 0.1;
                  final double top = position?.dy ?? MediaQuery
                      .of(context)
                      .size
                      .height * 0.23;
                  final double cardWidth = MediaQuery
                      .of(context)
                      .size
                      .width * 0.8;

                  // 提交表单
                  Future<void> _submitForm() async {
                    final username = _usernameController.text.trim();
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final confirmPassword = _confirmPasswordController.text.trim();

                    // 基本验证
                    if (username.isEmpty) {
                      setState(() => _errorMessage = '请输入用户名');
                      _isRegister = false;
                      return;
                    }
                    if (email.isEmpty || !email.contains('@')) {
                      setState(() => _errorMessage = '请输入有效的邮箱地址');
                      _isRegister = false;
                      return;
                    }
                    if (password.isEmpty || password.length < 6) {
                      setState(() => _errorMessage = '密码长度至少6位');
                      _isRegister = false;
                      return;
                    }
                    if (password != confirmPassword) {
                      setState(() => _errorMessage = '两次输入的密码不一致');
                      _isRegister = false;
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });

                    try {
                      await onRegister(context,username, email, password);
                      setState((){
                        _errorMessage = "你已注册成功，请登入!";
                      });
                      _isRegister = true;
                      return;
                    } catch (e) {
                      setState(() => _errorMessage = e.toString());
                    } finally {
                      _isLoading = false;
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
                                  const Text(
                                    '用户注册',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      hide();
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
                                    color: _isRegister? Colors.green[50]:Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: _isRegister? Border.all(color: Colors.green[200]!):Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Text(
                                    _errorMessage!,
                                    style: _isRegister? TextStyle(color: Colors.green[700]):TextStyle(color: Colors.red[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // 用户名输入框
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: '用户名',
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),

                              // 邮箱输入框
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: '邮箱',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(),
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
                                  labelText: '密码',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
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
                                  labelText: '确认密码',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submitForm(),
                              ),
                              const SizedBox(height: 24),

                              // 注册按钮
                              ElevatedButton(
                                onPressed:_isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                                    : const Text(
                                  '注册',
                                  style: TextStyle(
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
                                  const Text('已有账号?'),
                                  TextButton(
                                    onPressed: () {
                                      hide();
                                      // 这里可以触发跳转到登录界面
                                      FloatingLogin.show(context: context);
                                    },
                                    child: const Text('立即登录'),
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
              )
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// 隐藏悬浮窗
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

}