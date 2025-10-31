import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart'; // 添加多语言支持
import 'package:refundo/models/order_model.dart';

class RefundWidget extends StatelessWidget {
  final List<OrderModel> models;

  const RefundWidget( {
    super.key,
    required this.models,
  });

  @override
  Widget build(BuildContext context) {
    if (models.isEmpty) {
      return _buildEmptyState(context); // 添加context参数
    }

    return ListView.builder(
      itemCount: models.length,
      cacheExtent: 300.0,
      itemBuilder: (context, index) {
        final order = models[index];
        return _RefundListItem(order: order);
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
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            l10n!.no_withdrawal_records,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.withdrawal_records_will_appear_here,
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

class _RefundListItem extends StatelessWidget {
  final OrderModel order;

  const _RefundListItem({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showRefundDetails(context, order);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 状态图标
                _buildStatusIcon(order),
                const SizedBox(width: 16),

                // 主要信息
                Expanded(
                  child: _buildMainInfo(context, order), // 添加context参数
                ),

                // 金额和操作
                _buildAmountAndActions(context, order), // 添加context参数
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(OrderModel order) {
    final IconData icon;
    final Color color;

    // 根据退款状态显示不同图标
    switch (order.refundState) {
      case true:
        icon = Icons.check_circle_outline_rounded;
        color = Colors.green.shade600;
        break;
      case false:
        icon = Icons.error_outline_rounded;
        color = Colors.red.shade600;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  // 构建主要信息 - 添加多语言支持
  Widget _buildMainInfo(BuildContext context, OrderModel order) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主要标题
        Text(
          l10n!.withdrawal_application,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),

        // 时间信息
        Text(
          '${l10n.time}: ${order.refundTime}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),

        // 状态标签
        _buildStatusBadge(context, order.refundState), // 添加context参数
      ],
    );
  }

  // 构建状态徽章 - 添加多语言支持
  Widget _buildStatusBadge(BuildContext context, bool status) {
    final l10n = AppLocalizations.of(context);
    final Color backgroundColor;
    final Color textColor;
    final String displayText;

    switch (status) {
      case true:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        displayText = l10n!.completed;
        break;
      case false:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        displayText = l10n!.pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  // 构建金额和操作 - 添加多语言支持
  Widget _buildAmountAndActions(BuildContext context, OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 金额显示
        Text(
          '¥${order.refundAmount?.toStringAsFixed(2) ?? '0.00'}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _getAmountColor(order.refundState),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Color _getAmountColor(bool status) {
    switch (status) {
      case true:
        return Colors.green.shade700;
      case false:
        return Colors.red.shade700;
    }
  }

  void _showRefundDetails(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RefundDetailSheet(order: order),
    );
  }

  void _handleRetryRefund(OrderModel order) {
    // 实现重试逻辑
  }
}

// 提现详情底部表单 - 添加多语言支持
class _RefundDetailSheet extends StatelessWidget {
  final OrderModel order;

  const _RefundDetailSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              children: [
                Text(
                  l10n!.withdrawal_details,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 详情信息
            _buildDetailItem(context, l10n.order_number, order.orderid.toString()),
            _buildDetailItem(context, l10n.withdrawal_amount, '¥${order.refundAmount?.toStringAsFixed(2)}'),
            _buildDetailItem(context, l10n.application_time, order.OrderTime),
            _buildDetailItem(context, l10n.processing_status, order.refundState ? l10n.completed : l10n.pending),
            _buildDetailItem(context, l10n.payment_method, l10n.bank_card),

            const SizedBox(height: 30),
            // 操作按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建详情项 - 添加多语言支持
  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}