import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'verification_code_provider.dart';

/// 可复用验证码输入组件（注册、找回密码通用）
class VerificationCodeInput extends StatefulWidget {
  final String email;
  final ValueChanged<bool> onVerified;

  const VerificationCodeInput({
    super.key,
    required this.email,
    required this.onVerified,
  });

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  final _codeController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    final provider = context.read<VerificationCodeProvider>();
    final success = await provider.verifyCode(
      widget.email,
      _codeController.text,
      context,
    );

    setState(() {
      _errorMessage = success ? null : '验证码错误或已过期';
    });

    if (success) {
      widget.onVerified(true);
    }
  }

  Future<void> _handleResend() async {
    final provider = context.read<VerificationCodeProvider>();
    final success = await provider.sendCode(widget.email, context);

    setState(() {
      _errorMessage = success ? null : '发送失败';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<VerificationCodeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _codeController,
          decoration: InputDecoration(
            labelText: l10n.verification_code,
            errorText: _errorMessage,
            suffixIcon: TextButton(
              onPressed: provider.canSend ? _handleResend : null,
              child: Text(
                provider.canSend
                    ? l10n.get_verification_code
                    : '${provider.countdown}s',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _codeController.text.isNotEmpty ? _handleVerify : null,
          child: Text('111'),
        ),
      ],
    );
  }
}
