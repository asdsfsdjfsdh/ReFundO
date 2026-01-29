import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/widgets/refund_widget.dart';
import 'package:refundo/presentation/widgets/refund_confirmation_dialog.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/pages/scanner/scanner_page.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/widgets/app_cards.dart';
import 'package:refundo/presentation/widgets/app_states.dart';
import 'package:refundo/presentation/widgets/loading_widgets.dart';

/// 新的首页 - 订单和退款管理
class HomePageV2 extends StatefulWidget {
  const HomePageV2({super.key});

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  late UserProvider _userProvider;
  double _totalAmount = 0.0;
  bool _isRefunding = false;
  int _currentIndex = 0; // 0: 订单, 1: 退款

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider.onloginSuccess = _initAmount;
    _userProvider.onlogout = _loadData;
    _userProvider.onOrder = _loadData;
  }

  Future<void> _initAmount(double amount) async {
    setState(() {
      _totalAmount = amount;
    });
  }

  Future<void> _loadData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      await orderProvider.getOrders(context);
    } catch (e) {
      LogUtil.e("主页", "加载数据失败: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildOrdersPage(context, l10n),
          _buildRefundsPage(context, l10n),
        ],
      ),
      // 扫码浮动按钮
      floatingActionButton: _currentIndex == 0
        ? FloatingActionButton.extended(
            heroTag: 'scan_fab',
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: const Text('扫码'),
            onPressed: _handleScan,
          )
        : null,
    );
  }

  Widget _buildOrdersPage(BuildContext context, AppLocalizations l10n) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders ?? [];

    // 计算今日订单统计
    final todayOrders = orders; // TODO: 实际过滤今日订单

    return CustomScrollView(
      slivers: [
        // 顶部统计卡片
        SliverToBoxAdapter(
          child: _buildOrdersHeader(todayOrders, l10n),
        ),

        // 订单列表
        if (orders.isEmpty)
          SliverFillRemaining(
            child: AppEmptyStates.orders(
              actionLabel: '扫码添加订单',
              onAction: _handleScan,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildOrderCard(orders[index], index, l10n);
                },
                childCount: orders.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrdersHeader(List orders, AppLocalizations l10n) {
    final totalAmount = orders.fold<double>(
      0,
      (sum, order) => sum + (order.price?.toDouble() ?? 0),
    );

    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 订单数卡片
          Expanded(
            child: AppCards.gradient(
              title: l10n.today_orders,
              value: '${orders.length}',
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade600,
                  Colors.blue.shade700,
                ],
              ),
              icon: Icons.shopping_cart_rounded,
            ),
          ),
          const SizedBox(width: 12),
          // 总金额卡片
          Expanded(
            child: AppCards.gradient(
              title: l10n.total_amount,
              value: '${totalAmount.toStringAsFixed(0)} FCFA',
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade600,
                  Colors.green.shade700,
                ],
              ),
              icon: Icons.payments_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(dynamic order, int index, AppLocalizations l10n) {
    final isSelected = false; // TODO: 从状态管理获取

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: AppCards.basic(
        onTap: () {
          // TODO: 显示订单详情
        },
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 订单信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.order_number + (order.orderNumber ?? ''),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.time?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildTag(l10n.refundable, Colors.green),
                      const SizedBox(width: 8),
                      _buildTag(
                        (order.price?.toDouble() ?? 0).toStringAsFixed(0) + ' FCFA',
                        Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 选择框（用于批量退款）
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                // TODO: 切换选择状态
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefundsPage(BuildContext context, AppLocalizations l10n) {
    final refundProvider = Provider.of<RefundProvider>(context);
    final refunds = refundProvider.refunds ?? [];

    return CustomScrollView(
      slivers: [
        // 顶部统计
        SliverToBoxAdapter(
          child: _buildRefundsHeader(refunds, l10n),
        ),

        // 退款记录列表
        if (refunds.isEmpty)
          SliverFillRemaining(
            child: AppEmptyStates.refunds(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildRefundCard(refunds[index], l10n);
                },
                childCount: refunds.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRefundsHeader(List refunds, AppLocalizations l10n) {
    final pendingCount = refunds.where((r) => r.status == 'pending').length;
    final completedCount = refunds.where((r) => r.status == 'completed').length;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: AppCards.basic(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.pending_rounded, color: Colors.orange, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    '$pendingCount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.pending,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppCards.basic(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    '$completedCount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.completed,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundCard(dynamic refund, AppLocalizations l10n) {
    final status = refund.status ?? 'unknown';
    final statusColor = status == 'completed' ? Colors.green : Colors.orange;
    final statusText = status == 'completed' ? l10n.completed : l10n.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: AppCards.basic(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.withdrawal_application,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRefundDetail(l10n.withdrawal_amount, '${refund.amount ?? 0} FCFA'),
            _buildRefundDetail(l10n.application_time, refund.created_at ?? ''),
            _buildRefundDetail(l10n.payment_method, refund.method ?? '银行卡'),
          ],
        ),
      ),
    );
  }

  Widget _buildRefundDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Future<void> _handleScan() async {
    // 检查相机权限
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.camera_permission_required),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.go_to_settings,
            textColor: Colors.white,
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
      return;
    }

    if (!mounted) return;
    // 跳转到扫码页面
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );
  }
}
