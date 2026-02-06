import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/theme/app_theme.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/pages/scanner/scanner_page.dart';
import 'package:intl/intl.dart';

/// 订单页面 - Material Design 3风格
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late UserProvider _userProvider;
  late double _totalAmount = 0.0;
  bool _isSelectAll = false;

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
      LogUtil.e("订单页", "加载数据失败: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<OrderProvider, UserProvider, RefundProvider>(
      builder: (context, orderProvider, userProvider, refundProvider, child) {
        _totalAmount = userProvider.user?.balance ?? 0.0;

        return Scaffold(
          appBar: _buildAppBar(context, orderProvider, refundProvider),
          body: _buildOrdersPage(context, orderProvider, refundProvider),
          floatingActionButton: _buildFloatingActionButton(context),
        );
      },
    );
  }

  /// 构建AppBar
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    OrderProvider orderProvider,
    RefundProvider refundProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final selectedCount = refundProvider.orders?.length ?? 0;

    return AppBar(
      title: Text(
        l10n.orders,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      automaticallyImplyLeading: false,
      actions: [
        // 退款按钮（仅在有选中订单时显示）
        if (selectedCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Center(
              child: TextButton.icon(
                onPressed: () => _handleRefund(context, refundProvider),
                icon: const Icon(Icons.send_to_mobile, color: Colors.white),
                label: Text(
                  l10n.submit_for_approval(selectedCount),
                  style: const TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              ),
            ),
          ),
        // 全选按钮
        IconButton(
          icon: Icon(
            _isSelectAll ? Icons.check_circle : Icons.check_circle_outline,
            color: Colors.white,
          ),
          tooltip: _isSelectAll ? l10n.deselect_all : l10n.select_all,
          onPressed: () => _handleSelectAll(context, orderProvider, refundProvider),
        ),
        // 离线订单同步按钮
        if (orderProvider.offlineOrderCount > 0)
          Stack(
            clipBehavior: Clip.none,
            children: [
            IconButton(
              icon: const Icon(Icons.cloud_sync, color: Colors.white),
              tooltip: l10n.sync_offline_orders,
              onPressed: () async {
                await orderProvider.syncOfflineOrders(context);
                if (mounted) setState(() {});
              },
            ),
            if (orderProvider.offlineOrderCount > 0)
              Positioned(
                right: 3,
                top: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${orderProvider.offlineOrderCount}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// 订单页面
  Widget _buildOrdersPage(
    BuildContext context,
    OrderProvider orderProvider,
    RefundProvider refundProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final orders = orderProvider.orders ?? [];
    final selectedOrders = refundProvider.orders ?? {};

    if (orders.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.inbox_rounded,
        title: l10n.no_orders,
        subtitle: l10n.order_list_empty,
        actionText: l10n.scan_to_add,
        onAction: () => _handleScan(context),
      );
    }

    // 计算可退款的订单数量
    final refundableOrders = orders.where((order) => _isOrderRefundable(order)).length;

    return Column(
      children: [
        // 顶部统计横幅 - 合并的单卡片设计
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: AppColors.background,
          child: Column(
            children: [
              // 主统计卡片 - 带环形进度条
              _buildUnifiedStatCard(context, l10n, orders.length, refundableOrders, _totalAmount),
              const SizedBox(height: AppSpacing.md),
              // 选中订单统计
              if (selectedOrders.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientOrange,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: AppShadows.card,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.selected_orders_count(selectedOrders.length),
                            style: AppTextStyles.titleSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.estimated_refund(_calculateTotalRefund(selectedOrders).toStringAsFixed(2)),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          refundProvider.clearRefunds();
                          setState(() => _isSelectAll = false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        // 订单列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final isSelected = selectedOrders.any((o) => o.orderid == order.orderid);
              return _buildOrderCard(context, order, isSelected, refundProvider);
            },
          ),
        ),
      ],
    );
  }

  /// 计算总退款金额
  double _calculateTotalRefund(Set<dynamic> selectedOrders) {
    double total = 0.0;
    for (var order in selectedOrders) {
      total += order.refundAmount?.toDouble() ?? 0.0;
    }
    return total;
  }

  /// 统一统计卡片 - 带环形进度条展示可退款比例
  Widget _buildUnifiedStatCard(
    BuildContext context,
    AppLocalizations l10n,
    int totalOrders,
    int refundableOrders,
    double totalAmount,
  ) {
    final refundableRatio = totalOrders > 0 ? refundableOrders / totalOrders : 0.0;
    final refundablePercentage = (refundableRatio * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
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
                      value: refundableRatio,
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
                        '$refundablePercentage%',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        l10n.refundable,
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
                // 总订单数
                _buildStatItem(
                  Icons.shopping_cart_rounded,
                  l10n.total_orders,
                  '$totalOrders',
                  Colors.white,
                ),
                const SizedBox(height: AppSpacing.sm),
                // 可退款订单
                _buildStatItem(
                  Icons.check_circle_rounded,
                  l10n.refundable,
                  '$refundableOrders',
                  Colors.white,
                ),
                const SizedBox(height: AppSpacing.sm),
                // 余额
                _buildStatItem(
                  Icons.account_balance_wallet_rounded,
                  l10n.balance,
                  '${totalAmount.toStringAsFixed(0)} FCFA',
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

  /// 检查订单是否可退款（用于多选 - 仅检查是否已退款和5个月规则）
  bool _isOrderRefundable(dynamic order) {
    // 检查是否已申请退款
    if (order.isRefund == true) {
      return false;
    }

    // 检查订单时间是否满5个月
    try {
      if (order.orderTime != null) {
        final dateTime = DateTime.parse(order.orderTime.toString());
        final fiveMonthsAgo = DateTime.now().subtract(const Duration(days: 150));
        return dateTime.isBefore(fiveMonthsAgo);
      }
    } catch (e) {
      // 如果时间解析失败，默认不可退款
      return false;
    }

    return false;
  }

  /// 检查订单是否可单独退款（用于单笔退款 - 包括5000 FCFA检查）
  bool _isOrderIndividuallyRefundable(dynamic order) {
    // 首先检查基本退款条件
    if (!_isOrderRefundable(order)) {
      return false;
    }

    // 检查退款金额是否 ≥ 5000
    final refundAmount = order.refundAmount?.toDouble() ?? 0.0;
    return refundAmount >= 5000;
  }

  /// 检查订单是否需要多选才能退款（金额不足但满足其他条件）
  bool _needsMultiSelect(dynamic order) {
    return _isOrderRefundable(order) && !_isOrderIndividuallyRefundable(order);
  }

  /// 获取订单不可退款的原因
  String _getNonRefundableReason(dynamic order) {
    final l10n = AppLocalizations.of(context)!;
    // 检查是否已申请退款
    if (order.isRefund == true) {
      return l10n.already_refunded;
    }

    // 检查订单时间
    try {
      if (order.orderTime != null) {
        final dateTime = DateTime.parse(order.orderTime.toString());
        final fiveMonthsAgo = DateTime.now().subtract(const Duration(days: 150));
        if (dateTime.isAfter(fiveMonthsAgo)) {
          final daysLeft = fiveMonthsAgo.difference(dateTime).inDays.abs();
          return l10n.wait_months((daysLeft / 30).ceil());
        }
      }
    } catch (e) {
      return l10n.not_refundable;
    }

    // 如果满足5个月规则但金额不足
    if (_needsMultiSelect(order)) {
      return l10n.insufficient_amount_need_more;
    }

    return l10n.not_refundable;
  }

  /// 订单卡片 - 优化版本
  Widget _buildOrderCard(
    BuildContext context,
    dynamic order,
    bool isSelected,
    RefundProvider refundProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final orderNumber = order.orderNumber ?? 'N/A';
    final price = (order.price?.toDouble() ?? 0.0).toStringAsFixed(2);
    final refundAmount = (order.refundAmount?.toDouble() ?? 0.0).toStringAsFixed(2);
    final refundPercent = order.refundpercent?.toDouble() ?? 0.0;

    // 检查订单退款状态
    final isRefundable = _isOrderRefundable(order);
    final isIndividuallyRefundable = _isOrderIndividuallyRefundable(order);
    final needsMultiSelect = _needsMultiSelect(order);
    final nonRefundableReason = _getNonRefundableReason(order);

    // 确定状态显示
    String statusText;
    Color statusColor;
    Color statusBgColor;
    IconData statusIcon;

    if (isIndividuallyRefundable) {
      statusText = l10n.refundable_status;
      statusColor = AppColors.success;
      statusBgColor = AppColors.successLight;
      statusIcon = Icons.check_circle;
    } else if (needsMultiSelect) {
      statusText = l10n.needs_multi_select;
      statusColor = AppColors.warning;
      statusBgColor = AppColors.warningLight;
      statusIcon = Icons.warning;
    } else {
      statusText = nonRefundableReason;
      statusColor = AppColors.error;
      statusBgColor = AppColors.errorLight;
      statusIcon = Icons.cancel;
    }

    // 格式化时间
    String formattedTime = 'N/A';
    try {
      if (order.orderTime != null) {
        final dateTime = DateTime.parse(order.orderTime.toString());
        formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
      }
    } catch (e) {
      formattedTime = order.orderTime?.toString() ?? 'N/A';
    }

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: isSelected
            ? BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showOrderDetail(context, order),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 第一列：复选框 + 订单图标
              Column(
                children: [
                  // 选择复选框 - 不可退款的订单禁用
                  InkWell(
                    onTap: () {
                      if (isRefundable) {
                        _toggleOrderSelection(order, refundProvider);
                      }
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Checkbox(
                        value: isSelected,
                        visualDensity: VisualDensity.compact,
                        activeColor: AppColors.primary,
                        onChanged: isRefundable ? (value) {
                          _toggleOrderSelection(order, refundProvider);
                        } : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // 订单图标
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientBlue,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              // 第二列：订单信息（多行布局）
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 第一行：订单号
                    Text(
                      l10n.order_number_with_hash(orderNumber),
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // 第二行：可退款金额
                    Row(
                      children: [
                        Text(
                          l10n.refund_amount_with_currency(refundAmount),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: needsMultiSelect
                                ? AppColors.warning
                                : AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '($refundPercent%)',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // 第三行：状态图标 + 原因
                    Row(
                      children: [
                        // 状态图标
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            statusIcon,
                            size: 16,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        // 状态文本
                        Expanded(
                          child: Text(
                            statusText,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // 快速退款按钮 - 仅对可单独退款的订单显示
                        if (isIndividuallyRefundable)
                          InkWell(
                            onTap: () => _handleQuickRefund(context, order, refundProvider),
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.send_to_mobile,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '退款',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // 第四行：退款时间
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            formattedTime,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textHint,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          l10n.order_amount_with_currency(price),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textHint,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 小标签
  Widget _buildMiniTag(String text, Color color, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  /// 切换订单选择状态
  void _toggleOrderSelection(dynamic order, RefundProvider refundProvider) {
    final isSelected = refundProvider.orders?.any((o) => o.orderid == order.orderid) ?? false;

    if (isSelected) {
      refundProvider.removeOrder(order.orderid);
    } else {
      refundProvider.addOrder(order);
    }

    // 检查是否全部选中
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final orders = orderProvider.orders ?? [];
    final selectedCount = refundProvider.orders?.length ?? 0;
    setState(() {
      _isSelectAll = selectedCount == orders.length && orders.isNotEmpty;
    });
  }

  /// 全选/取消全选
  void _handleSelectAll(
    BuildContext context,
    OrderProvider orderProvider,
    RefundProvider refundProvider,
  ) {
    final orders = orderProvider.orders ?? [];

    if (_isSelectAll) {
      // 取消全选
      refundProvider.clearRefunds();
      setState(() => _isSelectAll = false);
    } else {
      // 全选
      refundProvider.clearRefunds();
      for (var order in orders) {
        refundProvider.addOrder(order);
      }
      setState(() => _isSelectAll = true);
    }
  }

  /// 显示订单详情
  void _showOrderDetail(BuildContext context, dynamic order) {
    final l10n = AppLocalizations.of(context)!;
    final orderNumber = order.orderNumber ?? 'N/A';
    final price = (order.price?.toDouble() ?? 0.0).toStringAsFixed(2);
    final refundAmount = (order.refundAmount?.toDouble() ?? 0.0).toStringAsFixed(2);
    final refundPercent = order.refundpercent?.toDouble() ?? 0.0;
    final productId = order.ProductId ?? 'N/A';

    // 检查订单退款状态
    final isRefundable = _isOrderRefundable(order);
    final isIndividuallyRefundable = _isOrderIndividuallyRefundable(order);
    final needsMultiSelect = _needsMultiSelect(order);
    final nonRefundableReason = _getNonRefundableReason(order);

    // 确定状态显示
    String statusText;
    Color statusColor;

    if (isIndividuallyRefundable) {
      statusText = l10n.refundable_status;
      statusColor = AppColors.success;
    } else if (needsMultiSelect) {
      final refundStr = l10n.refund_amount_with_currency('0');
      statusText = '${l10n.needs_multi_select} ${refundStr.replaceAll('{amount}', '').replaceAll('FCFA', '').trim()}';
      statusColor = AppColors.warning;
    } else {
      statusText = nonRefundableReason;
      statusColor = AppColors.error;
    }

    // 格式化时间
    String formattedTime = 'N/A';
    try {
      if (order.orderTime != null) {
        final dateTime = DateTime.parse(order.orderTime.toString());
        formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
      }
    } catch (e) {
      formattedTime = order.orderTime?.toString() ?? 'N/A';
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.gradientBlue,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(Icons.receipt_long, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  l10n.order_details,
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
                _buildDetailRow(l10n.order_number, orderNumber),
                const Divider(),
                _buildDetailRow(l10n.product_id, productId),
                const Divider(),
                _buildDetailRow(l10n.total_amount, '$price FCFA', highlight: true),
                const Divider(),
                _buildDetailRow(l10n.refund_amount, '$refundAmount FCFA', highlight: true, color: AppColors.success),
                const Divider(),
                _buildDetailRow('$refundPercent%', '$refundPercent%'),
                const Divider(),
                _buildDetailRow(l10n.creation_time, formattedTime),
                const Divider(),
                _buildDetailRow(
                  l10n.order_status_label,
                  statusText,
                  status: true,
                  statusColor: statusColor,
                ),
                // 如果需要多选，显示提示信息
                if (needsMultiSelect) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.insufficient_refund_amount_error,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: isIndividuallyRefundable ? () async {
                // 关闭详情对话框
                Navigator.pop(dialogContext);

                // 等待对话框关闭完成
                await Future.delayed(const Duration(milliseconds: 100));

                // 检查widget是否仍然mounted
                if (!mounted) return;

                // 直接提交单个订单 - 使用页面级别的context而不是对话框的context
                _handleSingleOrderRefund(context, order);
              } : null, // 不可单独退款时设置为null，按钮将自动变为禁用状态
              icon: Icon(
                Icons.send_to_mobile,
                color: isIndividuallyRefundable ? AppColors.primary : AppColors.textHint,
              ),
              label: Text(
                l10n.direct_submit_approval,
                style: TextStyle(
                  color: isIndividuallyRefundable ? AppColors.primary : AppColors.textHint,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  /// 处理单个订单退款
  Future<void> _handleSingleOrderRefund(BuildContext context, dynamic order) async {
    final refundProvider = Provider.of<RefundProvider>(context, listen: false);

    // 清空之前选择的订单
    refundProvider.clearRefunds();

    // 添加当前订单
    refundProvider.addOrder(order);

    // 直接调用_handleRefund，它会显示对话框并提交
    await _handleRefund(context, refundProvider);
  }

  /// 快速退款 - 直接从卡片按钮触发
  Future<void> _handleQuickRefund(BuildContext context, dynamic order, RefundProvider refundProvider) async {
    // 清空之前选择的订单
    refundProvider.clearRefunds();

    // 添加当前订单
    refundProvider.addOrder(order);

    // 直接调用_handleRefund，它会显示对话框并提交
    await _handleRefund(context, refundProvider);
  }

  /// 详情行
  Widget _buildDetailRow(
    String label,
    String value, {
    bool highlight = false,
    Color? color,
    bool status = false,
    Color? statusColor,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
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
              child: Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: finalStatusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

  /// 处理退款
  Future<void> _handleRefund(
    BuildContext context,
    RefundProvider refundProvider,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final selectedOrders = refundProvider.orders ?? {};
    if (selectedOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.please_select_orders_first)),
      );
      return;
    }

    // 计算累积退款金额
    final totalRefund = _calculateTotalRefund(selectedOrders);

    // 检查累积金额是否满足要求
    if (totalRefund < 5000) {
      // 检查是否所有订单都满足基本条件（未退款、满5个月）
      bool allMeetBasicConditions = true;
      for (var order in selectedOrders) {
        if (!_isOrderRefundable(order)) {
          allMeetBasicConditions = false;
          break;
        }
      }

      if (allMeetBasicConditions) {
        // 如果所有订单都满足基本条件，但累积金额不足
        final remainingAmount = (5000 - totalRefund).toStringAsFixed(2);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cumulative_amount_insufficient(remainingAmount)),
            backgroundColor: AppColors.warning,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: l10n.got_it,
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        // 如果有订单不满足基本条件
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.contains_non_refundable_orders),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    // 显示退款选项对话框
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _RefundMethodDialog(
        totalAmount: totalRefund,
        orderCount: selectedOrders.length,
      ),
    );

    if (result != null && result['method'] != null && result['method'] > 0) {
      final refundMethod = result['method'] as int;
      final refundAccount = result['account'] as String? ?? '';

      // 提交退款
      final l10n = AppLocalizations.of(context)!;

      // 显示加载对话框
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(l10n.submitting_refund_application),
            ],
          ),
        ),
      );

      final response = await refundProvider.Refund(context, refundMethod, refundAccount);

      // 关闭加载对话框
      if (mounted) Navigator.pop(context);

      // 显示结果
      if (mounted) {
        String message;
        Color backgroundColor;

        switch (response) {
          case 1:
            message = l10n.refund_application_submitted;
            backgroundColor = AppColors.success;
            refundProvider.clearRefunds();
            setState(() => _isSelectAll = false);
            break;
          case -1:
            message = l10n.network_error_check_connection;
            backgroundColor = Colors.orange;
            break;
          case 201:
            message = l10n.order_needs_5_months;
            backgroundColor = Colors.orange;
            break;
          case 202:
            message = l10n.refund_amount_less_than_5000;
            backgroundColor = Colors.orange;
            break;
          case 10086:
            message = l10n.please_select_orders_first;
            backgroundColor = Colors.red;
            break;
          default:
            message = l10n.refund_failed_with_code('$response');
            backgroundColor = Colors.red;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 扫码按钮
  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton.extended(
      heroTag: 'scan_fab',
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.qr_code_scanner),
      label: Text(l10n.scan_the_QR),
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
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(actionText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
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

/// 退款方式选择对话框
class _RefundMethodDialog extends StatefulWidget {
  final double totalAmount;
  final int orderCount;

  const _RefundMethodDialog({
    required this.totalAmount,
    required this.orderCount,
  });

  @override
  State<_RefundMethodDialog> createState() => _RefundMethodDialogState();
}

class _RefundMethodDialogState extends State<_RefundMethodDialog> {
  int _selectedMethod = 1;
  final _accountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.select_refund_method),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.order_count_label(widget.orderCount),
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.total_refund_amount_label(widget.totalAmount.toStringAsFixed(2)),
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.refund_method_label, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          RadioListTile<int>(
            title: Text(l10n.orange_money),
            value: 1,
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() => _selectedMethod = value!);
            },
            activeColor: AppColors.primary,
          ),
          RadioListTile<int>(
            title: Text(l10n.wave),
            value: 2,
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() => _selectedMethod = value!);
            },
            activeColor: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _accountController,
            decoration: InputDecoration(
              labelText: l10n.refund_account_optional,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_balance_wallet),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'method': _selectedMethod,
              'account': _accountController.text.trim(),
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(l10n.submit),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }
}
