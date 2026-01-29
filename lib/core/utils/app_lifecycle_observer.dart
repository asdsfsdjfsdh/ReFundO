import 'package:flutter/widgets.dart';
import 'package:refundo/presentation/providers/network_provider.dart';

/// 应用生命周期观察者
/// 用于监听应用的生命周期变化，在适当时机清理资源
class AppLifecycleObserver with WidgetsBindingObserver {
  static AppLifecycleObserver? _instance;

  static AppLifecycleObserver get instance {
    _instance ??= AppLifecycleObserver._();
    return _instance!;
  }

  AppLifecycleObserver._();

  /// 初始化生命周期监听
  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // 应用从后台恢复前台
        _onResumed();
        break;
      case AppLifecycleState.inactive:
        // 应用进入非活动状态（如收到电话、通知等）
        _onInactive();
        break;
      case AppLifecycleState.paused:
        // 应用进入后台
        _onPaused();
        break;
      case AppLifecycleState.detached:
        // 应用正在被销毁（如用户关闭应用）
        _onDetached();
        break;
      case AppLifecycleState.hidden:
        // 应用被隐藏（新增状态）
        _onHidden();
        break;
    }
  }

  /// 应用恢复前台
  void _onResumed() {
    // 可以在这里恢复一些暂停的操作
    print('应用已恢复前台');
  }

  /// 应用进入非活动状态
  void _onInactive() {
    // 可以在这里暂停一些操作
    print('应用进入非活动状态');
  }

  /// 应用进入后台
  void _onPaused() {
    // 可以在这里保存数据、暂停动画等
    print('应用进入后台');
  }

  /// 应用被隐藏
  void _onHidden() {
    print('应用被隐藏');
  }

  /// 应用正在被销毁
  void _onDetached() {
    // 在这里清理所有资源
    print('应用正在被销毁，清理资源...');

    // 清理NetworkProvider
    NetworkProvider.disposeInstance();

    // 如果有其他需要清理的资源，在这里添加
    // 例如：关闭数据库连接、清除缓存等
  }

  /// 手动清理资源（可在应用退出时调用）
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _onDetached();
  }
}
