import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart'; // 添加多语言支持
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';
import 'package:refundo/models/refund_transaction_model.dart';
import 'package:refundo/data/services/api_refund_service.dart';

class RefundWidget extends StatelessWidget {
  final List<RefundModel> refunds;

  const RefundWidget( {
    super.key,
    required this.refunds,
  });

  @override
  Widget build(BuildContext context) {
    if (refunds.isEmpty) {
      return _buildEmptyState(context); // 添加context参数
    }

    return ListView.builder(
      itemCount: refunds.length,
      cacheExtent: 300.0,
      itemBuilder: (context, index) {
        final refund = refunds[index];
        return _RefundListItem(refunds: refund);
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
  final RefundModel refunds;

  const _RefundListItem({
    required this.refunds,
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
            _showRefundDetails(context, refunds);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 状态图标
                _buildStatusIcon(refunds),
                const SizedBox(width: 16),

                // 主要信息
                Expanded(
                  child: _buildMainInfo(context, refunds), // 添加context参数
                ),

                // 金额和操作
                _buildAmountAndActions(context, refunds), // 添加context参数
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(RefundModel refund) {
    final IconData icon;
    final Color color;

    // 根据退款状态显示不同图标
    // 0-待处理 1-已批准 2-已拒绝 3-处理中 4-已完成 5-失败
    switch (refund.requestStatus) {
      case 0: // 待处理
        icon = Icons.pending_outlined;
        color = Colors.orange.shade600;
        break;
      case 1: // 已批准
        icon = Icons.approval_outlined;
        color = Colors.green.shade600;
        break;
      case 2: // 已拒绝
        icon = Icons.cancel_outlined;
        color = Colors.red.shade600;
        break;
      case 3: // 处理中
        icon = Icons.sync_outlined;
        color = Colors.blue.shade600;
        break;
      case 4: // 已完成
        icon = Icons.check_circle_outline_rounded;
        color = Colors.green.shade700;
        break;
      case 5: // 失败
        icon = Icons.error_outline_rounded;
        color = Colors.red.shade700;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey.shade600;
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
  Widget _buildMainInfo(BuildContext context, RefundModel refund) {
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
          '${l10n.time}: ${refund.createTime}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),

        // 状态标签
        _buildStatusBadge(context, refund.requestStatus), // 传递requestStatus
      ],
    );
  }

  // 构建状态徽章 - 添加多语言支持
  Widget _buildStatusBadge(BuildContext context, int status) {
    final l10n = AppLocalizations.of(context);
    final Color backgroundColor;
    final Color textColor;
    final String displayText;

    // 0-待处理 1-已批准 2-已拒绝 3-处理中 4-已完成 5-失败
    switch (status) {
      case 0:
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        displayText = l10n!.status_pending;
        break;
      case 1:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        displayText = l10n!.status_approved;
        break;
      case 2:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        displayText = l10n!.status_rejected;
        break;
      case 3:
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue.shade800;
        displayText = l10n!.status_processing;
        break;
      case 4:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        displayText = l10n!.status_completed;
        break;
      case 5:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        displayText = l10n!.status_failed;
        break;
      default:
        backgroundColor = Colors.grey.shade50;
        textColor = Colors.grey.shade800;
        displayText = l10n!.status_unknown;
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
  Widget _buildAmountAndActions(BuildContext context, RefundModel refund) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 金额显示
        Text(
          '${refund.amount.toStringAsFixed(2)} FCFA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _getAmountColor(refund.requestStatus),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Color _getAmountColor(int status) {
    // 0-待处理 1-已批准 2-已拒绝 3-处理中 4-已完成 5-失败
    switch (status) {
      case 0: // 待处理 - 橙色
        return Colors.orange.shade700;
      case 1: // 已批准 - 绿色
        return Colors.green.shade700;
      case 2: // 已拒绝 - 红色
        return Colors.red.shade700;
      case 3: // 处理中 - 蓝色
        return Colors.blue.shade700;
      case 4: // 已完成 - 绿色
        return Colors.green.shade700;
      case 5: // 失败 - 红色
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  void _showRefundDetails(BuildContext context, RefundModel refund) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RefundDetailSheet(refund: refund),
    );
  }

  void _handleRetryRefund(OrderModel order) {
    // 实现重试逻辑
  }
}

// 提现详情底部表单 - 改为 StatefulWidget 以支持异步加载交易数据
class _RefundDetailSheet extends StatefulWidget {
  final RefundModel refund;

  const _RefundDetailSheet({required this.refund});

  @override
  State<_RefundDetailSheet> createState() => _RefundDetailSheetState();
}

class _RefundDetailSheetState extends State<_RefundDetailSheet> {
  RefundTransactionModel? _transaction;
  bool _isLoading = true;
  final ApiRefundService _apiService = ApiRefundService();

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    final result = await _apiService.getRefundTransaction(
      context,
      widget.refund.requestId,
    );

    if (mounted) {
      setState(() {
        if (result['success'] && result['data'] != null) {
          _transaction = RefundTransactionModel.fromJson(result['data']);
        }
        _isLoading = false;
      });
    }
  }

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
      child: SingleChildScrollView(
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

              // 退款请求详情信息 - 使用后端返回的数据
              _buildSectionTitle(context, l10n.order_number),
              _buildDetailItem(context, l10n.withdrawal_amount, '¥${_transaction?.amount.toStringAsFixed(2) ?? widget.refund.amount.toStringAsFixed(2)}'),
              _buildDetailItem(context, l10n.application_time, widget.refund.createTime.toString()),
              _buildDetailItem(context, l10n.processing_status, _getStatusText(context, widget.refund.requestStatus)),
              _buildDetailItem(context, l10n.payment_method, _getPaymentMethodText(context, _transaction?.paymentMethod ?? widget.refund.paymentMethod, _transaction?.paymentNumber ?? widget.refund.paymentNumber)),

              const SizedBox(height: 20),

              // 交易记录部分
              _buildSectionTitle(context, l10n.transaction_details),
              const SizedBox(height: 10),
              _buildTransactionSection(context, l10n),

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
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildTransactionSection(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_transaction == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            l10n.no_transaction_records,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 交易状态图标和编号
            Row(
              children: [
                _buildTransactionStatusIcon(_transaction!.transStatus),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _transaction!.refundNumber.isNotEmpty
                        ? _transaction!.refundNumber
                        : 'N/A',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            // 交易详情
            _buildTransactionDetailRow(context, l10n.time, _transaction!.createTime),
            _buildTransactionDetailRow(context, l10n.processing_status, _getTransactionStatusText(context, _transaction!.transStatus)),
            if (_transaction!.remittanceReceipt.isNotEmpty)
              _buildTransactionDetailRow(context, l10n.voucherUrl, _transaction!.remittanceReceipt),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionStatusIcon(int status) {
    IconData icon;
    Color color;

    // 0-待处理 1-成功 2-失败 3-处理中
    switch (status) {
      case 0:
        icon = Icons.pending_outlined;
        color = Colors.orange.shade600;
        break;
      case 1:
        icon = Icons.check_circle_outline_rounded;
        color = Colors.green.shade600;
        break;
      case 2:
        icon = Icons.cancel_outlined;
        color = Colors.red.shade600;
        break;
      case 3:
        icon = Icons.sync_outlined;
        color = Colors.blue.shade600;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey.shade600;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildTransactionDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建详情项
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

  // 获取退款状态文本
  String _getStatusText(BuildContext context, int status) {
    final l10n = AppLocalizations.of(context);
    // 0-待处理 1-已批准 2-已拒绝 3-处理中 4-已完成 5-失败
    switch (status) {
      case 0:
        return l10n!.status_pending;
      case 1:
        return l10n!.status_approved;
      case 2:
        return l10n!.status_rejected;
      case 3:
        return l10n!.status_processing;
      case 4:
        return l10n!.status_completed;
      case 5:
        return l10n!.status_failed;
      default:
        return l10n!.status_unknown;
    }
  }

  // 获取交易状态文本
  String _getTransactionStatusText(BuildContext context, int status) {
    final l10n = AppLocalizations.of(context);
    // 0-待处理 1-成功 2-失败 3-处理中
    switch (status) {
      case 0:
        return l10n!.transaction_pending;
      case 1:
        return l10n!.transaction_success;
      case 2:
        return l10n!.transaction_failed;
      case 3:
        return l10n!.transaction_processing;
      default:
        return l10n!.status_unknown;
    }
  }

  // 获取支付方式文本
  String _getPaymentMethodText(BuildContext context, int paymentMethod, String paymentNumber) {
    final l10n = AppLocalizations.of(context);
    String methodText;
    switch (paymentMethod) {
      case 1:
        methodText = l10n!.phone_payment;
        break;
      case 2:
        methodText = l10n!.sanke_money;
        break;
      case 3:
        methodText = l10n!.wave_payment;
        break;
      default:
        methodText = '-';
    }
    return '$methodText ($paymentNumber)';
  }
}