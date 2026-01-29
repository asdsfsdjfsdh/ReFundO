import 'package:flutter/material.dart';
import 'package:refundo/core/theme/app_theme.dart';

/// 应用按钮组件库
class AppButtons {
  AppButtons._();

  /// 主按钮 - 大号
  static Widget primaryLarge({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return _AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      isPrimary: true,
      size: _ButtonSize.large,
    );
  }

  /// 主按钮 - 中号
  static Widget primaryMedium({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return _AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      isPrimary: true,
      size: _ButtonSize.medium,
    );
  }

  /// 次要按钮
  static Widget secondary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return _AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      isPrimary: false,
      size: _ButtonSize.medium,
    );
  }

  /// 文本按钮
  static Widget text({
    required String text,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      child: Text(text, style: AppTextStyles.labelLarge),
    );
  }

  /// 图标按钮
  static Widget icon({
    required IconData iconData,
    required VoidCallback? onPressed,
    Color? color,
    String? tooltip,
  }) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
      color: color ?? AppColors.primary,
      tooltip: tooltip,
      splashRadius: 24,
    );
  }
}

enum _ButtonSize { small, medium, large }

class _AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final bool isPrimary;
  final _ButtonSize size;

  const _AppButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    required this.isPrimary,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final height = _getHeight();
    final fontSize = _getFontSize();
    final borderRadius = AppSpacing.radiusLg;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : AppColors.surface,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          disabledBackgroundColor: AppColors.textHint,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: !isPrimary
              ? const BorderSide(color: AppColors.primary)
              : null,
        ).copyWith(
          overlayColor: MaterialStateProperty.all(
            isPrimary
                ? Colors.white.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: fontSize * 1.5,
                height: fontSize * 1.5,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: fontSize * 1.2),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case _ButtonSize.small:
        return 36;
      case _ButtonSize.medium:
        return 48;
      case _ButtonSize.large:
        return 56;
    }
  }

  double _getFontSize() {
    switch (size) {
      case _ButtonSize.small:
        return 14;
      case _ButtonSize.medium:
        return 16;
      case _ButtonSize.large:
        return 18;
    }
  }
}
