import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/home/provider/refund_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';

class InitializationModel with ChangeNotifier{
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
  Future<void> initializeApp(BuildContext context)async{
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    _currentStatus = InitializationStatus.loadingData;
    Provider.of<OrderProvider>(context,listen: false).getOrders();
    Provider.of<RefundProvider>(context,listen: false).getRefunds();
    Provider.of<UserProvider>(context,listen: false).initProvider();
    await Future.delayed(const Duration(seconds: 3));
    _isInitial = true;
    notifyListeners();
    _currentStatus = InitializationStatus.complete;
  }
}

// 初始化状态的枚举
enum InitializationStatus{
  starting,
  loadingData,
  complete,
  unknown
}