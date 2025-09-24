import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/home/provider/refund_provider.dart';
import 'package:refundo/features/main/pages/home/widgets/order_widget.dart';
import 'package:refundo/features/main/pages/home/widgets/refund_widget.dart';
import 'package:refundo/features/scanner/scanner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("主页"),
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 金额显示圆圈
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.yellow, width: 2)
                  ),
                  child: Center(
                    child: Text('占位'),
                  ),
                ),
                const SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == 0 ? Colors.blue : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8,),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == 0 ? Colors.grey : Colors.blue,
                      ),
                    )
                  ],
                ),
                // 切换界面
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      // 订单页面
                      orderWidget(Provider
                          .of<OrderProvider>(context, listen: false)
                          .orders!),
                      // 提现页面
                      refundWidget(Provider
                          .of<RefundProvider>(context, listen: false)
                          .refunds!)
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2)
                        ),
                      ]
                  ),

                  child: IconButton(
                    icon: const Icon(Icons.qr_code_scanner, size: 30, color: Colors.white),
                    onPressed: () async {
                      // 1. 检查相机权限状态
                      final status = await Permission.camera.status;

                      if (status.isGranted) {
                        // 已有权限，直接跳转
                        _navigateToScanner(context);
                      } else {
                        // 2. 没有权限，则发起请求
                        final result = await Permission.camera.request();

                        // 3. 根据请求结果处理
                        if (result.isGranted) {
                          // 用户同意，跳转
                          _navigateToScanner(context);
                        } else {
                          // 用户拒绝（或永久拒绝），给出提示
                          _showPermissionDeniedDialog(context);
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  // 跳转到扫描页面
  void _navigateToScanner(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScannerPage(), // 你的扫描页面
      ),
    );
  }

// 显示权限被拒绝的提示对话框
  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('需要相机权限'),
        content: Text('扫码功能需要访问您的相机。请到系统设置中为应用启用相机权限。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // 关闭对话框
              openAppSettings(); // 跳转到系统设置页。这是permission_handler提供的方法
            },
            child: Text('去设置'),
          ),
        ],
      ),
    );
  }
}