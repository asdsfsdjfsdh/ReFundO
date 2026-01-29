import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:refundo/presentation/pages/home/main_screen_v2.dart';
import 'package:refundo/presentation/pages/initialization_model.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/providers/app_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/presentation/providers/email_provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/pages/start/start_screen.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/config/routes/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        // 移除ApprovalProvider - 审批功能在ruoyi后台管理
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          // 加载保存的语言设置
          appProvider.loadLocale();

          return MaterialApp(
            title: "RefundO",
            // 设置首页路由为启动界面
            initialRoute: AppRoutes.start,
            // 初始化路由
            routes: {
              AppRoutes.main: (context) => const MainScreenV2(),
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
            // 性能优化：禁用debug标记
            debugShowMaterialGrid: false,
          );
        },
      ),
    );
  }
}

