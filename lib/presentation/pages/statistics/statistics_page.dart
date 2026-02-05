import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/theme/app_theme.dart';
import 'package:refundo/data/models/refund_model.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:intl/intl.dart';

/// 统计页面 - Material Design 3风格
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.statistics,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(context, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 概览卡片
          _buildOverviewCards(context, l10n),
          const SizedBox(height: 24),

          // 订单热力图
          _buildHeatmapSection(context, l10n),
          const SizedBox(height: 24),

          // 详细统计
          _buildDetailedStats(context, l10n),
        ],
      ),
    );
  }

  /// 概览卡片
  Widget _buildOverviewCards(BuildContext context, AppLocalizations l10n) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final refundProvider = Provider.of<RefundProvider>(context);
    final orders = orderProvider.orders ?? [];
    final refunds = refundProvider.refunds ?? [];

    // 订单总金额
    final totalOrderAmount = orders.fold<double>(
      0,
      (sum, order) => sum + (order.price?.toDouble() ?? 0),
    );

    // 已提现总金额（完成的退款）
    final withdrawnAmount = refunds
        .where((r) => r.refundState == RefundStates.completed)
        .fold<double>(0, (sum, refund) => sum + (refund.refundAmount?.toDouble() ?? 0));

    // 未提现总金额（待审核+审批通过的退款）
    final pendingWithdrawAmount = refunds
        .where((r) => r.refundState == RefundStates.pending || r.refundState == RefundStates.approved)
        .fold<double>(0, (sum, refund) => sum + (refund.refundAmount?.toDouble() ?? 0));

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            l10n.total_amount,
            '${totalOrderAmount.toStringAsFixed(0)}',
            Icons.account_balance_wallet_rounded,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.withdrawn,
            '${withdrawnAmount.toStringAsFixed(0)}',
            Icons.check_circle_rounded,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.pending_withdrawal,
            '${pendingWithdrawAmount.toStringAsFixed(0)}',
            Icons.pending_rounded,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  /// 统计卡片 - 使用白色背景+elevation
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 订单热力图区域
  Widget _buildHeatmapSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.order_heatmap,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMonthlyHeatmap(context),
      ],
    );
  }

  /// 月历式热力图
  Widget _buildMonthlyHeatmap(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders ?? [];

    // 获取当前月份的第一天和最后一天
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // 统计每天的订单数量
    final Map<DateTime, int> dailyCounts = {};

    for (var order in orders) {
      if (order.OrderTime.isNotEmpty) {
        try {
          DateTime dateTime = DateTime.parse(order.OrderTime);
          // 只统计当前月份的数据
          if (dateTime.year == now.year && dateTime.month == now.month) {
            final dayKey = DateTime(dateTime.year, dateTime.month, dateTime.day);
            dailyCounts[dayKey] = (dailyCounts[dayKey] ?? 0) + 1;
          }
        } catch (e) {
          // 忽略解析错误
        }
      }
    }

    // 找出最大值用于颜色映射
    final maxCount = dailyCounts.values.isNotEmpty ? dailyCounts.values.reduce((a, b) => a > b ? a : b) : 1;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          // 月份标题和切换按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  // TODO: 切换到上个月
                },
              ),
              Text(
                _formatMonthYear(l10n.toString(), now),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  // TODO: 切换到下个月
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 星期标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeekdayLabel(l10n.weekday_mon.substring(0, 1)),
              _buildWeekdayLabel(l10n.weekday_tue.substring(0, 1)),
              _buildWeekdayLabel(l10n.weekday_wed.substring(0, 1)),
              _buildWeekdayLabel(l10n.weekday_thu.substring(0, 1)),
              _buildWeekdayLabel(l10n.weekday_fri.substring(0, 1)),
              _buildWeekdayLabel(l10n.weekday_sat.substring(0, 1)),
              _buildWeekdayLabel(l10n.weekday_sun.substring(0, 1)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          // 日历网格
          _buildCalendarGrid(firstDayOfMonth, lastDayOfMonth, dailyCounts, maxCount),

          const SizedBox(height: AppSpacing.sm),

          // 图例
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.few_label, style: AppTextStyles.bodySmall),
              const SizedBox(width: 4),
              _buildLegendBox(AppColors.successLight),
              const SizedBox(width: 4),
              _buildLegendBox(AppColors.success),
              const SizedBox(width: 4),
              _buildLegendBox(const Color(0xFF2E7D32)),
              const SizedBox(width: 4),
              Text(l10n.heatmap_many, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayLabel(String label) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(
    DateTime firstDay,
    DateTime lastDay,
    Map<DateTime, int> dailyCounts,
    int maxCount,
  ) {
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday; // 1 = Monday, 7 = Sunday

    return Column(
      children: List.generate(
        ((daysInMonth + firstWeekday - 1) / 7).ceil(),
        (weekIndex) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (dayIndex) {
              final dayNum = weekIndex * 7 + dayIndex - firstWeekday + 1;
              if (dayNum < 1 || dayNum > daysInMonth) {
                return const SizedBox(width: 36, height: 36);
              }

              final dayKey = DateTime(firstDay.year, firstDay.month, dayNum);
              final count = dailyCounts[dayKey] ?? 0;

              return _buildDayCell(dayNum, count, maxCount);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(int day, int count, int maxCount) {
    Color cellColor;

    if (count == 0) {
      cellColor = AppColors.background;
    } else if (maxCount == 1) {
      cellColor = AppColors.successLight;
    } else {
      final intensity = count / maxCount;
      if (intensity < 0.33) {
        cellColor = AppColors.successLight;
      } else if (intensity < 0.66) {
        cellColor = AppColors.success;
      } else {
        cellColor = const Color(0xFF2E7D32);
      }
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.background,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$day',
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: count > 0 ? FontWeight.bold : FontWeight.normal,
            color: count > 0 ? Colors.white : AppColors.textHint,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  /// 详细统计区域
  Widget _buildDetailedStats(BuildContext context, AppLocalizations l10n) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders ?? [];

    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    final averageAmount = orders.fold<double>(
      0,
      (sum, order) => sum + (order.price?.toDouble() ?? 0),
    ) / orders.length;

    final maxOrder = orders.reduce((a, b) =>
      (a.price?.toDouble() ?? 0) > (b.price?.toDouble() ?? 0) ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.detailed_statistics,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _buildDetailRow(
                  l10n.average_order_amount,
                  '${averageAmount.toStringAsFixed(2)} FCFA',
                  Icons.show_chart_rounded,
                  Colors.blue,
                ),
                const Divider(),
                _buildDetailRow(
                  l10n.max_order_amount,
                  '${maxOrder.price?.toStringAsFixed(2) ?? '0'} FCFA',
                  Icons.trending_up_rounded,
                  Colors.green,
                ),
                const Divider(),
                _buildDetailRow(
                  l10n.total_orders_count,
                  '${orders.length}',
                  Icons.shopping_bag_rounded,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 格式化月份和年份
  String _formatMonthYear(String localeStr, DateTime date) {
    // 从AppLocalizations字符串中提取语言代码
    // 例如: "Instance of 'AppLocalizationsEn'" -> "en"
    // 或者 "Instance of 'AppLocalizationsZh'" -> "zh"
    String languageCode = 'en'; // 默认英语

    if (localeStr.contains('En') || localeStr.contains('en')) {
      languageCode = 'en';
    } else if (localeStr.contains('Zh') || localeStr.contains('zh')) {
      languageCode = 'zh';
    } else if (localeStr.contains('Fr') || localeStr.contains('fr')) {
      languageCode = 'fr';
    }

    final monthsEn = ['January', 'February', 'March', 'April', 'May', 'June',
                      'July', 'August', 'September', 'October', 'November', 'December'];
    final monthsZh = ['一月', '二月', '三月', '四月', '五月', '六月',
                      '七月', '八月', '九月', '十月', '十一月', '十二月'];
    final monthsFr = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin',
                      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];

    List<String> months;
    if (languageCode == 'zh') {
      months = monthsZh;
      return '${months[date.month - 1]} ${date.year}年';
    } else if (languageCode == 'fr') {
      months = monthsFr;
      return '${months[date.month - 1]} ${date.year}';
    } else {
      months = monthsEn;
      return '${months[date.month - 1]} ${date.year}';
    }
  }
}
