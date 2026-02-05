import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/providers/app_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/core/utils/storage/offline_order_storage.dart';
import 'package:refundo/core/performance/performance_optimizer.dart';
import 'package:refundo/data/models/order_model.dart';
import 'package:refundo/core/utils/showToast.dart';

/// 高级调试面板页面
class AdvancedDebugPanelPage extends StatefulWidget {
  const AdvancedDebugPanelPage({super.key});

  @override
  State<AdvancedDebugPanelPage> createState() => _AdvancedDebugPanelPageState();
}

class _AdvancedDebugPanelPageState extends State<AdvancedDebugPanelPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('高级调试面板'),
          backgroundColor: Colors.deepPurple.shade700,
          foregroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            tabs: const [
              Tab(text: '状态', icon: Icon(Icons.analytics)),
              Tab(text: '网络', icon: Icon(Icons.network_check)),
              Tab(text: '数据', icon: Icon(Icons.storage)),
              Tab(text: '测试', icon: Icon(Icons.science)),
              Tab(text: '日志', icon: Icon(Icons.list)),
              Tab(text: '性能', icon: Icon(Icons.speed)),
              Tab(text: '设备', icon: Icon(Icons.phone_android)),
              Tab(text: '工具', icon: Icon(Icons.build)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() {}),
              tooltip: '刷新',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildStatusTab(context),
            _buildNetworkTab(context),
            _buildDataTab(context),
            _buildTestTab(context),
            _buildLogsTab(context),
            _buildPerformanceTab(context),
            _buildDeviceTab(context),
            _buildToolsTab(context),
          ],
        ),
      ),
    );
  }

  // ==================== 状态标签页 ====================
  Widget _buildStatusTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatusSection(context),
        const SizedBox(height: 24),
        _buildQuickActionsSection(context),
        const SizedBox(height: 24),
        _buildProviderStatesSection(context),
      ],
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '应用状态',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _StatusItem(
              label: '用户状态',
              value: userProvider.isLogin ? '已登录' : '未登录',
              color: userProvider.isLogin ? Colors.green : Colors.grey,
              icon: Icons.person,
            ),
            const Divider(height: 24),
            _StatusItem(
              label: '订单数量',
              value: '${orderProvider.orders?.length ?? 0} 条',
              color: Colors.blue,
              icon: Icons.list_alt,
            ),
            const Divider(height: 24),
            _StatusItem(
              label: '离线订单',
              value: '${orderProvider.offlineOrderCount} 条',
              color: Colors.orange,
              icon: Icons.cloud_off,
            ),
            const Divider(height: 24),
            _StatusItem(
              label: '当前语言',
              value: appProvider.locale.languageCode,
              color: Colors.purple,
              icon: Icons.language,
            ),
            const Divider(height: 24),
            _StatusItem(
              label: '深色模式',
              value: appProvider.isDarkMode ? '开启' : '关闭',
              color: appProvider.isDarkMode ? Colors.indigo : Colors.grey,
              icon: Icons.dark_mode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '快速操作',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _simulateLogin(context),
                  icon: const Icon(Icons.login),
                  label: const Text('模拟登录'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: () => _simulateLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('模拟登出'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton.icon(
                  onPressed: () => _toggleDarkMode(context),
                  icon: const Icon(Icons.dark_mode),
                  label: const Text('切换深色'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                ),
                ElevatedButton.icon(
                  onPressed: () => _clearAllData(context),
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('清空数据'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderStatesSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider 详细状态',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ProviderDetailCard(
              userProvider: Provider.of<UserProvider>(context),
              orderProvider: null,
              refundProvider: null,
              appProvider: null,
            ),
            const SizedBox(height: 12),
            _ProviderDetailCard(
              userProvider: null,
              orderProvider: Provider.of<OrderProvider>(context),
              refundProvider: null,
              appProvider: null,
            ),
            const SizedBox(height: 12),
            _ProviderDetailCard(
              userProvider: null,
              orderProvider: null,
              refundProvider: Provider.of<RefundProvider>(context),
              appProvider: null,
            ),
            const SizedBox(height: 12),
            _ProviderDetailCard(
              userProvider: null,
              orderProvider: null,
              refundProvider: null,
              appProvider: Provider.of<AppProvider>(context),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 网络标签页 ====================
  Widget _buildNetworkTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _NetworkTestCard(
          title: 'API 连接测试',
          icon: Icons.wifi,
          color: Colors.blue,
          onTest: () => _testApiConnection(context),
        ),
        const SizedBox(height: 16),
        _NetworkStatsCard(context),
        const SizedBox(height: 16),
        _NetworkRequestsList(context),
      ],
    );
  }

  Widget _buildNetworkStatsCard(BuildContext context) {
    final dioProvider = Provider.of<DioProvider>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '网络统计',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: '缓存状态',
                  value: '已启用',
                  icon: Icons.cached,
                  color: Colors.green,
                ),
                _StatItem(
                  label: '超时设置',
                  value: '30秒',
                  icon: Icons.timer,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkRequestsList(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '最近网络请求',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('清空'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '使用 Dio 拦截器记录网络请求\n(功能开发中...)',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 数据标签页 ====================
  Widget _buildDataTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DataViewerCard(
          title: 'SharedPreferences',
          icon: Icons.key,
          color: Colors.purple,
          onTap: () => _showSharedPreferencesViewer(context),
        ),
        const SizedBox(height: 16),
        _DataViewerCard(
          title: '离线订单数据',
          icon: Icons.cloud_off,
          color: Colors.orange,
          onTap: () => _showOfflineOrdersViewer(context),
        ),
        const SizedBox(height: 16),
        _DataViewerCard(
          title: '应用文件系统',
          icon: Icons.folder,
          color: Colors.blue,
          onTap: () => _showFileSystemViewer(context),
        ),
        const SizedBox(height: 16),
        _DataViewerCard(
          title: '缓存数据',
          icon: Icons.cached,
          color: Colors.teal,
          onTap: () => _showCacheViewer(context),
        ),
      ],
    );
  }

  // ==================== 测试标签页 ====================
  Widget _buildTestTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '功能测试场景',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _TestCategoryCard(
          title: '用户功能',
          icon: Icons.person,
          color: Colors.blue,
          tests: [
            _TestItem(name: '登录流程', onTap: () => _testLoginFlow(context)),
            _TestItem(name: '登出流程', onTap: () => _testLogoutFlow(context)),
            _TestItem(name: '更新用户信息', onTap: () => _testUpdateUserInfo(context)),
          ],
        ),
        const SizedBox(height: 16),
        _TestCategoryCard(
          title: '订单功能',
          icon: Icons.list_alt,
          color: Colors.green,
          tests: [
            _TestItem(name: '加载订单', onTap: () => _testLoadOrders(context)),
            _TestItem(name: '添加订单', onTap: () => _testAddOrder(context)),
            _TestItem(name: '同步离线订单', onTap: () => _testSyncOffline(context)),
            _TestItem(name: '清空订单', onTap: () => _testClearOrders(context)),
          ],
        ),
        const SizedBox(height: 16),
        _TestCategoryCard(
          title: '错误场景',
          icon: Icons.error_outline,
          color: Colors.red,
          tests: [
            _TestItem(name: '网络错误', onTap: () => _simulateNetworkError(context)),
            _TestItem(name: '服务器错误(500)', onTap: () => _simulateServerError(context)),
            _TestItem(name: '超时错误', onTap: () => _simulateTimeoutError(context)),
            _TestItem(name: '认证错误(401)', onTap: () => _simulateAuthError(context)),
          ],
        ),
        const SizedBox(height: 16),
        _TestCategoryCard(
          title: '边界测试',
          icon: Icons.border_all,
          color: Colors.orange,
          tests: [
            _TestItem(name: '空数据状态', onTap: () => _simulateEmptyData(context)),
            _TestItem(name: '大数据量(100+)', onTap: () => _simulateLargeData(context)),
            _TestItem(name: '特殊字符', onTap: () => _simulateSpecialChars(context)),
          ],
        ),
      ],
    );
  }

  // ==================== 日志标签页 ====================
  Widget _buildLogsTab(BuildContext context) {
    return const Center(
      child: Text('日志查看器\n(功能开发中...)'),
    );
  }

  // ==================== 性能标签页 ====================
  Widget _buildPerformanceTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _PerformanceCard(
          title: '性能指标',
          icon: Icons.speed,
          color: Colors.amber,
          onTap: () => _showPerformanceReport(context),
        ),
        const SizedBox(height: 16),
        _PerformanceCard(
          title: '帧率监控',
          icon: Icons.monitor_heart,
          color: Colors.red,
          onTap: () => _showFrameMetrics(context),
        ),
        const SizedBox(height: 16),
        _PerformanceCard(
          title: '内存分析',
          icon: Icons.memory,
          color: Colors.purple,
          onTap: () => _showMemoryAnalysis(context),
        ),
      ],
    );
  }

  // ==================== 设备标签页 ====================
  Widget _buildDeviceTab(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '设备信息',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _InfoRow(label: '屏幕宽度', value: '${mediaQuery.size.width.toInt()} px'),
                _InfoRow(label: '屏幕高度', value: '${mediaQuery.size.height.toInt()} px'),
                _InfoRow(label: '像素密度', value: '${mediaQuery.devicePixelRatio.toStringAsFixed(2)}x'),
                _InfoRow(label: '平台', value: Theme.of(context).platform.toString()),
                _InfoRow(label: '深色模式', value: mediaQuery.platformBrightness.toString()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== 工具标签页 ====================
  Widget _buildToolsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ToolCard(
          title: '生成测试数据',
          icon: Icons.data_array,
          color: Colors.green,
          description: '生成模拟订单和用户数据',
          onTap: () => _generateTestData(context),
        ),
        const SizedBox(height: 16),
        _ToolCard(
          title: '导出日志',
          icon: Icons.download,
          color: Colors.blue,
          description: '导出应用运行日志',
          onTap: () => _exportLogs(context),
        ),
        const SizedBox(height: 16),
        _ToolCard(
          title: '重置应用',
          icon: Icons.restore,
          color: Colors.red,
          description: '重置应用到初始状态',
          onTap: () => _resetApp(context),
        ),
        const SizedBox(height: 16),
        _ToolCard(
          title: '环境切换',
          icon: Icons.swap_horiz,
          color: Colors.orange,
          description: '切换开发/测试/生产环境',
          onTap: () => _switchEnvironment(context),
        ),
      ],
    );
  }

  // ==================== 缺失的方法实现 ====================
  void _simulateLogin(BuildContext context) {
    ShowToast.showCenterToast(context, "模拟登录功能暂不可用");
  }

  void _simulateLogout(BuildContext context) {
    ShowToast.showCenterToast(context, "模拟登出功能暂不可用");
  }

  void _toggleDarkMode(BuildContext context) {
    ShowToast.showCenterToast(context, "切换深色模式功能暂不可用");
  }

  void _clearAllData(BuildContext context) {
    ShowToast.showCenterToast(context, "清空数据功能暂不可用");
  }

  void _testApiConnection(BuildContext context) {
    ShowToast.showCenterToast(context, "测试API连接功能暂不可用");
  }

  Widget _NetworkStatsCard(BuildContext context) {
    return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text("网络统计")));
  }

  Widget _NetworkRequestsList(BuildContext context) {
    return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text("网络请求列表")));
  }

  void _showSharedPreferencesViewer(BuildContext context) {
    ShowToast.showCenterToast(context, "SharedPrefs查看器暂不可用");
  }

  void _showOfflineOrdersViewer(BuildContext context) {
    ShowToast.showCenterToast(context, "离线订单查看器暂不可用");
  }

  void _showFileSystemViewer(BuildContext context) {
    ShowToast.showCenterToast(context, "文件系统查看器暂不可用");
  }

  void _showCacheViewer(BuildContext context) {
    ShowToast.showCenterToast(context, "缓存查看器暂不可用");
  }

  void _testLoginFlow(BuildContext context) {
    ShowToast.showCenterToast(context, "测试登录流程暂不可用");
  }

  void _testLogoutFlow(BuildContext context) {
    ShowToast.showCenterToast(context, "测试登出流程暂不可用");
  }

  void _testUpdateUserInfo(BuildContext context) {
    ShowToast.showCenterToast(context, "测试更新用户信息暂不可用");
  }

  void _testLoadOrders(BuildContext context) {
    ShowToast.showCenterToast(context, "测试加载订单暂不可用");
  }

  void _testAddOrder(BuildContext context) {
    ShowToast.showCenterToast(context, "测试添加订单暂不可用");
  }

  void _testSyncOffline(BuildContext context) {
    ShowToast.showCenterToast(context, "测试同步离线暂不可用");
  }

  void _testClearOrders(BuildContext context) {
    ShowToast.showCenterToast(context, "测试清空订单暂不可用");
  }

  void _simulateNetworkError(BuildContext context) {
    ShowToast.showCenterToast(context, "模拟网络错误暂不可用");
  }

  void _simulateServerError(BuildContext context) {
    ShowToast.showCenterToast(context, "模拟服务器错误暂不可用");
  }

  void _simulateTimeoutError(BuildContext context) {
    ShowToast.showCenterToast(context, "模拟超时错误暂不可用");
  }

  void _simulateAuthError(BuildContext context) {
    ShowToast.showCenterToast(context, "模拟认证错误暂不可用");
  }

  void _simulateEmptyData(BuildContext context) {
    ShowToast.showCenterToast(context, "模拟空数据暂不可用");
  }

  void _simulateLargeData(BuildContext context) {
    ShowToast.showCenterToast(context, "模拟大数据暂不可用");
  }

  void _simulateSpecialChars(BuildContext context) {
    ShowToast.showCenterToast(context, "模拟特殊字符暂不可用");
  }

  void _showPerformanceReport(BuildContext context) {
    ShowToast.showCenterToast(context, "性能报告暂不可用");
  }

  void _showFrameMetrics(BuildContext context) {
    ShowToast.showCenterToast(context, "帧指标暂不可用");
  }

  void _showMemoryAnalysis(BuildContext context) {
    ShowToast.showCenterToast(context, "内存分析暂不可用");
  }

  void _generateTestData(BuildContext context) {
    ShowToast.showCenterToast(context, "生成测试数据暂不可用");
  }

  void _exportLogs(BuildContext context) {
    ShowToast.showCenterToast(context, "导出日志暂不可用");
  }

  void _resetApp(BuildContext context) {
    ShowToast.showCenterToast(context, "重置应用暂不可用");
  }

  void _switchEnvironment(BuildContext context) {
    ShowToast.showCenterToast(context, "切换环境暂不可用");
  }

  // ==================== 辅助组件 ====================
}

// ==================== 自定义组件 ====================

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatusItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderDetailCard extends StatelessWidget {
  const _ProviderDetailCard({
    required this.userProvider,
    required this.orderProvider,
    required this.refundProvider,
    required this.appProvider,
  }) : assert(
    userProvider != null ||
    orderProvider != null ||
    refundProvider != null ||
    appProvider != null,
  );

  final UserProvider? userProvider;
  final OrderProvider? orderProvider;
  final RefundProvider? refundProvider;
  final AppProvider? appProvider;

  String get _providerName {
    if (userProvider != null) return 'UserProvider';
    if (orderProvider != null) return 'OrderProvider';
    if (refundProvider != null) return 'RefundProvider';
    if (appProvider != null) return 'AppProvider';
    return 'Unknown';
  }

  String _getDetails() {
    if (userProvider != null) {
      return '登录: ${userProvider!.isLogin}\n'
             '用户名: ${userProvider!.user?.username ?? "N/A"}\n'
             '邮箱: ${userProvider!.user?.email ?? "N/A"}\n'
             '余额: ${userProvider!.user?.AmountSum ?? "N/A"}';
    }
    if (orderProvider != null) {
      return '订单数: ${orderProvider!.orders?.length ?? 0}\n'
             '离线订单: ${orderProvider!.offlineOrderCount}\n'
             '当前页: ${orderProvider!.currentPage}\n'
             '有更多: ${orderProvider!.hasMore}';
    }
    if (refundProvider != null) {
      return '退款数: ${refundProvider!.refunds?.length ?? 0}\n'
             '选中订单: ${refundProvider!.orders?.length ?? 0}';
    }
    if (appProvider != null) {
      return '语言: ${appProvider!.locale.languageCode}\n'
             '深色模式: ${appProvider!.isDarkMode}';
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(_providerName),
      subtitle: Text(
        _getDetails().split('\n').first,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _getDetails(),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _NetworkTestCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTest;

  const _NetworkTestCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: ElevatedButton(
          onPressed: onTest,
          child: const Text('测试'),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DataViewerCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DataViewerCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _TestCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_TestItem> tests;

  const _TestCategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.tests,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...tests.map((test) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ElevatedButton(
                onPressed: test.onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.withOpacity(0.1),
                  foregroundColor: color,
                  elevation: 0,
                ),
                child: Text(test.name),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _TestItem {
  final String name;
  final VoidCallback onTap;

  _TestItem({required this.name, required this.onTap});
}

class _PerformanceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PerformanceCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final VoidCallback onTap;

  const _ToolCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
