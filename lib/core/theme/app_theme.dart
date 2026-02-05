import 'package:flutter/material.dart';

/// 应用颜色系统
class AppColors {
  // 私有构造函数，防止实例化
  AppColors._();

  // ==================== 品牌颜色 ====================
  /// 主色调 - 蓝色
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  /// 次要色 - 紫色
  static const Color secondary = Color(0xFF9C27B0);
  static const Color secondaryDark = Color(0xFF7B1FA2);
  static const Color secondaryLight = Color(0xFFBA68C8);

  // ==================== 功能颜色 ====================
  /// 成功 - 绿色
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);

  /// 错误 - 红色
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFEF5350);

  /// 警告 - 橙色
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);

  /// 信息 - 青色
  static const Color info = Color(0xFF00BCD4);
  static const Color infoLight = Color(0xFF4DD0E1);

  // ==================== 中性色 ====================
  /// 文字颜色
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// 背景颜色
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// 分割线
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // ==================== 渐变色 ====================
  /// 蓝色渐变
  static const LinearGradient gradientBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  /// 紫色渐变
  static const LinearGradient gradientPurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryLight, secondary],
  );

  /// 橙色渐变
  static const LinearGradient gradientOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warningLight, warning],
  );

  /// 蓝紫渐变（用于金额卡片）
  static LinearGradient gradientBluePurple(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [const Color(0xFF1565C0), const Color(0xFF6A1B9A)]
          : [Colors.blue.shade600, Colors.purple.shade500],
    );
  }

  // ==================== 阴影颜色 ====================
  static Color get shadowColor => Colors.black.withOpacity(0.1);
  static Color get shadowColorDark => Colors.black.withOpacity(0.3);
}

/// 应用间距系统
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4.0;   // 极小间距
  static const double xs = 8.0;    // 小间距
  static const double sm = 12.0;   // 小中
  static const double md = 16.0;   // 中
  static const double lg = 24.0;   // 大
  static const double xl = 32.0;   // 超大
  static const double xxl = 48.0;  // 极大
  static const double xxxl = 64.0; // 超极大

  /// 边框半径
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusCircle = 999.0;
}

/// 应用文本样式系统
class AppTextStyles {
  AppTextStyles._();

  // ==================== 标题样式 ====================
  /// 超大标题
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// 大标题
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// 中标题
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ==================== 标题样式 ====================
  /// 大号标题
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// 中号标题
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// 小号标题
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ==================== 正文样式 ====================
  /// 大号正文
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 中号正文
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 小号正文
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ==================== 标签样式 ====================
  /// 大号标签
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// 中号标签
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// 小号标签
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    height: 1.4,
  );
}

/// 应用阴影系统
class AppShadows {
  AppShadows._();

  /// 小阴影
  static List<BoxShadow> get small => [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// 中阴影
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  /// 大阴影
  static List<BoxShadow> get large => [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  /// 卡片阴影
  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}

/// 应用边框系统
class AppBorders {
  AppBorders._();

  /// 默认边框
  static const Border defaultBorder = Border(
    top: BorderSide(color: AppColors.divider, width: 1),
    bottom: BorderSide(color: AppColors.divider, width: 1),
    left: BorderSide(color: AppColors.divider, width: 1),
    right: BorderSide(color: AppColors.divider, width: 1),
  );

  /// 无边框
  static const Border none = Border.fromBorderSide(BorderSide.none);

  /// 圆角边框
  static OutlineInputBorder outlineBorder({
    Color color = AppColors.divider,
    double width = 1.0,
    double radius = AppSpacing.radiusSm,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
