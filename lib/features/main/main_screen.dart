import 'package:provider/provider.dart';
import 'package:refundo/features/main/models/initialization_model.dart';
import 'package:refundo/features/main/pages/home/home_page.dart';
import 'package:refundo/features/main/pages/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  // 当前导航页（初始化为 0）
  int _currentIndex = 0;
  // 导航页面
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 初始化时不加载页面，等待初始化加载完毕
    _pages = [
      const Center(child: CircularProgressIndicator()),
      const Center(child: CircularProgressIndicator()),
    ];
    // 初始化完成后加载页面
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(Provider.of<InitializationModel>(context,listen: false).isInitial){
        setState(() {
          _pages = [
            HomePage(),
            SettingPage()
          ];
        });
      }
    });
  }

  // 构造方法
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // 导航栏
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.bottom_home_page
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppLocalizations.of(context)!.bottom_setting_page
          )
        ],
        // 选择的页面颜色
        selectedItemColor: Colors.blue,
        // 未选择的页面颜色
        unselectedItemColor: Colors.grey,
      ),
    );
  }

}