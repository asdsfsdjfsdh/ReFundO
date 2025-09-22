import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/models/initialization_model.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/routes/routes.dart';

class StartScreen extends StatefulWidget{
  const StartScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    // 确保当前帧结束后执行app初始化
    WidgetsBinding.instance.addPostFrameCallback((_){
      final initModel = Provider.of<InitializationModel>(context,listen: false);
      initModel.initializeApp(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 使用 Consumer 来监听 InitializationModel 的变化
    return Consumer<InitializationModel>(
      builder: (context,initModel,child){
        // 判断初始化是否完成
        if(initModel.currentStatus == InitializationStatus.complete){
          // 确保当前帧结束后执行页面切换
          WidgetsBinding.instance.addPostFrameCallback((_){
            Navigator.of(context).pushReplacementNamed(AppRoutes.main);
          });
        }
        return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 动态调整logo大小
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(initModel.getCurrentStatusText(context)),
                  CircularProgressIndicator()
                ],
              ),
            ),
          );
      },
    );
  }
}