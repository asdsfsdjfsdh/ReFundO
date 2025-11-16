import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:refundo/features/main/main_screen.dart';
import 'package:refundo/features/main/models/initialization_model.dart';
import 'package:refundo/features/main/pages/home/provider/approval_provider.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/home/provider/refund_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/app_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/email_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/features/start/start_screen.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/routes/routes.dart';
import 'package:provider/provider.dart';

void main() async{
  runApp(

     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmailProvider()),
        ChangeNotifierProvider(create: (_) => DioProvider()),
        ChangeNotifierProvider(create: (_) => RefundProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppStatus();
}

class _MyAppStatus extends State<MyApp>{

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InitializationModel()),
        ChangeNotifierProvider(create: (context)=> OrderProvider()),
        ChangeNotifierProvider(create: (context)=> RefundProvider()),
        ChangeNotifierProvider(create: (context)=> UserProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => EmailProvider()),
        ChangeNotifierProvider(create: (context) => DioProvider()),
        ChangeNotifierProvider(create: (context) => ApprovalProvider()),
      ],
      child:Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            // 加载保存的语言设置
            appProvider.loadLocale();
            return MaterialApp(
              title: "RefundO",
              // 设置首页路由为启动界面
              initialRoute: AppRoutes.start,
              // 初始化路由
              routes: {
                AppRoutes.main: (context) => MainScreen(),
                AppRoutes.start: (context) => StartScreen(),
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
              supportedLocales: const[
                // 英语
                Locale('en'),
                // 中文
                Locale('zh'),
                Locale('fr', 'FR'), // 法语
              ],
            );
          }
          )
    );
  }

}

