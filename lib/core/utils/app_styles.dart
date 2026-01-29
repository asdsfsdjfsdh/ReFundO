import 'package:flutter/material.dart';

/// 应用通用样式类
/// 集中管理重复使用的样式，避免代码重复
class AppStyles {
  // 私有构造函数，防止实例化
  AppStyles._();

  // ==================== 文本样式 ====================

  /// 标题样式 - 大号粗体
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  /// 标题样式 - 中号粗体
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  /// 标题样式 - 小号
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  /// 副标题样式
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  /// 正文样式
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  /// 说明文字样式
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  /// 按钮文字样式
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  /// 金额显示样式
  static const TextStyle amount = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  // ==================== 间距 ====================

  /// 极小间距
  static const double spacingXS = 4.0;

  /// 小间距
  static const double spacingS = 8.0;

  /// 中间距
  static const double spacingM = 16.0;

  /// 大间距
  static const double spacingL = 24.0;

  /// 超大间距
  static const double spacingXL = 32.0;

  // ==================== 圆角 ====================

  /// 小圆角
  static const double radiusS = 8.0;

  /// 中圆角
  static const double radiusM = 12.0;

  /// 大圆角
  static const double radiusL = 16.0;

  /// 超大圆角
  static const double radiusXL = 20.0;

  /// 圆形
  static const double radiusCircle = 999.0;

  // ==================== 阴影 ====================

  /// 小阴影
  static List<BoxShadow> get shadowSmall => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// 中阴影
  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// 大阴影
  static List<BoxShadow> get shadowLarge => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  // ==================== 渐变 ====================

  /// 蓝色渐变
  static const LinearGradient gradientBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2196F3),
      Color(0xFF1976D2),
    ],
  );

  /// 紫色渐变
  static const LinearGradient gradientPurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF9C27B0),
      Color(0xFF7B1FA2),
    ],
  );

  /// 绿色渐变
  static const LinearGradient gradientGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4CAF50),
      Color(0xFF388E3C),
    ],
  );

  /// 蓝紫渐变（用于金额卡片）
  static LinearGradient gradientBluePurple(BuildContext context) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blue.shade600,
          Colors.purple.shade500,
        ],
      );

  // ==================== 边框 ====================

  /// 默认边框
  static const Border borderDefault = Border(
    top: BorderSide(color: Colors.grey, width: 1),
    bottom: BorderSide(color: Colors.grey, width: 1),
    left: BorderSide(color: Colors.grey, width: 1),
    right: BorderSide(color: Colors.grey, width: 1),
  );

  /// 无边框
  static const Border borderNone = Border.fromBorderSide(BorderSide.none);

  // ==================== 装饰 ====================

  /// 卡片装饰 - 白色背景，小阴影
  static BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radiusM),
        boxShadow: shadowSmall,
      );

  /// 圆形卡片装饰
  static BoxDecoration circleCardDecoration({Color? color}) => BoxDecoration(
        color: color ?? Colors.white,
        shape: BoxShape.circle,
        boxShadow: shadowSmall,
      );
}
