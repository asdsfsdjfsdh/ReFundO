import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/theme/app_theme.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/core/utils/showToast.dart';
import 'package:refundo/presentation/providers/user_provider.dart';

/// 优化的邮箱修改组件 - 先输入新邮箱，验证格式后再验证身份
class EmailUpdateSheet extends StatefulWidget {
  const EmailUpdateSheet({super.key});

  @override
  State<EmailUpdateSheet> createState() => _EmailUpdateSheetState();
}

class _EmailUpdateSheetState extends State<EmailUpdateSheet> {
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _newEmailFocus = FocusNode();
  final _confirmEmailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _showPasswordInput = false;
  String? _emailError;

  @override
  void dispose() {
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _newEmailFocus.dispose();
    _confirmEmailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.55 + bottomInset,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖动指示器
          _buildDragHandle(),

          // 标题
          _buildHeader(l10n),

          // 内容
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: bottomInset + AppSpacing.lg,
              ),
              child: _showPasswordInput
                  ? _buildPasswordVerification(l10n)
                  : _buildNewEmailInput(l10n),
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
          l10n.email_change_title,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _showPasswordInput
              ? l10n.verify_identity
              : l10n.enter_new_email,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  /// 新邮箱输入阶段
  Widget _buildNewEmailInput(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 新邮箱输入
        _buildInputLabel(l10n.new_email, Icons.email_outlined),
        const SizedBox(height: AppSpacing.xs),
        _buildEmailField(
          controller: _newEmailController,
          focusNode: _newEmailFocus,
          hintText: l10n.enter_new_email,
          errorText: _emailError,
        ),

        const SizedBox(height: AppSpacing.lg),

        // 确认邮箱输入
        _buildInputLabel(l10n.confirm_new_email, Icons.mark_email_read_outlined),
        const SizedBox(height: AppSpacing.xs),
        _buildEmailField(
          controller: _confirmEmailController,
          focusNode: _confirmEmailFocus,
          hintText: l10n.confirm_new_email,
        ),

        const SizedBox(height: AppSpacing.xl),

        // 提示信息
        _buildTipCard(l10n),

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

  /// 密码验证阶段
  Widget _buildPasswordVerification(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 显示新邮箱
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.primaryLight),
          ),
          child: Row(
            children: [
              Icon(
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
                      l10n.new_email,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _newEmailController.text,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showPasswordInput = false;
                  });
                },
                icon: const Icon(Icons.edit_rounded),
                color: AppColors.primary,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // 密码输入
        _buildInputLabel(l10n.enter_password, Icons.lock_outline_rounded),
        const SizedBox(height: AppSpacing.xs),
        _buildPasswordField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          hintText: l10n.enter_password,
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
                Icons.info_outline_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.enter_password_to_verify,
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

  Widget _buildEmailField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (_) {
        if (_emailError != null) {
          setState(() {
            _emailError = null;
          });
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: true,
      textInputAction: TextInputAction.done,
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
      ),
    );
  }

  Widget _buildTipCard(AppLocalizations l10n) {
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
            l10n.email_format_tip,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 验证新邮箱并继续
  void _validateAndContinue() {
    final l10n = AppLocalizations.of(context)!;
    final newEmail = _newEmailController.text.trim();
    final confirmEmail = _confirmEmailController.text.trim();

    // 验证新邮箱
    if (newEmail.isEmpty) {
      setState(() {
        _emailError = l10n.please_enter_new_email;
      });
      return;
    }

    // 邮箱格式验证
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(newEmail)) {
      setState(() {
        _emailError = l10n.invalid_email_format;
      });
      return;
    }

    // 验证两次输入是否一致
    if (confirmEmail.isEmpty) {
      ShowToast.showCenterToast(context, l10n.please_enter_complete_info);
      return;
    }

    if (newEmail != confirmEmail) {
      ShowToast.showCenterToast(context, l10n.emails_do_not_match);
      return;
    }

    // 所有验证通过，进入密码验证阶段
    setState(() {
      _showPasswordInput = true;
    });
  }

  /// 提交修改
  Future<void> _handleSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    final password = _passwordController.text.trim();
    final newEmail = _newEmailController.text.trim();

    if (password.isEmpty) {
      ShowToast.showCenterToast(context, l10n.please_enter_password);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // 先验证身份
      final isVerified = await userProvider.verifyUserIdentity(
        userProvider.user!.Email,
        password,
        context,
      );

      if (!isVerified) {
        ShowToast.showCenterToast(context, l10n.email_or_password_incorrect);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 身份验证通过，更新邮箱
      final message = await userProvider.updateUserInfo(
        newEmail,
        3, // 邮箱类型代码
        context,
      );

      if (message == l10n.modification_success) {
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
