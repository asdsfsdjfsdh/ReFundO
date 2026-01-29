import 'package:flutter/material.dart';
import 'package:refundo/core/theme/app_theme.dart';

/// 应用卡片组件库
class AppCards {
  AppCards._();

  /// 基础卡片
  static Widget basic({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? elevation,
    Color? backgroundColor,
    VoidCallback? onTap,
    BorderRadius? borderRadius,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: elevation != null && elevation > 0
              ? [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: elevation * 2,
                    offset: Offset(0, elevation.toDouble()),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }

  /// 带标题的卡片
  static Widget withHeader({
    required String title,
    required Widget content,
    Widget? trailing,
    Widget? leading,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return basic(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 卡片头部
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: const Border(
                bottom: BorderSide(color: AppColors.divider, width: 1),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusMd),
                topRight: Radius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMedium,
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          // 卡片内容
          Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: content,
          ),
        ],
      ),
    );
  }

  /// 信息卡片（带图标）
  static Widget info({
    required IconData icon,
    required String title,
    required String description,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return basic(
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor: backgroundColor,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 渐变卡片
  static Widget gradient({
    required String title,
    required String value,
    required LinearGradient gradient,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 应用输入框组件库
class AppInputFields {
  AppInputFields._();

  /// 基础文本输入框
  static Widget text({
    required String label,
    required TextEditingController? controller,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
    int? maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium,
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primary)
            : null,
        suffixIcon: suffixIcon,
        border: AppBorders.outlineBorder(),
        enabledBorder: AppBorders.outlineBorder(),
        focusedBorder: AppBorders.outlineBorder(
          color: AppColors.primary,
          width: 2,
        ),
        errorBorder: AppBorders.outlineBorder(
          color: AppColors.error,
        ),
        focusedErrorBorder: AppBorders.outlineBorder(
          color: AppColors.error,
          width: 2,
        ),
        disabledBorder: AppBorders.outlineBorder(
          color: AppColors.divider,
        ),
        filled: true,
        fillColor: enabled ? Colors.white : AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }

  /// 搜索框
  static Widget search({
    required String hintText,
    required void Function(String) onChanged,
    IconData? prefixIcon,
    Widget? suffixIcon,
    VoidCallback? onClear,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textHint,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.textHint)
              : null,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }

  /// 下拉选择框
  static Widget dropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?)? onChanged,
    IconData? prefixIcon,
    String? hintText,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      items: items,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium,
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primary)
            : null,
        border: AppBorders.outlineBorder(),
        enabledBorder: AppBorders.outlineBorder(),
        focusedBorder: AppBorders.outlineBorder(
          color: AppColors.primary,
          width: 2,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      dropdownColor: AppColors.surface,
    );
  }
}

/// 应用加载指示器组件
class AppLoadingIndicators {
  AppLoadingIndicators._();

  /// 圆形加载指示器
  static Widget circular({Color? color}) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: color != null
            ? AlwaysStoppedAnimation<Color>(color)
            : null,
      ),
    );
  }

  /// 加载中遮罩
  static Widget overlay({
    String? message,
    Color? backgroundColor,
  }) {
    return Container(
      color: backgroundColor ?? Colors.black.withOpacity(0.5),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                circular(),
                if (message != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    message,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 加载骨架屏
  static Widget skeleton({
    double width = double.infinity,
    double height = 40,
    BorderRadius? borderRadius,
  }) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.radiusSm),
    );
  }
}

/// 骨架屏加载器
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(_animation.value),
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}
