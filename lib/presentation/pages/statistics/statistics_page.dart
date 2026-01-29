import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart';

/// 统计分析页面
/// 展示订单和退款的数据统计
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _selectedPeriod = 'month'; // week, month, quarter, year

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.statistics),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 时间选择器
            _buildPeriodSelector(context),
            const SizedBox(height: 24),

            // 统计卡片
            _buildStatisticsCards(context),
            const SizedBox(height: 24),

            // 图表区域
            _buildChartSection(context),
            const SizedBox(height: 24),

            // 详细数据列表
            _buildDetailsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPeriodOption(l10n!.this_week, 'week'),
          _buildPeriodOption(l10n.this_month, 'month'),
          _buildPeriodOption(l10n.this_quarter, 'quarter'),
          _buildPeriodOption(l10n.this_year, 'year'),
        ],
      ),
    );
  }

  Widget _buildPeriodOption(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPeriod = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade600 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard(
              context,
              l10n!.total_amount,
              '125,500 FCFA',
              Icons.account_balance_wallet_rounded,
              Colors.blue,
            )),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(
              context,
              l10n.total_orders,
              '48',
              Icons.shopping_cart_rounded,
              Colors.orange,
            )),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard(
              context,
              l10n.refund_success,
              '42',
              Icons.check_circle_rounded,
              Colors.green,
            )),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(
              context,
              l10n.refund_pending,
              '6',
              Icons.pending_rounded,
              Colors.purple,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n!.refund_trend,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // 简化版柱状图（实际使用 fl_chart 绘制）
          _buildSimpleBarChart(),
        ],
      ),
    );
  }

  Widget _buildSimpleBarChart() {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBar('1月', 0.6),
          _buildBar('2月', 0.8),
          _buildBar('3月', 0.5),
          _buildBar('4月', 0.9),
          _buildBar('5月', 0.7),
          _buildBar('6月', 0.85),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 150 * height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade400,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n!.refund_details,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // 导出功能
                  _exportData(context);
                },
                icon: const Icon(Icons.download_rounded),
                label: l10n.export,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailItem('Product A', '15,000 FCFA', '2025-01-28'),
          const Divider(),
          _buildDetailItem('Product B', '12,500 FCFA', '2025-01-27'),
          const Divider(),
          _buildDetailItem('Product C', '10,000 FCFA', '2025-01-26'),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String product, String amount, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade600,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _exportData(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n!.export_functionality_coming_soon),
        backgroundColor: Colors.green.shade600,
        action: SnackBarAction(
          label: l10n.ok,
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
