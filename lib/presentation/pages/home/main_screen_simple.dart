import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/pages/home/home_page_v2.dart';
import 'package:refundo/presentation/pages/profile/profile_page.dart';
import 'package:refundo/presentation/pages/initialization_model.dart';

/// 简化的主屏幕 - 2个Tab
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
    ];

    // 等待初始化完成后加载真实页面
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initModel = Provider.of<InitializationModel>(context, listen: false);
      if (initModel.isInitial) {
        setState(() {
          _isInitialized = true;
          _pages = [
            const HomePageV2(),
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
      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            activeIcon: const Icon(Icons.home_rounded),
            label: l10n.bottom_home_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            activeIcon: const Icon(Icons.person_rounded),
            label: '我的',
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
