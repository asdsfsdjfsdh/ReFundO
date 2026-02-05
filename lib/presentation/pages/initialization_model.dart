import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';

class InitializationModel with ChangeNotifier {
  InitializationStatus _currentStatus = InitializationStatus.starting;
  bool _isInitial = false;

  InitializationStatus get currentStatus => _currentStatus;
  bool get isInitial => _isInitial;

  // 获取初始化状态描述（包括语言转换）
  String getCurrentStatusText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_currentStatus) {
      case InitializationStatus.starting:
        return l10n.start_initialization_starting;
      case InitializationStatus.loadingData:
        return l10n.start_initialization_loadingData;
      case InitializationStatus.complete:
        return l10n.start_initialization_complete;
      default:
        return l10n.start_initialization_unknown;
    }
  }

  // 初始化任务
  Future<void> initializeApp(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    _currentStatus = InitializationStatus.loadingData;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // 先执行初始化（如果记住密码，会自动登录并加载订单和退款）
    await userProvider.initProvider(context);

    // 如果用户已登录（初始化前就登录或刚登录成功），数据已由 login 加载
    // 不需要在这里重复加载

    await Future.delayed(const Duration(seconds: 3));
    _isInitial = true;
    notifyListeners();
    _currentStatus = InitializationStatus.complete;
  }
}

// 初始化状态的枚举
enum InitializationStatus { starting, loadingData, complete, unknown }

