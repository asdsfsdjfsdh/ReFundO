import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/services/api_verification_service.dart';

/// 统一验证码状态管理（注册、找回密码通用）
class VerificationCodeProvider extends ChangeNotifier {
  final ApiVerificationService _service = ApiVerificationService();
  Timer? _timer;
  int _countdown = 0;
  bool _isLoading = false;

  int get countdown => _countdown;
  bool get canSend => _countdown == 0 && !_isLoading;
  bool get isLoading => _isLoading;

  /// 发送验证码
  Future<bool> sendCode(String email, BuildContext context) async {
    if (!canSend) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.sendCode(email, context);
      if (response.statusCode == 200) {
        _startCountdown();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 验证验证码
  Future<bool> verifyCode(String email, String code, BuildContext context) async {
    try {
      final response = await _service.verifyCode(email, code, context);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void _startCountdown() {
    _countdown = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
