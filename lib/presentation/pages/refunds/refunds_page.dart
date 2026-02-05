import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/theme/app_theme.dart';
import 'package:refundo/data/models/refund_model.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:intl/intl.dart';

/// 退款页面 - Material Design 3风格
class RefundsPage extends StatefulWidget {
  const RefundsPage({super.key});

  @override
  State<RefundsPage> createState() => _RefundsPageState();
}

class _RefundsPageState extends State<RefundsPage> {
  @override
  void initState() {
    super.initState();
    // 页面加载时自动获取数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRefunds();
    });
  }

  // 加载退款数据
  Future<void> _loadRefunds() async {
    final refundProvider = Provider.of<RefundProvider>(context, listen: false);
    try {
      await refundProvider.getRefunds(context);
    } catch (e) {
      // 忽略错误，Provider已经处理了错误显示
    }
  }

  // 下拉刷新
  Future<void> _onRefresh() async {
    await _loadRefunds();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RefundProvider>(
      builder: (context, refundProvider, child) {
        return Scaffold(
          // 使用主题颜色的AppBar，不使用渐变
          appBar: _buildAppBar(context),
          body: _buildRefundsPage(context, refundProvider),
        );
      },
    );
  }

  /// 构建AppBar - 使用纯色而非渐变
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(
        l10n.refunds,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      // 使用主题颜色
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      automaticallyImplyLeading: false,
    );
  }

  /// 退款页面
  Widget _buildRefundsPage(BuildContext context, RefundProvider refundProvider) {
    final l10n = AppLocalizations.of(context)!;
    final refunds = refundProvider.refunds ?? [];

    // 统计数据
    final totalRefunds = refunds.length;
    final completedRefunds = refunds.where((r) => r.refundState == RefundStates.completed).length;
    final pendingRefunds = refunds.where((r) => r.refundState != RefundStates.completed).length;

    // 计算总金额
    final totalAmount = refunds.fold<double>(
      0,
      (sum, refund) => sum + (refund.refundAmount?.toDouble() ?? 0),
    );
    final completedAmount = refunds
        .where((r) => r.refundState == RefundStates.completed)
        .fold<double>(0, (sum, refund) => sum + (refund.refundAmount?.toDouble() ?? 0));
    final pendingAmount = totalAmount - completedAmount;

    if (refunds.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.receipt_long_rounded,
        title: l10n.no_withdrawal_records,
        subtitle: l10n.withdrawal_records_will_appear_here,
      );
    }

    return Column(
      children: [
        // 顶部统计横幅 - 统一卡片设计
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: AppColors.background,
          child: _buildUnifiedStatCard(context, l10n, totalRefunds, completedRefunds, totalAmount, completedAmount),
        ),
        // 退款列表 - 使用Material 3 Card包装ListTile
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: refunds.length,
              itemBuilder: (context, index) {
                return _buildRefundCard(context, refunds[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 统计卡片 - 使用渐变
  Widget _buildStatCard(IconData icon, String value, String label, LinearGradient gradient) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// 统一统计卡片 - 带环形进度条展示已完成比例
  Widget _buildUnifiedStatCard(
    BuildContext context,
    AppLocalizations l10n,
    int totalRefunds,
    int completedRefunds,
    double totalAmount,
    double completedAmount,
  ) {
    final completedRatio = totalRefunds > 0 ? completedRefunds / totalRefunds : 0.0;
    final completedPercentage = (completedRatio * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10B981), Color(0xFF059669), Color(0xFF047857)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // 左侧：环形进度条
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 背景圆环
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // 进度圆环
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: completedRatio,
                      strokeWidth: 12,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  // 中心文字
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$completedPercentage%',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        l10n.completed,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.lg),

          // 右侧：统计数据
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 总退款数
                _buildStatItem(
                  Icons.receipt_long_rounded,
                  l10n.total,
                  '$totalRefunds',
                  Colors.white,
                ),
                const SizedBox(height: AppSpacing.sm),
                // 已完成
                _buildStatItem(
                  Icons.check_circle_rounded,
                  l10n.completed,
                  '$completedRefunds',
                  Colors.white,
                ),
                const SizedBox(height: AppSpacing.sm),
                // 已提现金额
                _buildStatItem(
                  Icons.payments_rounded,
                  l10n.total_amount,
                  '${completedAmount.toStringAsFixed(0)} FCFA',
                  Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 统计条目
  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: color.withOpacity(0.8),
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.titleMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 退款卡片 - Material 3 Card
  Widget _buildRefundCard(BuildContext context, dynamic refund) {
    final l10n = AppLocalizations.of(context)!;
    final state = refund.refundState;

    // 使用helper方法获取正确的状态显示
    final statusColor = _getStatusColor(state);
    final statusIcon = _getStatusIcon(state);
    final statusText = _getStatusText(state, l10n);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: InkWell(
        onTap: () => _showRefundDetail(context, refund),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppSpacing.md),
          leading: CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.1),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          title: Text(
            l10n.order_number_with_hash(refund.orderNumber ?? "N/A"),
            style: AppTextStyles.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              l10n.refund_amount_with_currency(refund.refundAmount?.toString() ?? "0"),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              statusText,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 空状态页面
  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppColors.textHint),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 显示退款详情对话框
  void _showRefundDetail(BuildContext context, dynamic refund) {
    final l10n = AppLocalizations.of(context)!;
    final state = refund.refundState;

    // 根据状态设置颜色和图标
    final statusColor = _getStatusColor(state);
    final statusIcon = _getStatusIcon(state);
    final statusText = _getStatusText(state, l10n);

    // 格式化退款方式
    String refundMethodText;
    IconData methodIcon;
    switch (refund.refundMethod) {
      case 1:
        refundMethodText = l10n.orange_money;
        methodIcon = Icons.phone_android;
        break;
      case 2:
        refundMethodText = l10n.wave;
        methodIcon = Icons.wifi;
        break;
      default:
        refundMethodText = l10n.phone_number_label;
        methodIcon = Icons.phone;
    }

    // 格式化时间
    String formattedTime = 'N/A';
    try {
      if (refund.timestamp != null && refund.timestamp.isNotEmpty) {
        final dateTime = DateTime.parse(refund.timestamp);
        formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
      }
    } catch (e) {
      formattedTime = refund.timestamp ?? 'N/A';
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.gradientPurple,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.receipt_long, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                l10n.refund_details,
                style: AppTextStyles.titleLarge,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('${l10n.refund} #', '#${refund.recordId ?? "N/A"}'),
              const Divider(),
              _buildDetailRow(l10n.order_number, refund.orderNumber ?? 'N/A'),
              const Divider(),
              _buildDetailRow(l10n.order_id_label, '${refund.orderId ?? "N/A"}'),
              const Divider(),
              _buildDetailRow(l10n.product_id, refund.productId ?? 'N/A'),
              const Divider(),
              _buildDetailRow(l10n.refund_amount, '${refund.refundAmount?.toString() ?? "0"} FCFA', highlight: true, color: AppColors.success),
              const Divider(),
              _buildDetailRow(l10n.refund_method, refundMethodText, icon: methodIcon),
              const Divider(),
              _buildDetailRow(l10n.refund_account, refund.account?.isNotEmpty == true ? refund.account : l10n.not_set),
              const Divider(),
              _buildDetailRow(l10n.time, formattedTime),
              const Divider(),
              _buildDetailRow(
                l10n.approval_status_label,
                statusText,
                status: true,
                statusColor: statusColor,
              ),
              // 只有交易完成且有凭证时才显示交易凭证
              if (refund.remittanceReceipt?.isNotEmpty == true) ...[
                const Divider(),
                _buildTransactionReceiptRow(l10n, refund.remittanceReceipt!),
              ],
              if (refund.nickName?.isNotEmpty == true) ...[
                const Divider(),
                _buildDetailRow(l10n.username, refund.nickName),
              ],
              if (refund.email?.isNotEmpty == true) ...[
                const Divider(),
                _buildDetailRow(l10n.email, refund.email),
              ],
              if (refund.phone?.isNotEmpty == true) ...[
                const Divider(),
                _buildDetailRow(l10n.phone_number_label, refund.phone),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  /// 详情行
  Widget _buildDetailRow(
    String label,
    String value, {
    bool highlight = false,
    Color? color,
    bool status = false,
    Color? statusColor,
    IconData? icon,
  }) {
    // 确定状态标签的颜色和背景色
    Color finalStatusColor = statusColor ?? AppColors.success;
    Color finalStatusBgColor;

    if (statusColor == AppColors.success) {
      finalStatusBgColor = AppColors.successLight;
    } else if (statusColor == AppColors.error) {
      finalStatusBgColor = AppColors.errorLight;
    } else {
      finalStatusBgColor = AppColors.warningLight;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (status)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: finalStatusBgColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (statusColor == AppColors.success)
                    Icon(Icons.check_circle, size: 14, color: statusColor),
                  if (statusColor == AppColors.warning)
                    Icon(Icons.pending, size: 14, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: finalStatusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else if (icon != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                    color: color ?? AppColors.textPrimary,
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                color: color ?? AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }

  /// 交易凭证行 - 显示图片凭证
  Widget _buildTransactionReceiptRow(AppLocalizations l10n, String receiptUrl) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.transaction_receipt,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            InkWell(
              onTap: () => _showReceiptImage(context, receiptUrl),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: Image.network(
                    receiptUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 40, color: AppColors.textHint),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              l10n.image_load_failed,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.click_to_view_full_image,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示凭证大图
  void _showReceiptImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: InteractiveViewer(
                    child: Image.network(imageUrl),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 获取状态对应的颜色
  Color _getStatusColor(RefundStates state) {
    switch (state) {
      case RefundStates.pending:
        return AppColors.warning;      // 待审核 - 黄色
      case RefundStates.approved:
        return AppColors.info;         // 审批通过，等待交易 - 蓝色
      case RefundStates.completed:
        return AppColors.success;       // 交易完成 - 绿色
      case RefundStates.processing:
        return AppColors.info;         // 处理中 - 蓝色
      case RefundStates.rejected:
        return AppColors.error;         // 审批拒绝 - 红色
      case RefundStates.transactionFailed:
        return AppColors.error;         // 交易失败 - 红色
    }
  }

  // 获取状态对应的图标
  IconData _getStatusIcon(RefundStates state) {
    switch (state) {
      case RefundStates.pending:
        return Icons.pending;          // 待审核
      case RefundStates.approved:
        return Icons.schedule;          // 等待交易
      case RefundStates.completed:
        return Icons.check_circle;       // 交易完成
      case RefundStates.processing:
        return Icons.refresh;            // 处理中
      case RefundStates.rejected:
        return Icons.cancel;             // 审批拒绝
      case RefundStates.transactionFailed:
        return Icons.error_outline;     // 交易失败
    }
  }

  // 获取状态对应的文本
  String _getStatusText(RefundStates state, AppLocalizations l10n) {
    switch (state) {
      case RefundStates.pending:
        return l10n.in_review;           // 待审核
      case RefundStates.approved:
        return l10n.pending;             // 等待交易
      case RefundStates.completed:
        return l10n.completed;    
      case RefundStates.processing:
        return l10n.processing;          // 处理中
      case RefundStates.rejected:
        return l10n.rejected;            // 审批拒绝
      case RefundStates.transactionFailed:
        return l10n.transaction_failed;  // 交易失败
    }
  }
}
