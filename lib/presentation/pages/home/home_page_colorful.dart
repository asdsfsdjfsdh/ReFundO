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

/// 色彩丰富的首页 - 订单和退款管理
class HomePageColorful extends StatefulWidget {
  const HomePageColorful({super.key});

  @override
  State<HomePageColorful> createState() => _HomePageColorfulState();
}

class _HomePageColorfulState extends State<HomePageColorful> {
  late UserProvider _userProvider;
  late double _totalAmount = 0.0;
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
    return WillPopScope(
      onWillPop: () async {
        if (_isRefunding) {
          setState(() {
            _isRefunding = false;
          });
          return false;
        }
        return false;
      },
      child: Consumer2<OrderProvider, UserProvider>(
        builder: (context, orderProvider, userProvider, child) {
          _totalAmount = userProvider.user?.AmountSum ?? 0.0;

          return Scaffold(
            // 渐变AppBar
            appBar: _buildAppBar(context, orderProvider),
            body: _buildBody(context, orderProvider),
            // 顶部Tab切换
            bottomNavigationBar: _buildTabBar(context),
            // 扫码按钮（仅在订单页）
            floatingActionButton: _currentIndex == 0
                ? _buildFloatingActionButton(context)
                : null,
          );
        },
      ),
    );
  }

  /// 构建渐变AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context, OrderProvider orderProvider) {
    final isOrdersPage = _currentIndex == 0;
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(
        isOrdersPage ? l10n.orders : l10n.refunds,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      // 渐变背景
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isOrdersPage
                ? [Colors.blue.shade600, Colors.purple.shade600]
                : [Colors.orange.shade600, Colors.red.shade600],
          ),
        ),
      ),
      elevation: 4,
      actions: isOrdersPage ? _buildAppBarActions(context, orderProvider) : [],
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, OrderProvider orderProvider) {
    final l10n = AppLocalizations.of(context)!;

    return [
      // 离线订单同步按钮
      if (orderProvider.offlineOrderCount > 0)
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.cloud_sync, color: Colors.white),
              Positioned(
                right: -3,
                top: -3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${orderProvider.offlineOrderCount}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          tooltip: l10n.sync_offline_orders,
          onPressed: () async {
            await orderProvider.syncOfflineOrders(context);
            if (mounted) setState(() {});
          },
        ),
      // 全选按钮
      IconButton(
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        tooltip: l10n.select_all,
        onPressed: () {
          // TODO: 全选逻辑
        },
      ),
    ];
  }

  Widget _buildBody(BuildContext context, OrderProvider orderProvider) {
    if (_currentIndex == 0) {
      return _buildOrdersPage(context, orderProvider);
    } else {
      return _buildRefundsPage(context, orderProvider);
    }
  }

  /// 订单页面 - 使用列表项样式
  Widget _buildOrdersPage(BuildContext context, OrderProvider orderProvider) {
    final orders = orderProvider.orders ?? [];

    if (orders.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.inbox_rounded,
        title: l10n: l10n.no_orders,
        subtitle: l10n.order_list_empty,
        actionText: '扫码添加',
        onAction: () => _handleScan(context),
      );
    }

    return Column(
      children: [
        // 顶部统计横幅 - 多彩渐变
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400.withOpacity(0.3),
                Colors.purple.shade400.withOpacity(0.3),
                Colors.pink.shade400.withOpacity(0.3),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.shopping_cart, '${orders.length}', '总订单', Colors.blue),
              _buildStatItem(Icons.payments_rounded, '${_totalAmount.toStringAsFixed(0)}', '余额', Colors.green),
              _buildStatItem(Icons.check_circle, '${orders.length}', '可退款', Colors.orange),
            ],
          ),
        ),
        // 订单列表 - 使用ListTile样式
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: orders.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey.shade300,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              return _buildOrderListItem(context, orders[index], index);
            },
          ),
        ),
      ],
    );
  }

  /// 退款页面
  Widget _buildRefundsPage(BuildContext context, OrderProvider orderProvider) {
    final refundProvider = Provider.of<RefundProvider>(context);
    final refunds = refundProvider.refunds ?? [];

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
        // 顶部统计横幅
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade400.withOpacity(0.3),
                Colors.red.shade400.withOpacity(0.3),
                Colors.pink.shade400.withOpacity(0.3),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.pending_rounded, '${refunds.length}', '总计', Colors.orange),
              _buildStatItem(Icons.check_circle_rounded, '0', '已完成', Colors.green),
              _buildStatItem(Icons.access_time, '0', '处理中', Colors.blue),
            ],
          ),
        ),
        // 退款列表
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: refunds.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey.shade300,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              return _buildRefundListItem(context, refunds[index]);
            },
          ),
        ),
      ],
    );
  }

  /// 统计项
  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  /// 订单列表项 - ListTile样式
  Widget _buildOrderListItem(BuildContext context, dynamic order, int index) {
    final isSelected = false; // TODO: 从状态管理获取

    return Container(
      color: isSelected ? Colors.blue.shade50 : Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.receipt_long_rounded, color: Colors.blue.shade700, size: 20),
        ),
        title: Text(
          l10n: AppLocalizations.of(context)!.order_number + (order.orderNumber ?? index.toString()),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.time?.toString() ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildMiniTag('可退款', Colors.green.shade600, Colors.green.shade50),
                const SizedBox(width: 8),
                Text(
                  '${(order.price?.toDouble() ?? 0).toStringAsFixed(0)} FCFA',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Checkbox(
          value: isSelected,
          activeColor: Colors.blue.shade600,
          onChanged: (value) {
            // TODO: 选择订单
          },
        ),
        onTap: () {
          // TODO: 显示订单详情
        },
      ),
    );
  }

  /// 退款列表项
  Widget _buildRefundListItem(BuildContext context, dynamic refund) {
    final status = refund.status ?? 'pending';
    final statusColor = status == 'completed' ? Colors.green : Colors.orange;
    final statusIcon = status == 'completed' ? Icons.check_circle : Icons.pending;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(statusIcon, color: statusColor, size: 20),
      ),
      title: Text(
        l10n: AppLocalizations.of(context)!.withdrawal_application,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.withdrawal_amount}: ${refund.amount ?? 0} FCFA',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.application_time}: ${refund.created_at ?? ''}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: statusColor.withOpacity(0.3)),
        ),
        child: Text(
          status == 'completed' ? '已完成' : '待处理',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
      ),
    );
  }

  /// 小标签
  Widget _buildMiniTag(String text, Color color, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  /// 底部Tab切换
  Widget _buildTabBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey.shade600,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt_rounded),
            activeIcon: const Icon(Icons.list_alt_rounded),
            label: l10n.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_rounded),
            activeIcon: const Icon(Icons.account_balance_wallet_rounded),
            label: l10n.refunds,
          ),
        ],
      ),
    );
  }

  /// 扫码按钮
  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'scan_fab',
      backgroundColor: Colors.blue.shade600,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.qr_code_scanner),
      label: l10n: AppLocalizations.of(context)!.scan_the_QR,
      onPressed: () => _handleScan(context),
    );
  }

  /// 空状态页面
  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade400,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.qr_code_scanner),
              label: actionText,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleScan(BuildContext context) async {
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );
  }
}
