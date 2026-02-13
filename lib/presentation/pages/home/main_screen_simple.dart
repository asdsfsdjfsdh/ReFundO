import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/pages/orders/orders_page.dart';
import 'package:refundo/presentation/pages/refunds/refunds_page.dart';
import 'package:refundo/presentation/pages/profile/profile_page.dart';
import 'package:refundo/presentation/pages/initialization_model.dart';
import 'package:refundo/presentation/pages/statistics/statistics_page.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/core/services/update_service.dart';

/// 简化的主屏幕 - 4个Tab（订单、退款、统计、我的）
class MainScreenSimple extends StatefulWidget {
  const MainScreenSimple({super.key});

  @override
  State<MainScreenSimple> createState() => _MainScreenSimpleState();
}

class _MainScreenSimpleState extends State<MainScreenSimple> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _LoadingPage(),
      const _LoadingPage(),
      const _LoadingPage(),
      const _LoadingPage(),
    ];

    // 等待初始化完成后加载真实页面
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initModel = Provider.of<InitializationModel>(context, listen: false);
      if (initModel.isInitial) {
        setState(() {
          _isInitialized = true;
          _pages = [
            const OrdersPage(),
            const RefundsPage(),
            const StatisticsPage(),
            const ProfilePage(),
          ];
        });

        // 初始化更新服务并自动检查更新
        UpdateService().initXUpdate();
        UpdateService().autoCheckUpdate(context);
      }
    });
  }

  /// 页面切换时的回调
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // 切换到订单页面时刷新
    if (index == 0) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.getOrders(context);
    }

    // 切换到退款页面时刷新
    if (index == 1) {
      final refundProvider = Provider.of<RefundProvider>(context, listen: false);
      refundProvider.getRefunds(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey.shade500,
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
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_rounded),
            activeIcon: const Icon(Icons.bar_chart_rounded),
            label: l10n.statistics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            activeIcon: const Icon(Icons.person_rounded),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}

/// 加载页面占位符
class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
