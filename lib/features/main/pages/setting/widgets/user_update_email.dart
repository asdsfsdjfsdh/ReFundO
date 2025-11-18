import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/showToast.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart'; // 添加多语言支持

class EmailChangeSheet extends StatefulWidget {
  const EmailChangeSheet({super.key});

  @override
  State<EmailChangeSheet> createState() => _EmailChangeSheetState();
}

class _EmailChangeSheetState extends State<EmailChangeSheet> {
  bool _isVerified = false;
  bool _isLoading = false;
  late TextEditingController _oldEmailController;
  late TextEditingController _passwordController;
  late TextEditingController _newEmailController;
  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;

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
  void dispose() {
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
    final l10n = AppLocalizations.of(context);
    final user = Provider.of<UserProvider>(context).user!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      clipBehavior: Clip.hardEdge,
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: GestureDetector(
        onTap: () {
          if (_focusNode1.hasFocus) _focusNode1.unfocus();
          if (_focusNode2.hasFocus) _focusNode2.unfocus();
          if (_focusNode3.hasFocus) _focusNode3.unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              l10n!.email_change_title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 验证阶段或修改阶段
            _isVerified ? _buildChangePhase(context, l10n) : _buildVerificationPhase(context, l10n),
          ],
        ),
      ),
    );
  }

  // 构建验证阶段UI
  Widget _buildVerificationPhase(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _buildTextField(
          l10n.enter_old_email,
          Icons.email_outlined,
          _oldEmailController,
          _focusNode1,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          l10n.enter_password,
          Icons.lock_outline_rounded,
          _passwordController,
          _focusNode2,
          isPassword: true,
        ),
        const SizedBox(height: 16),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _handleVerification,
            child: _isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              l10n.confirm,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 构建修改阶段UI
  Widget _buildChangePhase(BuildContext context, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        if (_focusNode3.hasFocus) _focusNode3.unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          _buildTextField(
            l10n.enter_new_email,
            Icons.email_outlined,
            _newEmailController,
            _focusNode3,
          ),
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _handleEmailChange,
              child: Text(
                l10n.confirm,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建文本输入框
  Widget _buildTextField(
      String hint,
      IconData icon,
      TextEditingController controller,
      FocusNode focusNode, {
        bool isPassword = false,
      }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        obscureText: isPassword,
        keyboardType: icon == Icons.email_outlined ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // 处理验证逻辑
  Future<void> _handleVerification() async {
    if (_isLoading) return;

    final l10n = AppLocalizations.of(context);

    if (_oldEmailController.text.isEmpty || _passwordController.text.isEmpty) {
      ShowToast.showCenterToast(context, l10n!.please_enter_complete_info);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final isVerified = await userProvider.verifyUserIdentity(
        _oldEmailController.text,
        _passwordController.text,
        context,
      );

      if (isVerified) {
        ShowToast.showCenterToast(context, l10n!.verification_success);
        setState(() {
          _isVerified = true;
        });
      } else {
        ShowToast.showCenterToast(context, l10n!.email_or_password_incorrect);
      }
    } catch (e) {
      ShowToast.showCenterToast(context, l10n!.verification_failed);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 处理邮箱修改逻辑
  Future<void> _handleEmailChange() async {
    final l10n = AppLocalizations.of(context);

    if (_newEmailController.text.isEmpty) {
      ShowToast.showCenterToast(context, l10n!.please_enter_new_email);
      return;
    }

    // 简单的邮箱格式验证
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(_newEmailController.text)) {
      ShowToast.showCenterToast(context, l10n!.invalid_email_format);
      return;
    }

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final message = await userProvider.updateUserInfo(
        _newEmailController.text,
        3, // 假设3是邮箱的类型代码
        context,
      );

      ShowToast.showCenterToast(context, message);

      if (message == l10n!.modification_success) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ShowToast.showCenterToast(context, l10n!.modification_failed);
    }
  }
}