import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/presentation/providers/app_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/presentation/pages/debug/debug_test_tools.dart';
import 'package:refundo/presentation/pages/debug/debug_viewers.dart';
import 'package:refundo/core/utils/network_logger.dart';
import 'package:refundo/core/utils/widget_tree_inspector.dart';

/// 完整的高级调试面板
/// 包含10个主要功能标签页
class CompleteDebugPanelPage extends StatefulWidget {
  const CompleteDebugPanelPage({super.key});

  @override
  State<CompleteDebugPanelPage> createState() => _CompleteDebugPanelPageState();
}

class _CompleteDebugPanelPageState extends State<CompleteDebugPanelPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('高级调试面板'),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
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
            Tab(text: '网络日志', icon: Icon(Icons.network_check)),
            Tab(text: 'Widget', icon: Icon(Icons.account_tree)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatusTab(),
          _buildNetworkTab(),
          _buildDataTab(),
          _buildTestTab(),
          _buildLogsTab(),
          _buildPerformanceTab(),
          _buildDeviceTab(),
          _buildToolsTab(),
          _buildNetworkLogTab(),
          _buildWidgetTreeTab(),
        ],
      ),
    );
  }

  // ==================== 状态标签页 ====================
  Widget _buildStatusTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _QuickActionCard(
          title: '快速操作',
          actions: [
            _Action(
              icon: Icons.login,
              label: '模拟登录',
              color: Colors.green,
              onTap: () => DebugTestTools.simulateLogin(context),
            ),
            _Action(
              icon: Icons.logout,
              label: '模拟登出',
              color: Colors.red,
              onTap: () => DebugTestTools.simulateLogout(context),
            ),
            _Action(
              icon: Icons.dark_mode,
              label: '切换深色',
              color: Colors.indigo,
              onTap: () => DebugTestTools.toggleDarkMode(context),
            ),
            _Action(
              icon: Icons.delete_sweep,
              label: '清空数据',
              color: Colors.orange,
              onTap: () => DebugTestTools.clearAllData(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ProviderStatusCard(),
      ],
    );
  }

  // ==================== 网络标签页 ====================
  Widget _buildNetworkTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TestCard(
          title: 'API 连接测试',
          icon: Icons.wifi,
          color: Colors.blue,
          description: '测试与后端服务器的连接状态',
          onTap: () => DebugTestTools.testApiConnection(context),
        ),
        const SizedBox(height: 16),
        _TestCard(
          title: '网络缓存管理',
          icon: Icons.cached,
          color: Colors.teal,
          description: '查看和清理网络请求缓存',
          onTap: () => DebugTestTools.showCacheViewer(context),
        ),
      ],
    );
  }

  // ==================== 数据标签页 ====================
  Widget _buildDataTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TestCard(
          title: 'SharedPreferences',
          icon: Icons.key,
          color: Colors.purple,
          description: '查看和管理本地存储数据',
          onTap: () => DebugTestTools.showSharedPreferencesViewer(context),
        ),
        const SizedBox(height: 16),
        _TestCard(
          title: '离线订单数据',
          icon: Icons.cloud_off,
          color: Colors.orange,
          description: '查看和管理离线缓存的订单',
          onTap: () => DebugTestTools.showOfflineOrdersViewer(context),
        ),
        const SizedBox(height: 16),
        _TestCard(
          title: '应用文件系统',
          icon: Icons.folder,
          color: Colors.blue,
          description: '浏览应用文档目录',
          onTap: () => DebugTestTools.showFileSystemViewer(context),
        ),
      ],
    );
  }

  // ==================== 测试标签页 ====================
  Widget _buildTestTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TestCategory(
          title: '用户功能测试',
          icon: Icons.person,
          color: Colors.blue,
          tests: [
            _TestItem(
              name: '登录流程',
              onTap: () => DebugTestTools.testLoginFlow(context),
            ),
            _TestItem(
              name: '登出流程',
              onTap: () => DebugTestTools.testLogoutFlow(context),
            ),
            _TestItem(
              name: '更新用户信息',
              onTap: () => DebugTestTools.testUpdateUserInfo(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _TestCategory(
          title: '订单功能测试',
          icon: Icons.list_alt,
          color: Colors.green,
          tests: [
            _TestItem(
              name: '加载订单',
              onTap: () => DebugTestTools.testLoadOrders(context),
            ),
            _TestItem(
              name: '添加测试订单',
              onTap: () => DebugTestTools.testAddOrder(context),
            ),
            _TestItem(
              name: '同步离线订单',
              onTap: () => DebugTestTools.testSyncOffline(context),
            ),
            _TestItem(
              name: '清空订单',
              onTap: () => DebugTestTools.testClearOrders(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _TestCategory(
          title: '错误场景模拟',
          icon: Icons.error_outline,
          color: Colors.red,
          tests: [
            _TestItem(
              name: '网络错误',
              onTap: () => DebugTestTools.simulateNetworkError(context),
            ),
            _TestItem(
              name: '服务器错误(500)',
              onTap: () => DebugTestTools.simulateServerError(context),
            ),
            _TestItem(
              name: '超时错误',
              onTap: () => DebugTestTools.simulateTimeoutError(context),
            ),
            _TestItem(
              name: '认证错误(401)',
              onTap: () => DebugTestTools.simulateAuthError(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _TestCategory(
          title: '边界测试',
          icon: Icons.border_all,
          color: Colors.orange,
          tests: [
            _TestItem(
              name: '空数据状态',
              onTap: () => DebugTestTools.simulateEmptyData(context),
            ),
            _TestItem(
              name: '大数据量(100+)',
              onTap: () => DebugTestTools.simulateLargeData(context),
            ),
            _TestItem(
              name: '特殊字符',
              onTap: () => DebugTestTools.simulateSpecialChars(context),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== 日志标签页 ====================
  Widget _buildLogsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            '日志查看器',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            '日志已输出到控制台\n使用 Flutter DevTools 查看',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ==================== 性能标签页 ====================
  Widget _buildPerformanceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TestCard(
          title: '性能报告',
          icon: Icons.assessment,
          color: Colors.amber,
          description: '查看应用性能统计和最慢操作',
          onTap: () => DebugTestTools.showPerformanceReport(context),
        ),
        const SizedBox(height: 16),
        _TestCard(
          title: '帧率监控',
          icon: Icons.monitor_heart,
          color: Colors.red,
          description: '查看帧率信息和慢帧检测',
          onTap: () => DebugTestTools.showFrameMetrics(context),
        ),
        const SizedBox(height: 16),
        _TestCard(
          title: '内存分析',
          icon: Icons.memory,
          color: Colors.purple,
          description: '查看内存使用情况',
          onTap: () => DebugTestTools.showMemoryAnalysis(context),
        ),
      ],
    );
  }

  // ==================== 设备标签页 ====================
  Widget _buildDeviceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DeviceInfoCard(),
      ],
    );
  }

  // ==================== 工具标签页 ====================
  Widget _buildToolsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TestCard(
          title: '生成测试数据',
          icon: Icons.data_array,
          color: Colors.green,
          description: '生成模拟订单和用户数据用于测试',
          onTap: () => DebugTestTools.generateTestData(context),
        ),
        const SizedBox(height: 16),
        _TestCard(
          title: '导出日志',
          icon: Icons.download,
          color: Colors.blue,
          description: '导出应用运行日志',
          onTap: () => DebugTestTools.exportLogs(context),
        ),
        const SizedBox(height: 16),
        _TestCard(
          title: '重置应用',
          icon: Icons.restore,
          color: Colors.red,
          description: '重置应用到初始状态',
          onTap: () => DebugTestTools.resetApp(context),
        ),
        const SizedBox(height: 16),
        _TestCard(
          title: '环境切换',
          icon: Icons.swap_horiz,
          color: Colors.orange,
          description: '切换开发/测试/生产环境',
          onTap: () => DebugTestTools.switchEnvironment(context),
        ),
      ],
    );
  }

  // ==================== 网络日志标签页 ====================
  Widget _buildNetworkLogTab() {
    return const NetworkLoggerViewer();
  }

  // ==================== Widget 树标签页 ====================
  Widget _buildWidgetTreeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TestCard(
          title: '网络请求火焰图',
          icon: Icons.fireplace,
          color: Colors.orange,
          description: '查看帧率性能和火焰图分析',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FlameGraphViewer()),
            );
          },
        ),
        const SizedBox(height: 16),
        _TestCard(
          title: 'Widget 树检查器',
          icon: Icons.account_tree,
          color: Colors.blue,
          description: '查看和检查 Widget 树结构',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WidgetTreeViewer()),
            );
          },
        ),
      ],
    );
  }

  // ==================== 辅助组件 ====================

  Widget _ProviderStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider 状态',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ProviderTile(
              providerName: 'UserProvider',
              provider: Provider.of<UserProvider>(context),
            ),
            const Divider(),
            _ProviderTile(
              providerName: 'OrderProvider',
              provider: Provider.of<OrderProvider>(context),
            ),
            const Divider(),
            _ProviderTile(
              providerName: 'RefundProvider',
              provider: Provider.of<RefundProvider>(context),
            ),
            const Divider(),
            _ProviderTile(
              providerName: 'AppProvider',
              provider: Provider.of<AppProvider>(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ProviderTile({required String providerName, required dynamic provider}) {
    String status = '';
    List<String> details = [];

    if (provider is UserProvider) {
      final p = provider as UserProvider;
      status = p.isLogin ? '已登录' : '未登录';
      details = [
        '用户: ${p.user?.username ?? "N/A"}',
        '余额: ${p.user?.AmountSum ?? "N/A"}',
      ];
    } else if (provider is OrderProvider) {
      final p = provider as OrderProvider;
      status = '${p.orders?.length ?? 0} 条订单';
      details = [
        '离线订单: ${p.offlineOrderCount}',
        '当前页: ${p.currentPage}',
        '有更多: ${p.hasMore}',
      ];
    } else if (provider is RefundProvider) {
      final p = provider as RefundProvider;
      status = '${p.refunds?.length ?? 0} 条退款';
      details = [
        '选中: ${p.orders?.length ?? 0} 条',
      ];
    } else if (provider is AppProvider) {
      final p = provider as AppProvider;
      status = p.locale.languageCode;
      details = [
        '深色模式: ${p.isDarkMode ? "开启" : "关闭"}',
      ];
    }

    return ExpansionTile(
      title: Text(providerName),
      subtitle: Text(status),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: details
                .map((detail) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(detail, style: const TextStyle(fontSize: 12)),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ==================== 自定义组件 ====================

class _QuickActionCard extends StatelessWidget {
  final String title;
  final List<_Action> actions;

  const _QuickActionCard({
    required this.title,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: actions
                  .map((action) => ElevatedButton.icon(
                        onPressed: action.onTap,
                        icon: Icon(action.icon),
                        label: Text(action.label),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: action.color.withOpacity(0.1),
                          foregroundColor: action.color,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Action {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _Action({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _TestCategory extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_TestItem> tests;

  const _TestCategory({
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

class _TestCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final VoidCallback onTap;

  const _TestCard({
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

class _DeviceInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Card(
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
            _InfoRow('屏幕宽度', '${mediaQuery.size.width.toInt()} px'),
            _InfoRow('屏幕高度', '${mediaQuery.size.height.toInt()} px'),
            _InfoRow('像素密度', '${mediaQuery.devicePixelRatio.toStringAsFixed(2)}x'),
            _InfoRow('平台', Theme.of(context).platform.toString()),
            _InfoRow('深色模式', mediaQuery.platformBrightness.toString()),
            _InfoRow('Padding', mediaQuery.padding.toString()),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}
