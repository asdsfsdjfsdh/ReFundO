import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/pages/home/home_page.dart';
import 'package:refundo/presentation/pages/scanner/scanner_page.dart';
import 'package:refundo/presentation/pages/profile/profile_page.dart';
import 'package:refundo/presentation/pages/statistics/statistics_page_v2.dart';
import 'package:refundo/presentation/pages/initialization_model.dart';

/// 新的主屏幕 - 4个Tab导航
class MainScreenV2 extends StatefulWidget {
  const MainScreenV2({super.key});

  @override
  State<MainScreenV2> createState() => _MainScreenV2State();
}

class _MainScreenV2State extends State<MainScreenV2> {
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
            const HomePage(),
            const ScannerPage(),
            const StatisticsPage(),
            const ProfilePage(),
          ];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
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
          unselectedItemColor: Colors.grey.shade500,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            _buildNavItem(
              icon: Icons.home_rounded,
              activeIcon: Icons.home_rounded,
              label: l10n.bottom_home_page,
            ),
            _buildNavItem(
              icon: Icons.qr_code_scanner_rounded,
              activeIcon: Icons.qr_code_scanner_rounded,
              label: '扫描',
            ),
            _buildNavItem(
              icon: Icons.bar_chart_rounded,
              activeIcon: Icons.bar_chart_rounded,
              label: '统计',
            ),
            _buildNavItem(
              icon: Icons.person_rounded,
              activeIcon: Icons.person_rounded,
              label: '我的',
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Icon(activeIcon),
      label: label,
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
