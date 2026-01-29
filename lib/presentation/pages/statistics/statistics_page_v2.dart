import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/widgets/app_cards.dart';
import 'package:refundo/presentation/widgets/app_states.dart';

/// 统计分析页面
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _selectedPeriod = 'week';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final orderProvider = Provider.of<OrderProvider>(context);
    final refundProvider = Provider.of<RefundProvider>(context);

    final orders = orderProvider.orders ?? [];
    final refunds = refundProvider.refunds ?? [];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.amber.shade50.withOpacity(0.3),
              Colors.grey.shade50,
              Colors.white,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // 顶部应用栏
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '统计分析',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.amber.shade600,
                        Colors.orange.shade600,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () {
                    // 刷新数据
                    orderProvider.getOrders(context);
                  },
                ),
              ],
            ),

            // 内容区域
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 时间选择器
                    _buildPeriodSelector(l10n),
                    const SizedBox(height: 24),

                    // 统计卡片
                    _buildStatisticsCards(orders, refunds, l10n),
                    const SizedBox(height: 24),

                    // 订单统计
                    _buildOrderSection(orders, l10n),
                    const SizedBox(height: 24),

                    // 退款统计
                    _buildRefundSection(refunds, l10n),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(AppLocalizations l10n) {
    return Row(
      children: [
        _buildPeriodOption('本周', 'week', Icons.calendar_view_week_rounded),
        const SizedBox(width: 12),
        _buildPeriodOption('本月', 'month', Icons.calendar_month_rounded),
        const SizedBox(width: 12),
        _buildPeriodOption('本季', 'quarter', Icons.date_range_rounded),
        const SizedBox(width: 12),
        _buildPeriodOption('本年', 'year', Icons.calendar_today_rounded),
      ],
    );
  }

  Widget _buildPeriodOption(String label, String value, IconData icon) {
    final isSelected = _selectedPeriod == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber.shade600 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.amber.shade600 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.amber.shade600.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(List orders, List refunds, AppLocalizations l10n) {
    final totalOrders = orders.length;
    final totalAmount = orders.fold<double>(
      0,
      (sum, order) => sum + (order.price?.toDouble() ?? 0),
    );
    final pendingRefunds = refunds.where((r) => r.status == 'pending').length;
    const completedRefunds = 0; // 需要从实际数据获取

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.shopping_cart_rounded,
            iconColor: Colors.blue.shade600,
            title: '总订单',
            value: '$totalOrders',
            subtitle: '个订单',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.payments_rounded,
            iconColor: Colors.green.shade600,
            title: '总金额',
            value: '${totalAmount.toStringAsFixed(0)}',
            subtitle: 'FCFA',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return AppCards.basic(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSection(List orders, AppLocalizations l10n) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '订单统计',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        AppCards.withHeader(
          title: '今日订单',
          trailing: Text(
            '${orders.length} 个',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          content: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length > 5 ? 5 : orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.receipt_long_rounded, color: Colors.blue.shade700, size: 20),
                ),
                title: Text(
                  '订单 #${order.orderNumber ?? index}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(order.time?.toString() ?? ''),
                trailing: Text(
                  '${(order.price?.toDouble() ?? 0).toStringAsFixed(0)} FCFA',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRefundSection(List refunds, AppLocalizations l10n) {
    final pendingCount = refunds.where((r) => r.status == 'pending').length;
    const completedCount = 0; // 需要从实际数据获取

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '退款统计',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRefundStatCard(
                label: '待处理',
                count: pendingCount,
                color: Colors.orange,
                icon: Icons.pending_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRefundStatCard(
                label: '已完成',
                count: completedCount,
                color: Colors.green,
                icon: Icons.check_circle_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRefundStatCard({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return AppCards.basic(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
