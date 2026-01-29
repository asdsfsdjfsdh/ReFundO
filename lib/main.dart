import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:refundo/presentation/pages/home/main_screen.dart';
import 'package:refundo/presentation/pages/initialization_model.dart';
import 'package:refundo/presentation/providers/approval_provider.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/providers/app_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/presentation/providers/email_provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/pages/start/start_screen.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/config/routes/routes.dart';
import 'package:refundo/core/performance/performance_optimizer.dart';
import 'package:refundo/core/utils/app_lifecycle_observer.dart';
import 'package:refundo/presentation/pages/debug/debug_panel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化性能优化器
  await PerformanceOptimizer.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AppLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    _lifecycleObserver = AppLifecycleObserver();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InitializationModel()),
        ChangeNotifierProvider(
          create: (_) {
            final orderProvider = OrderProvider();
            // 初始化离线订单功能
            orderProvider.initialize();
            return orderProvider;
          }
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => RefundProvider()),
        ChangeNotifierProvider(create: (_) => EmailProvider()),
        ChangeNotifierProvider(create: (_) => DioProvider()),
        ChangeNotifierProvider(create: (_) => ApprovalProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          // 加载保存的语言设置
          appProvider.loadLocale();

          final app = MaterialApp(
            title: "RefundO",
            // 设置首页路由为启动界面
            initialRoute: AppRoutes.start,
            // 初始化路由
            routes: {
              AppRoutes.main: (context) => const MainScreen(),
              AppRoutes.start: (context) => const StartScreen(),
            },
            locale: appProvider.locale,
            // 配置本地化代理（语言转换）
            localizationsDelegates: const [
              AppLocalizations.delegate, // 生成本地化代理
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            // 支持的语言环境
            supportedLocales: const [
              // 英语
              Locale('en'),
              // 中文
              Locale('zh'),
              Locale('fr', 'FR'), // 法语
            ],
            // 性能优化：启用光标去抖动
            debugShowMaterialGrid: false,
          );

          // 用调试面板包装应用（仅在调试模式）
          return DebugPanelWrapper(child: app);
        },
      ),
    );
  }

}

