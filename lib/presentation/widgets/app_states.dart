import 'package:flutter/material.dart';
import 'package:refundo/core/theme/app_theme.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/widgets/app_cards.dart';

/// 应用空状态组件
class AppEmptyStates {
  AppEmptyStates._();

  /// 通用空状态
  static Widget basic({
    required String title,
    required String message,
    IconData icon = Icons.inbox_outlined,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 标题
            Text(
              title,
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),

            // 描述
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // 操作按钮
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 订单空状态
  static Widget orders(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return basic(
      title: l10n.no_orders_yet,
      message: l10n.no_orders_yet_detail,
      icon: Icons.receipt_long_outlined,
    );
  }

  /// 退款空状态
  static Widget refunds(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return basic(
      title: l10n.no_refunds_yet,
      message: l10n.no_refunds_yet_detail,
      icon: Icons.account_balance_wallet_outlined,
    );
  }

  /// 搜索结果空状态
  static Widget search(BuildContext context, String query, VoidCallback? onClear) {
    final l10n = AppLocalizations.of(context)!;
    return basic(
      title: l10n.no_search_results,
      message: l10n.no_search_results_detail(query),
      icon: Icons.search_off,
      actionLabel: l10n.clear_search,
      onAction: onClear,
    );
  }

  /// 网络错误空状态
  static Widget networkError(BuildContext context, {VoidCallback? onRetry}) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 错误图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 标题
            Text(
              l10n.network_connection_failed,
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),

            // 描述
            Text(
              l10n.check_network_settings,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            // 重试按钮
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 服务器错误空状态
  static Widget serverError(BuildContext context, {VoidCallback? onRetry}) {
    final l10n = AppLocalizations.of(context)!;
    return basic(
      title: l10n.server_error_title,
      message: l10n.server_error_detail,
      icon: Icons.cloud_off,
      actionLabel: l10n.retry,
      onAction: onRetry,
    );
  }
}

/// 应用加载状态组件
class AppLoadingStates {
  AppLoadingStates._();

  /// 基础加载状态
  static Widget basic({
    String? message,
    Color? color,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: color != null
                  ? AlwaysStoppedAnimation<Color>(color)
                  : null,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  /// 全屏加载遮罩
  static Widget fullScreen({
    String? message,
    Color? backgroundColor,
  }) {
    return Container(
      color: backgroundColor ?? Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
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
    );
  }

  /// 加载更多指示器
  static Widget loadMore({
    String? message,
  }) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          if (message != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              message,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  /// 没有更多数据提示
  static Widget noMoreData(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: Text(
        l10n.no_more_data,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textHint,
        ),
      ),
    );
  }
}

/// 应用状态提示（Toast/Snackbar）
class AppStateNotifications {
  AppStateNotifications._();

  /// 成功提示
  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
    );
  }

  /// 错误提示
  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
    );
  }

  /// 警告提示
  static void warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.warning,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
    );
  }

  /// 信息提示
  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.info,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
    );
  }
}
