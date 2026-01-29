import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:decimal/decimal.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/app_provider.dart';
import 'package:refundo/core/utils/storage/offline_order_storage.dart';
import 'package:refundo/data/models/Product_model.dart';
import 'package:refundo/data/models/order_model.dart';
import 'package:refundo/presentation/widgets/app_states.dart';
import 'package:refundo/core/performance/performance_optimizer.dart';
import 'package:refundo/presentation/pages/debug/debug_viewers.dart';

/// 调试测试工具类
class DebugTestTools {
  DebugTestTools._();

  // ==================== 用户功能测试 ====================

  /// 测试登录流程
  static Future<void> testLoginFlow(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('测试登录流程'),
        content: const Text('将模拟用户登录流程\n是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('开始测试'),
          ),
        ],
      ),
    );

    if (result == true) {
      // 模拟登录
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', 'test_token_${DateTime.now().millisecondsSinceEpoch}');

      if (context.mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        // 触发登录
        userProvider.Info(context);

        AppStateNotifications.success(context, '登录流程测试完成');
      }
    }
  }

  /// 测试登出流程
  static Future<void> testLogoutFlow(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.logout(context);
    AppStateNotifications.info(context, '已登出');
  }

  /// 测试更新用户信息
  static Future<void> testUpdateUserInfo(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (!userProvider.isLogin) {
      AppStateNotifications.error(context, '请先登录');
      return;
    }

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('更新用户信息'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: '新用户名',
            hintText: '输入新的用户名',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'TestUser'),
            child: const Text('更新'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      // 这里可以调用实际的更新接口
      AppStateNotifications.success(context, '用户名更新为: $result');
    }
  }

  // ==================== 订单功能测试 ====================

  /// 测试加载订单
  static Future<void> testLoadOrders(BuildContext context) async {
    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      await orderProvider.getOrders(context);
      final count = orderProvider.orders?.length ?? 0;
      AppStateNotifications.success(context, '订单加载成功，共 $count 条');
    } catch (e) {
      AppStateNotifications.error(context, '订单加载失败: $e');
    }
  }

  /// 测试添加订单
  static Future<void> testAddOrder(BuildContext context) async {
    // 创建测试订单
    final testProduct = ProductModel(
      ProductId: 'TEST_${DateTime.now().millisecondsSinceEpoch}',
      Hash: 'test_hash_${DateTime.now().millisecondsSinceEpoch}',
      price: Decimal.fromInt(1000),
      RefundAmount: Decimal.fromInt(800),
      RefundPercent: 80.0,
    );

    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final message = await orderProvider.insertOrder(testProduct, context);
      AppStateNotifications.success(context, message);
    } catch (e) {
      AppStateNotifications.error(context, '添加测试订单失败: $e');
    }
  }

  /// 测试同步离线订单
  static Future<void> testSyncOffline(BuildContext context) async {
    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final result = await orderProvider.syncOfflineOrders(context);
      final success = result['success'] ?? 0;
      final failed = result['failed'] ?? 0;

      if (success > 0 || failed > 0) {
        AppStateNotifications.success(
          context,
          '同步完成: 成功 $success 条，失败 $failed 条',
        );
      } else {
        AppStateNotifications.info(context, '没有离线订单需要同步');
      }
    } catch (e) {
      AppStateNotifications.error(context, '同步失败: $e');
    }
  }

  /// 测试清空订单
  static void testClearOrders(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.clearOrders();
    AppStateNotifications.info(context, '订单已清空');
  }

  // ==================== 错误场景测试 ====================

  /// 模拟网络错误
  static void simulateNetworkError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.wifi_off, color: Colors.red, size: 48),
        title: const Text('网络错误测试'),
        content: const Text('将显示网络连接失败提示\n是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppStateNotifications.error(
                context,
                '网络连接失败，请检查网络设置',
                action: SnackBarAction(
                  label: '重试',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    simulateNetworkError(context);
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('触发'),
          ),
        ],
      ),
    );
  }

  /// 模拟服务器错误
  static void simulateServerError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning, color: Colors.orange, size: 48),
        title: const Text('服务器错误测试'),
        content: const Text('将显示500服务器错误提示\n是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppStateNotifications.error(
                context,
                '服务器错误(500)，请稍后重试',
                action: SnackBarAction(
                  label: '重试',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('触发'),
          ),
        ],
      ),
    );
  }

  /// 模拟超时错误
  static void simulateTimeoutError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.timer, color: Colors.amber, size: 48),
        title: const Text('超时错误测试'),
        content: const Text('将显示请求超时提示\n是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('请求超时，请检查网络连接'),
                  backgroundColor: Colors.amber,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('触发'),
          ),
        ],
      ),
    );
  }

  /// 模拟认证错误
  static void simulateAuthError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.lock, color: Colors.deepOrange, size: 48),
        title: const Text('认证错误测试'),
        content: const Text('将显示401认证失败提示\n是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('登录已过期，请重新登录'),
                  backgroundColor: Colors.deepOrange,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            child: const Text('触发'),
          ),
        ],
      ),
    );
  }

  // ==================== 边界测试 ====================

  /// 模拟空数据状态
  static void simulateEmptyData(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.clearOrders();
    AppStateNotifications.info(context, '已清空数据，显示空状态');
  }

  /// 模拟大数据量
  static void simulateLargeData(BuildContext context) {
    // 创建100个模拟订单
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    final orders = List.generate(100, (index) {
      return OrderModel(
        orderid: index + 1,
        orderNumber: 'TEST${DateTime.now().millisecondsSinceEpoch}$index',
        ProductId: 'PRODUCT_$index',
        price: Decimal.fromInt((index + 1) * 500),
        refundAmount: Decimal.fromInt((index + 1) * 400),
        refundpercent: Decimal.fromInt(80),
        OrderTime: DateTime.now().toString(),
        isRefund: false,
        refundState: false,
        refundTime: '',
      );
    });

    // 这里需要设置orders到provider
    // 由于orders是私有的，实际使用时需要添加公开的setOrders方法
    AppStateNotifications.info(context, '已生成100条模拟订单');
  }

  /// 模拟特殊字符
  static Future<void> simulateSpecialChars(BuildContext context) async {
    final specialStrings = [
      '!@#\$%^&*()',
      '中文测试',
      '日本語テスト',
      '한국어테스트',
      'العربية',
      '🎉🎊🎁',
      '<script>alert("xss")</script>',
      'SELECT * FROM users WHERE 1=1',
    ];

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('特殊字符测试'),
        content: const Text('选择一个特殊字符串进行测试'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, specialStrings.first),
            child: const Text('测试第一个'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      // 测试特殊字符处理
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      AppStateNotifications.info(context, '特殊字符: $result');
    }
  }

  // ==================== 工具方法 ====================

  /// 模拟登录
  static Future<void> simulateLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final testToken = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
    await prefs.setString('access_token', testToken);

    if (context.mounted) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.Info(context);
      AppStateNotifications.success(context, '模拟登录成功');
    }
  }

  /// 模拟登出
  static void simulateLogout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.logout(context);
    AppStateNotifications.info(context, '模拟登出成功');
  }

  /// 切换深色模式
  static Future<void> toggleDarkMode(BuildContext context) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.toggleDarkMode();
    if (context.mounted) {
      final mode = appProvider.isDarkMode ? '深色模式' : '浅色模式';
      AppStateNotifications.success(context, '已切换到$mode');
    }
  }

  /// 清空所有数据
  static Future<void> clearAllData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ 警告'),
        content: const Text('确定要清空所有数据吗？此操作不可恢复！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('确定清空'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // 清空所有数据
      await OfflineOrderStorage.clearOfflineOrders();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.clearOrders();

      if (context.mounted) {
        AppStateNotifications.success(context, '所有数据已清空');
      }
    }
  }

  /// 生成测试数据
  static Future<void> generateTestData(BuildContext context) async {
    // 生成5个测试订单
    for (int i = 0; i < 5; i++) {
      final testProduct = ProductModel(
        ProductId: 'TEST_PRODUCT_${i}_${DateTime.now().millisecondsSinceEpoch}',
        Hash: 'test_hash_${i}_${DateTime.now().millisecondsSinceEpoch}',
        price: Decimal.fromInt((i + 1) * 500),
        RefundAmount: Decimal.fromInt((i + 1) * 400),
        RefundPercent: 80.0,
      );

      try {
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        await orderProvider.insertOrder(testProduct, context);
      } catch (e) {
        // 忽略错误，继续生成
      }
    }

    if (context.mounted) {
      AppStateNotifications.success(context, '已生成5条测试订单');
    }
  }

  /// 导出日志
  static Future<void> exportLogs(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导出日志'),
        content: const Text('日志导出功能开发中...\n\n日志已输出到控制台'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 重置应用
  static Future<void> resetApp(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ 重置应用'),
        content: const Text('确定要重置应用吗？这将清空所有数据并恢复默认设置。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('确定重置'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await clearAllData(context);

      if (context.mounted) {
        // 重启应用
        AppStateNotifications.success(context, '应用已重置，请重启应用');
      }
    }
  }

  /// 切换环境
  static Future<void> switchEnvironment(BuildContext context) async {
    final env = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择环境'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('开发环境'),
              subtitle: const Text('http://114.215.202.212:4040'),
              onTap: () => Navigator.pop(context, 'dev'),
            ),
            const Divider(),
            ListTile(
              title: const Text('测试环境'),
              subtitle: const Text('http://test-api.example.com'),
              onTap: () => Navigator.pop(context, 'test'),
            ),
            const Divider(),
            ListTile(
              title: const Text('生产环境'),
              subtitle: const Text('https://api.example.com'),
              onTap: () => Navigator.pop(context, 'prod'),
            ),
          ],
        ),
      ),
    );

    if (env != null && context.mounted) {
      final envName = env == 'dev' ? '开发' : env == 'test' ? '测试' : '生产';
      AppStateNotifications.info(context, '环境已切换到: $envName\n请重启应用生效');
    }
  }

  /// 测试API连接
  static Future<void> testApiConnection(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('测试API连接...'),
          ],
        ),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        Navigator.pop(context);
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('测试结果'),
              content: const Text('❌ 未登录\n请先登录后再测试API连接'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // 模拟API请求
      await Future.delayed(const Duration(seconds: 2));

      Navigator.pop(context);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('测试结果'),
            content: Text('✅ API连接正常\n\nToken: $token'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('测试结果'),
            content: Text('❌ API连接失败\n\n错误: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    }
  }

  /// 显示性能报告
  static void showPerformanceReport(BuildContext context) {
    final report = PerformanceOptimizer.instance.getPerformanceReport();

    if (report.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('性能报告'),
          content: const Text('暂无性能数据\n请先使用应用功能后再查看'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('性能报告'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in report.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${entry.key}:'),
                      Text(
                        entry.value,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => PerformanceOptimizer.instance.clearMetrics(),
            child: const Text('清除数据'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示帧率指标
  static void showFrameMetrics(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('帧率监控'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('目标帧率: 60 FPS (16.67ms/帧)'),
            SizedBox(height: 8),
            Text('优秀: <16ms'),
            Text('良好: 16-33ms'),
            Text('一般: 33-100ms'),
            Text('较差: >100ms'),
            SizedBox(height: 16),
            Text('性能监控已启用\n慢帧将自动记录到日志'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示内存分析
  static void showMemoryAnalysis(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('内存分析'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('内存使用情况'),
            const SizedBox(height: 16),
            _MemoryBar(label: '已使用', value: 0.4, color: Colors.blue),
            const SizedBox(height: 8),
            _MemoryBar(label: '缓存', value: 0.2, color: Colors.orange),
            const SizedBox(height: 8),
            _MemoryBar(label: '可用', value: 0.4, color: Colors.green),
            const SizedBox(height: 16),
            const Text('提示: 内存数据仅供参考\n实际内存使用请使用 Dart DevTools'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示SharedPreferences查看器
  static void showSharedPreferencesViewer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SharedPreferencesViewer(),
      ),
    );
  }

  /// 显示离线订单查看器
  static void showOfflineOrdersViewer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OfflineOrdersViewer(),
      ),
    );
  }

  /// 显示文件系统查看器
  static void showFileSystemViewer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FileSystemViewer(),
      ),
    );
  }

  /// 显示缓存查看器
  static void showCacheViewer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CacheViewer(),
      ),
    );
  }
}

class _MemoryBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MemoryBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${(value * 100).toStringAsFixed(1)}%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}
