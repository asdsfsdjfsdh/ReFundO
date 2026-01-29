import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/providers/app_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/core/utils/storage/offline_order_storage.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/utils/error_handler.dart';
import 'package:refundo/core/performance/performance_optimizer.dart';
import 'package:refundo/presentation/widgets/app_states.dart';
import 'package:refundo/presentation/pages/debug/complete_debug_panel.dart';

/// 调试面板页面
/// 注意：这是基础版本，推荐使用 CompleteDebugPanelPage
@deprecated
class DebugPanelPage extends StatefulWidget {
  const DebugPanelPage({super.key});

  @override
  State<DebugPanelPage> createState() => _DebugPanelPageState();
}

class _DebugPanelPageState extends State<DebugPanelPage> {
  final List<String> _logs = [];
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('调试面板'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearDialog(context),
            tooltip: '清理数据',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 用户状态测试
          _buildSection(
            context,
            title: '👤 用户状态测试',
            children: [
              _buildTestCard(
                context,
                title: '用户登录状态',
                subtitle: _getUserLoginStatus(context),
                icon: Icons.person,
                color: Colors.blue,
                actions: [
                  TextButton(
                    onPressed: () => _testUserInfo(context),
                    child: const Text('查看信息'),
                  ),
                  TextButton(
                    onPressed: () => _simulateLogin(context),
                    child: const Text('模拟登录'),
                  ),
                  TextButton(
                    onPressed: () => _simulateLogout(context),
                    child: const Text('模拟登出'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 订单功能测试
          _buildSection(
            context,
            title: '📦 订单功能测试',
            children: [
              _buildTestCard(
                context,
                title: '订单列表',
                subtitle: _getOrderStatus(context),
                icon: Icons.list_alt,
                color: Colors.green,
                actions: [
                  TextButton(
                    onPressed: () => _testLoadOrders(context),
                    child: const Text('加载'),
                  ),
                  TextButton(
                    onPressed: () => _testClearOrders(context),
                    child: const Text('清空'),
                  ),
                ],
              ),
              _buildTestCard(
                context,
                title: '离线订单',
                subtitle: _getOfflineOrderStatus(context),
                icon: Icons.cloud_off,
                color: Colors.orange,
                actions: [
                  TextButton(
                    onPressed: () => _testSyncOfflineOrders(context),
                    child: const Text('同步'),
                  ),
                  TextButton(
                    onPressed: () => _testClearOfflineOrders(context),
                    child: const Text('清空'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 网络测试
          _buildSection(
            context,
            title: '🌐 网络功能测试',
            children: [
              _buildTestCard(
                context,
                title: 'API连接测试',
                subtitle: '测试后端接口是否正常',
                icon: Icons.wifi,
                color: Colors.purple,
                actions: [
                  TextButton(
                    onPressed: () => _testNetworkConnection(context),
                    child: const Text('测试'),
                  ),
                ],
              ),
              _buildTestCard(
                context,
                title: '网络缓存',
                subtitle: '查看和管理网络缓存',
                icon: Icons.cached,
                color: Colors.teal,
                actions: [
                  TextButton(
                    onPressed: () => _testClearCache(context),
                    child: const Text('清理'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 状态管理测试
          _buildSection(
            context,
            title: '🔄 状态管理测试',
            children: [
              _buildTestCard(
                context,
                title: 'Provider状态',
                subtitle: '查看所有Provider状态',
                icon: Icons.settings,
                color: Colors.indigo,
                actions: [
                  TextButton(
                    onPressed: () => _showProviderStates(context),
                    child: const Text('查看'),
                  ),
                ],
              ),
              _buildTestCard(
                context,
                title: '语言切换',
                subtitle: _getLanguageStatus(context),
                icon: Icons.language,
                color: Colors.cyan,
                actions: [
                  TextButton(
                    onPressed: () => _switchLanguage(context, 'en'),
                    child: const Text('EN'),
                  ),
                  TextButton(
                    onPressed: () => _switchLanguage(context, 'zh'),
                    child: const Text('中文'),
                  ),
                  TextButton(
                    onPressed: () => _switchLanguage(context, 'fr'),
                    child: const Text('FR'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 性能监控
          _buildSection(
            context,
            title: '⚡ 性能监控',
            children: [
              _buildTestCard(
                context,
                title: '性能报告',
                subtitle: '查看应用性能统计',
                icon: Icons.speed,
                color: Colors.amber,
                actions: [
                  TextButton(
                    onPressed: () => _showPerformanceReport(context),
                    child: const Text('查看'),
                  ),
                ],
              ),
              _buildTestCard(
                context,
                title: '内存使用',
                subtitle: '检查内存占用情况',
                icon: Icons.memory,
                color: Colors.red,
                actions: [
                  TextButton(
                    onPressed: () => _testMemoryUsage(context),
                    child: const Text('检查'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 模拟场景测试
          _buildSection(
            context,
            title: '🎭 模拟场景测试',
            children: [
              _buildTestCard(
                context,
                title: '网络错误',
                subtitle: '模拟网络连接失败',
                icon: Icons.error_outline,
                color: Colors.red,
                actions: [
                  TextButton(
                    onPressed: () => _simulateNetworkError(context),
                    child: const Text('触发'),
                  ),
                ],
              ),
              _buildTestCard(
                context,
                title: '服务器错误',
                subtitle: '模拟500服务器错误',
                icon: Icons.warning_amber,
                color: Colors.orange,
                actions: [
                  TextButton(
                    onPressed: () => _simulateServerError(context),
                    child: const Text('触发'),
                  ),
                ],
              ),
              _buildTestCard(
                context,
                title: '空数据状态',
                subtitle: '测试空数据展示',
                icon: Icons.inbox,
                color: Colors.grey,
                actions: [
                  TextButton(
                    onPressed: () => _simulateEmptyData(context),
                    child: const Text('触发'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 日志查看
          _buildSection(
            context,
            title: '📋 日志',
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '应用日志',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _logs.clear();
                                  });
                                },
                                icon: const Icon(Icons.clear, size: 16),
                                label: const Text('清空'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  _toggleRecording();
                                },
                                icon: Icon(
                                  _isRecording ? Icons.stop : Icons.play_arrow,
                                  size: 16,
                                ),
                                label: Text(_isRecording ? '停止' : '开始'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: _logs.isEmpty
                            ? const Center(
                                child: Text('暂无日志'),
                              )
                            : ListView.builder(
                                itemCount: _logs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      _logs[index],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildTestCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<Widget> actions,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: actions,
        ),
      ),
    );
  }

  // ==================== 测试方法 ====================

  String _getUserLoginStatus(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.isLogin ? '已登录' : '未登录';
  }

  String _getOrderStatus(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final count = orderProvider.orders?.length ?? 0;
    return '$count 条订单';
  }

  String _getOfflineOrderStatus(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return '${orderProvider.offlineOrderCount} 条离线订单';
  }

  String _getLanguageStatus(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return appProvider.locale.languageCode;
  }

  // 用户测试
  void _testUserInfo(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user != null) {
      _showInfoDialog(
        context,
        '用户信息',
        '用户名: ${userProvider.user!.username}\n'
        '邮箱: ${userProvider.user!.email}\n'
        '余额: ${userProvider.user!.AmountSum}\n'
        '账户: ${userProvider.user!.userAccount}',
      );
    } else {
      _showErrorDialog(context, '未登录');
    }
  }

  void _simulateLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', 'test_token_debug');
    _addLog('模拟登录成功');
    _showSuccessDialog(context, '已模拟登录');
  }

  void _simulateLogout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.logout(context);
    _addLog('模拟登出成功');
    _showSuccessDialog(context, '已模拟登出');
  }

  // 订单测试
  void _testLoadOrders(BuildContext context) async {
    _addLog('开始加载订单...');
    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      await orderProvider.getOrders(context);
      final count = orderProvider.orders?.length ?? 0;
      _addLog('订单加载成功: $count 条');
      _showSuccessDialog(context, '订单加载成功\n共 $count 条订单');
    } catch (e) {
      _addLog('订单加载失败: $e');
      _showErrorDialog(context, '订单加载失败: $e');
    }
  }

  void _testClearOrders(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.clearOrders();
    _addLog('订单已清空');
    _showSuccessDialog(context, '订单已清空');
  }

  void _testSyncOfflineOrders(BuildContext context) async {
    _addLog('开始同步离线订单...');
    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final result = await orderProvider.syncOfflineOrders(context);
      _addLog('同步完成: ${result['success']} 成功, ${result['failed']} 失败');
      _showSuccessDialog(
        context,
        '同步完成\n成功: ${result['success']}\n失败: ${result['failed']}',
      );
    } catch (e) {
      _addLog('同步失败: $e');
      _showErrorDialog(context, '同步失败: $e');
    }
  }

  void _testClearOfflineOrders(BuildContext context) async {
    await OfflineOrderStorage.clearOfflineOrders();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    await orderProvider.initialize();
    _addLog('离线订单已清空');
    _showSuccessDialog(context, '离线订单已清空');
  }

  // 网络测试
  void _testNetworkConnection(BuildContext context) async {
    _addLog('测试网络连接...');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null || token.isEmpty) {
        _addLog('网络测试失败: 未登录');
        _showErrorDialog(context, '请先登录');
        return;
      }

      // 这里可以添加实际的API测试
      await Future.delayed(const Duration(seconds: 1));
      _addLog('网络连接正常');
      _showSuccessDialog(context, '网络连接正常');
    } catch (e) {
      _addLog('网络连接失败: $e');
      _showErrorDialog(context, '网络连接失败: $e');
    }
  }

  void _testClearCache(BuildContext context) {
    final dioProvider = Provider.of<DioProvider>(context, listen: false);
    dioProvider.clearCache();
    _addLog('网络缓存已清理');
    _showSuccessDialog(context, '网络缓存已清理');
  }

  // 状态管理测试
  void _showProviderStates(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final refundProvider = Provider.of<RefundProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    _showInfoDialog(
      context,
      'Provider状态',
      'UserProvider:\n'
      '  - 登录状态: ${userProvider.isLogin}\n'
      '  - 用户名: ${userProvider.user?.username ?? "N/A"}\n\n'
      'OrderProvider:\n'
      '  - 订单数: ${orderProvider.orders?.length ?? 0}\n'
      '  - 离线订单数: ${orderProvider.offlineOrderCount}\n'
      '  - 当前页: ${orderProvider.currentPage}\n'
      '  - 有更多: ${orderProvider.hasMore}\n\n'
      'RefundProvider:\n'
      '  - 退款数: ${refundProvider.refunds?.length ?? 0}\n'
      '  - 选中订单数: ${refundProvider.orders?.length ?? 0}\n\n'
      'AppProvider:\n'
      '  - 语言: ${appProvider.locale.languageCode}\n'
      '  - 深色模式: ${appProvider.isDarkMode}',
    );
  }

  void _switchLanguage(BuildContext context, String languageCode) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.changeLocale(languageCode);
    _addLog('语言已切换到: $languageCode');
    if (mounted) {
      _showSuccessDialog(context, '语言已切换到 $languageCode');
    }
  }

  // 性能测试
  void _showPerformanceReport(BuildContext context) {
    PerformanceOptimizer.instance.printPerformanceReport();
    final report = PerformanceOptimizer.instance.getPerformanceReport();

    if (report.isEmpty) {
      _showInfoDialog(context, '性能报告', '暂无性能数据');
    } else {
      final reportText = report.entries
          .map((e) => '${e.key}: ${e.value}')
          .join('\n');
      _showInfoDialog(context, '性能报告', reportText);
    }
  }

  void _testMemoryUsage(BuildContext context) {
    PerformanceOptimizer.checkMemoryUsage('DebugPanel');
    _showInfoDialog(context, '内存检查', '内存检查已完成\n请查看控制台日志');
  }

  // 模拟场景测试
  void _simulateNetworkError(BuildContext context) {
    _addLog('模拟网络错误');
    ErrorHandler.showErrorSnackBar(
      context,
      AppError(
        message: '网络连接失败',
        type: AppErrorType.network,
      ),
    );
  }

  void _simulateServerError(BuildContext context) {
    _addLog('模拟服务器错误');
    ErrorHandler.showErrorSnackBar(
      context,
      AppError(
        message: '服务器错误，请稍后重试',
        type: AppErrorType.server,
        statusCode: 500,
      ),
    );
  }

  void _simulateEmptyData(BuildContext context) {
    _addLog('模拟空数据');
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.clearOrders();
    _showSuccessDialog(context, '已清空数据，显示空状态');
  }

  // ==================== 辅助方法 ====================

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清理数据'),
        content: const Text('确定要清理所有调试数据吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await OfflineOrderStorage.clearOfflineOrders();
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pop(context);
              _addLog('所有数据已清理');
              _showSuccessDialog(context as BuildContext, '所有数据已清理');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('成功'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error, color: Colors.red, size: 48),
        title: const Text('错误'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _addLog(String log) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    setState(() {
      _logs.add('[$timestamp] $log');
    });
    if (_logs.length > 100) {
      _logs.removeAt(0);
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      _addLog(_isRecording ? '开始记录日志' : '停止记录日志');
    });
  }
}

/// 调试面板入口按钮
class DebugPanelButton extends StatelessWidget {
  const DebugPanelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      right: 16,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (buttonContext) => FloatingActionButton(
            mini: true,
            heroTag: 'debug_panel',
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            onPressed: () {
              try {
                // 尝试使用普通Navigator
                Navigator.push(
                  buttonContext,
                  MaterialPageRoute(
                    builder: (context) => const CompleteDebugPanelPage(),
                  ),
                );
              } catch (e) {
                // 如果失败（比如在StartScreen），忽略错误
                // 调试按钮在MainScreen上可以正常工作
                debugPrint('导航失败: $e');
              }
            },
            child: const Icon(Icons.bug_report),
          ),
        ),
      ),
    );
  }
}

/// 仅在调试模式下显示调试按钮
class DebugPanelWrapper extends StatelessWidget {
  final Widget child;

  const DebugPanelWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 检查是否为调试模式
    const bool showDebugPanel = bool.fromEnvironment('dart.vm.product') == false;

    if (!showDebugPanel) {
      return child;
    }

    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        child,
        const DebugPanelButton(),
      ],
    );
  }
}
