import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/home/provider/refund_provider.dart';
import 'package:refundo/l10n/app_localizations.dart'; // 添加多语言支持
import 'package:refundo/models/order_model.dart';

class OrderWidget extends StatefulWidget {
  final List<OrderModel> models;
  final bool isrefunding;

  const OrderWidget({
    super.key,
    required this.models,
    required this.isrefunding,
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final Map<int, bool> _selectionState = {};
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeSelectionState();
  }

  @override
  void didUpdateWidget(covariant OrderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isrefunding != widget.isrefunding) {
      _handleRefundingModeChange();
    }

    if (oldWidget.models != widget.models) {
      _updateSelectionState();
    }
  }

  void _initializeSelectionState() {
    for (final order in widget.models) {
      _selectionState[order.orderid] = false;
    }
  }

  void _updateSelectionState() {
    final newState = <int, bool>{};
    for (final order in widget.models) {
      newState[order.orderid] = _selectionState[order.orderid] ?? false;
    }
    setState(() {
      _selectionState.clear();
      _selectionState.addAll(newState);
    });
  }

  void _handleRefundingModeChange() {
    final refundProvider = Provider.of<RefundProvider>(context, listen: false);

    setState(() {
      _selectionState.updateAll((key, value) => false);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final order in widget.models) {
        refundProvider.removeOrder(order.orderid);
      }
    });
  }

  bool get _isAllSelected {
    if (widget.models.isEmpty) return false;
    return _selectionState.values.every((selected) => selected);
  }

  void _toggleSelectAll() {
    final refundProvider = Provider.of<RefundProvider>(context, listen: false);
    final shouldSelectAll = !_isAllSelected;

    setState(() {
      _selectionState.updateAll((key, value) => shouldSelectAll);
    });

    if (shouldSelectAll) {
      for (final order in widget.models) {
        refundProvider.addOrder(order);
      }
    } else {
      for (final order in widget.models) {
        refundProvider.removeOrder(order.orderid);
      }
    }
  }

  void _toggleOrderSelection(OrderModel order) {
    final refundProvider = Provider.of<RefundProvider>(context, listen: false);
    final isCurrentlySelected = _selectionState[order.orderid] ?? false;

    setState(() {
      _selectionState[order.orderid] = !isCurrentlySelected;
    });

    if (!isCurrentlySelected) {
      refundProvider.addOrder(order);
    } else {
      refundProvider.removeOrder(order.orderid);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 全选操作栏
        if (widget.isrefunding) _buildSelectionHeader(context),

        // 订单列表
        Expanded(
          child: _buildOrderList(context),
        ),
      ],
    );
  }

  // 构建选择头部 - 添加多语言支持
  Widget _buildSelectionHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 全选按钮
          _buildSelectAllButton(context),
          const SizedBox(width: 12),

          // 选择统计
          _buildSelectionStats(context),
          const Spacer(),

          // 操作提示
          Text(
            l10n!.select_orders_to_refund,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: _toggleSelectAll,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isAllSelected ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isAllSelected ? Colors.green.shade300 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isAllSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              color: _isAllSelected ? Colors.green.shade600 : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              l10n!.select_all,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isAllSelected ? Colors.green.shade800 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionStats(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedCount = _selectionState.values.where((selected) => selected).length;

    return Text(
      l10n!.selected_count(selectedCount, widget.models.length),
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
    );
  }

  // 构建订单列表 - 添加多语言支持
  Widget _buildOrderList(BuildContext context) {
    if (widget.models.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.models.length,
      itemBuilder: (context, index) {
        final order = widget.models[index];
        return _OrderListItem(
          order: order,
          isRefundingMode: widget.isrefunding,
          isSelected: _selectionState[order.orderid] ?? false,
          onSelectionChanged: () => _toggleOrderSelection(order),
        );
      },
    );
  }

  // 构建空状态 - 添加多语言支持
  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            l10n!.no_orders,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.order_list_empty,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// 单个订单列表项组件 - 添加多语言支持
class _OrderListItem extends StatelessWidget {
  final OrderModel order;
  final bool isRefundingMode;
  final bool isSelected;
  final VoidCallback onSelectionChanged;

  const _OrderListItem({
    required this.order,
    required this.isRefundingMode,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 选择按钮区域
          if (isRefundingMode) ...[
            _buildSelectionIndicator(),
            const SizedBox(width: 12),
          ],
          // 订单信息卡片
          Expanded(
            child: _buildOrderCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    return GestureDetector(
      onTap: onSelectionChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade500 : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.green.shade500 : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: isSelected
            ? Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 16,
        )
            : null,
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isRefundingMode ? onSelectionChanged : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 订单图标
                _buildOrderIcon(),
                const SizedBox(width: 16),
                // 订单信息
                Expanded(
                  child: _buildOrderInfo(context),
                ),
                // 金额信息
                _buildAmountInfo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade100,
            Colors.blue.shade200,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.receipt_rounded,
        color: Colors.blue.shade700,
        size: 24,
      ),
    );
  }

  // 构建订单信息 - 添加多语言支持
  Widget _buildOrderInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n!.order_number}: ${order.orderid}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${l10n.time}: ${order.OrderTime}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // 构建金额信息 - 添加多语言支持
  Widget _buildAmountInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '¥${order.refundAmount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          l10n!.refundable,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}