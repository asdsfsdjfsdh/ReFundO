import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart';

/// 空状态页面组件
/// 用于列表为空或无数据时的友好提示
class EmptyStatePage extends StatelessWidget {
  final String message;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const EmptyStatePage({
    Key? key,
    required this.message,
    this.description = '',
    this.icon = Icons.inbox_rounded,
    this.actionLabel,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onActionPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel ?? l10n!.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 订单空状态页面
class EmptyOrdersPage extends StatelessWidget {
  const EmptyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return EmptyStatePage(
      message: l10n!.no_orders_yet,
      description: l10n!.scan_products_to_add_orders,
      icon: Icons.shopping_cart_outlined,
      actionLabel: l10n!.scan_now,
      onActionPressed: () {
        // 扫描功能在订单页面中，切换到订单Tab即可使用
        // Navigator.popUntil(context, (route) => route.isFirst);
      },
    );
  }
}

/// 退款空状态页面
class EmptyRefundsPage extends StatelessWidget {
  const EmptyRefundsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return EmptyStatePage(
      message: l10n!.no_refunds_yet,
      description: l10n!.submit_refund_requests_here,
      icon: Icons.request_quote_rounded,
    );
  }
}
