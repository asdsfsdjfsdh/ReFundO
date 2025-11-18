import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/l10n/app_localizations.dart';

class RefundConfirmationDialog extends StatefulWidget {
  final Decimal totalAmount;
  final int selectedCount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const RefundConfirmationDialog({
    super.key,
    required this.totalAmount,
    required this.selectedCount,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<RefundConfirmationDialog> createState() => _RefundConfirmationDialogState();
}

class _RefundConfirmationDialogState extends State<RefundConfirmationDialog> {
  PaymentMethod _selectedMethod = PaymentMethod.phone;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 半透明背景点击区域
          Expanded(
            child: GestureDetector(
              onTap: widget.onCancel,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // 确认对话框内容
          _buildDialogContent(context, l10n!),
        ],
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          _buildHeader(context, l10n),
          // 支付方式选择
          _buildPaymentMethodSection(context, l10n),
          // 输入表单
          _buildInputForm(context, l10n),
          // 按钮区域
          _buildActionButtons(context, l10n),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.payment, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.refund_confirmation,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  l10n.total_amount_orders( widget.selectedCount,widget.totalAmount.toStringAsFixed(2)),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: widget.onCancel,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.select_payment_method,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPaymentOption(
                method: PaymentMethod.phone,
                label: l10n.phone_payment,
                icon: Icons.phone_iphone,
              ),
              _buildPaymentOption(
                method: PaymentMethod.sankeMoney,
                label: l10n.sanke_money,
                icon: Icons.account_balance_wallet,
              ),
              _buildPaymentOption(
                method: PaymentMethod.wave,
                label: l10n.wave_payment,
                icon: Icons.account_balance,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == method;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextFormField(
            controller: _accountController,
            decoration: InputDecoration(
              labelText: _getAccountHint(l10n),
              prefixIcon: Icon(_getMethodIcon()),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: _getValidator(l10n),
          ),
          if (_selectedMethod == PaymentMethod.phone) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: l10n.confirm_phone_number,
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ],
      ),
    );
  }

  String _getAccountHint(AppLocalizations l10n) {
    switch (_selectedMethod) {
      case PaymentMethod.phone:
        return l10n.enter_phone_number;
      case PaymentMethod.sankeMoney:
        return l10n.enter_sanke_account;
      case PaymentMethod.wave:
        return l10n.enter_wave_account;
    }
  }

  IconData _getMethodIcon() {
    switch (_selectedMethod) {
      case PaymentMethod.phone:
        return Icons.phone_iphone;
      case PaymentMethod.sankeMoney:
        return Icons.account_balance_wallet;
      case PaymentMethod.wave:
        return Icons.account_balance;
    }
  }

  String? Function(String?)? _getValidator(AppLocalizations l10n) {
    switch (_selectedMethod) {
      case PaymentMethod.phone:
        return (value) {
          if (value == null || value.isEmpty) return l10n.enter_phone_number;
          if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) return l10n.invalid_phone_format;
          return null;
        };
      case PaymentMethod.sankeMoney:
        return (value) {
          if (value == null || value.isEmpty) return l10n.enter_sanke_account;
          if (value.length < 6) return l10n.account_length_at_least_6;
          return null;
        };
      case PaymentMethod.wave:
        return (value) {
          if (value == null || value.isEmpty) return l10n.enter_wave_account;
          if (!value.startsWith('WAVE')) return l10n.wave_account_start_with_wave;
          return null;
        };
    }
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n.cancel),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _validateInputs(l10n) ? _handleConfirmation : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.confirm_refund,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateInputs(AppLocalizations l10n) {
    final validator = _getValidator(l10n);
    return validator?.call(_accountController.text) == null;
  }

  void _handleConfirmation() {
    // 关闭对话框
    Navigator.of(context).pop();
    // 执行确认回调
    widget.onConfirm();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

// 支付方式枚举
enum PaymentMethod {
  phone,
  sankeMoney,
  wave,
}