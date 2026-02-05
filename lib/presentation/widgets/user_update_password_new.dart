import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/theme/app_theme.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/core/utils/showToast.dart';
import 'package:refundo/presentation/providers/user_provider.dart';

/// 优化的密码修改组件 - 先输入新密码，验证强度后再验证身份
class PasswordUpdateSheet extends StatefulWidget {
  const PasswordUpdateSheet({super.key});

  @override
  State<PasswordUpdateSheet> createState() => _PasswordUpdateSheetState();
}

class _PasswordUpdateSheetState extends State<PasswordUpdateSheet> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();

  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _oldPasswordFocus = FocusNode();

  bool _isLoading = false;
  bool _showOldPasswordInput = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscureOldPassword = true;
  String? _passwordError;
  double _passwordStrength = 0;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _oldPasswordController.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _oldPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6 + bottomInset,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(l10n),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: bottomInset + AppSpacing.lg,
              ),
              child: _showOldPasswordInput
                  ? _buildOldPasswordVerification(l10n)
                  : _buildNewPasswordInput(l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.change_name,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _showOldPasswordInput
              ? l10n.verify_identity
              : l10n.hint_enter_new_password,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  /// 新密码输入阶段
  Widget _buildNewPasswordInput(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 新密码输入
        _buildInputLabel(l10n.new_password, Icons.lock_open_rounded),
        const SizedBox(height: AppSpacing.xs),
        _buildPasswordField(
          controller: _newPasswordController,
          focusNode: _newPasswordFocus,
          hintText: l10n.hint_enter_new_password,
          obscureText: _obscureNewPassword,
          toggleObscure: () {
            setState(() {
              _obscureNewPassword = !_obscureNewPassword;
            });
          },
          onChanged: (value) {
            _calculatePasswordStrength(value);
            if (_passwordError != null) {
              setState(() {
                _passwordError = null;
              });
            }
          },
        ),

        if (_newPasswordController.text.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          _buildPasswordStrengthIndicator(),
        ],

        const SizedBox(height: AppSpacing.lg),

        // 确认密码输入
        _buildInputLabel(l10n.confirm_password, Icons.lock_rounded),
        const SizedBox(height: AppSpacing.xs),
        _buildPasswordField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocus,
          hintText: l10n.hint_confirm_new_password,
          obscureText: _obscureConfirmPassword,
          toggleObscure: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),

        const SizedBox(height: AppSpacing.lg),

        // 提示信息
        _buildPasswordTips(l10n),

        const SizedBox(height: AppSpacing.xl),

        // 继续按钮
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _validateAndContinue,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.arrow_forward_rounded),
            label: Text(
              l10n.next_step,
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 旧密码验证阶段
  Widget _buildOldPasswordVerification(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 显示新密码已设置
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.successLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.successLight),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.new_password,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '********',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showOldPasswordInput = false;
                  });
                },
                icon: const Icon(Icons.edit_rounded),
                color: AppColors.primary,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // 旧密码输入
        _buildInputLabel(l10n.enter_old_password, Icons.lock_outline_rounded),
        const SizedBox(height: AppSpacing.xs),
        _buildPasswordField(
          controller: _oldPasswordController,
          focusNode: _oldPasswordFocus,
          hintText: l10n.enter_old_password,
          obscureText: _obscureOldPassword,
          toggleObscure: () {
            setState(() {
              _obscureOldPassword = !_obscureOldPassword;
            });
          },
        ),

        const SizedBox(height: AppSpacing.xl),

        // 提示
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.warningLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              Icon(
                Icons.security_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.enter_old_password_tip,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // 提交按钮
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _handleSubmit,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(
              l10n.confirm,
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required bool obscureText,
    required VoidCallback toggleObscure,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        suffixIcon: IconButton(
          onPressed: toggleObscure,
          icon: Icon(
            obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }

  /// 密码强度指示器
  Widget _buildPasswordStrengthIndicator() {
    Color strengthColor;
    String strengthText;

    if (_passwordStrength <= 0.3) {
      strengthColor = AppColors.error;
      strengthText = 'Weak';
    } else if (_passwordStrength <= 0.6) {
      strengthColor = AppColors.warning;
      strengthText = 'Medium';
    } else {
      strengthColor = AppColors.success;
      strengthText = 'Strong';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Password Strength: ',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              strengthText,
              style: AppTextStyles.labelSmall.copyWith(
                color: strengthColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _passwordStrength,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  /// 密码提示
  Widget _buildPasswordTips(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight.withOpacity(0.1),
            AppColors.secondaryLight.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.warning,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.tips,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '• ${l10n.password_length_at_least_6}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '• Include uppercase and lowercase letters',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '• Include numbers and special characters',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 计算密码强度
  void _calculatePasswordStrength(String password) {
    double strength = 0;

    if (password.length >= 6) strength += 0.2;
    if (password.length >= 10) strength += 0.2;

    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.1;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.15;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.15;

    setState(() {
      _passwordStrength = strength.clamp(0.0, 1.0);
    });
  }

  /// 验证新密码并继续
  void _validateAndContinue() {
    final l10n = AppLocalizations.of(context)!;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty) {
      setState(() {
        _passwordError = l10n.please_enter_new_password;
      });
      return;
    }

    // 验证密码长度
    if (newPassword.length < 6) {
      setState(() {
        _passwordError = l10n.password_length_at_least_6;
      });
      return;
    }

    // 验证两次输入是否一致
    if (confirmPassword.isEmpty) {
      ShowToast.showCenterToast(context, l10n.hint_confirm_new_password);
      return;
    }

    if (newPassword != confirmPassword) {
      ShowToast.showCenterToast(context, l10n.passwords_do_not_match);
      return;
    }

    // 所有验证通过，进入旧密码验证阶段
    setState(() {
      _showOldPasswordInput = true;
    });
  }

  /// 提交修改
  Future<void> _handleSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text;

    if (oldPassword.isEmpty) {
      ShowToast.showCenterToast(context, l10n.enter_old_password);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // 验证旧密码
      final isVerified = await userProvider.verifyUserIdentity(
        userProvider.user!.Email,
        oldPassword,
        context,
      );

      if (!isVerified) {
        ShowToast.showCenterToast(context, l10n.email_or_password_incorrect);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 旧密码验证通过，更新密码
      final message = await userProvider.updateUserInfo(
        newPassword,
        4, // 密码类型代码
        context,
      );

      if (message == l10n.modification_success || message == l10n.update_success) {
        ShowToast.showCenterToast(context, l10n.update_success);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        ShowToast.showCenterToast(context, message);
      }
    } catch (e) {
      ShowToast.showCenterToast(context, l10n.modification_failed);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
