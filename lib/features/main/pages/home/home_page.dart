import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/features/main/pages/home/provider/order_provider.dart';
import 'package:refundo/features/main/pages/home/provider/refund_provider.dart';
import 'package:refundo/features/main/pages/home/widgets/order_widget.dart';
import 'package:refundo/features/main/pages/home/widgets/refund_widget.dart';
import 'package:refundo/features/main/pages/home/widgets/refund_confirmation_dialog.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/features/scanner/scanner_page.dart';
import 'package:refundo/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserProvider _apiLoginc;
  late double _totalAmount = 0.0;
  late double _processedAmount = 0.0;
  late int _pendingApprovalCount = 0;
  bool _isRefunding = false;
  int _currentIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _apiLoginc = Provider.of<UserProvider>(context, listen: false);
    _apiLoginc.onloginSuccess = _initAmount;
    _apiLoginc.onlogout = _loadData;
    _apiLoginc.onOrder = _loadData;
  }

  Future<void> _initAmount(double amount) async {
    setState(() {
      _totalAmount = amount;
    });
  }

  Future<void> _loadData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final OrderProvider orderProvider = Provider.of<OrderProvider>(
        context,
        listen: false,
      );
      await orderProvider.getOrders(context);
    } catch (e) {
      LogUtil.e("主页", "加载数据失败: $e");
    }
  }

  // 底部导航栏项目 - 使用多语言
  List<BottomNavigationBarItem> _getBottomNavItems(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.list_alt_rounded),
        label: l10n!.orders,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.account_balance_wallet_rounded),
        label: l10n.refunds,
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 拦截返回键事件，将应用退到后台
        if (_isRefunding) {
          // 如果在退款管理状态，先退出该状态
          setState(() {
            _isRefunding = false;
          });
          return false;
        } else {
          return false; // 阻止默认返回行为
        }
      },
      child: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final UserProvider userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );

          return Scaffold(
            appBar: _buildAppBar(context, userProvider),
            body: _buildBody(context, orderProvider),
            bottomNavigationBar: _buildBottomNavigationBar(context),
            floatingActionButton: _buildFloatingActionButton(context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }

  // 构建应用栏 - 使用多语言
  AppBar _buildAppBar(BuildContext context, UserProvider userProvider) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.app_name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      actions: _buildAppBarActions(context),
    );
  }

  // 构建应用栏操作按钮 - 使用多语言
  List<Widget> _buildAppBarActions(BuildContext context) {
    if (_currentIndex != 0) return [];

    final l10n = AppLocalizations.of(context);

    return [
      if (!_isRefunding)
        TextButton(
          onPressed: () {
            setState(() {
              _isRefunding = true;
            });
          },
          child: Text(
            l10n!.manage_orders,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      else
        Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isRefunding = false;
                });
              },
              child: Text(
                l10n!.cancel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () async {
                final RefundProvider refundProvider =
                Provider.of<RefundProvider>(context, listen: false);

                if (refundProvider.orders!.isEmpty) {
                  _showDialog(context, l10n.select_at_least_one_order);
                } else {
                  // 计算总金额
                  final Decimal totalAmount = refundProvider.allAmount();
                  final int checkState = await refundProvider.checkRefundConditions(context);
                  if(checkState != 200){
                    _handleRefundResult(checkState, l10n);
                    return;
                  }
                  // 显示退款确认悬浮窗
                  _showRefundConfirmationOverlay(
                    context: context,
                    totalAmount: totalAmount,
                    selectedCount: refundProvider.orders!.length,
                    onConfirm: (refundType,refundAccount) async {
                      // 执行退款逻辑
                      final int result = await refundProvider.Refund(context,refundType,refundAccount);
                      _handleRefundResult(result, l10n);
                    },
                  );
                }
              },
              child: Text(
                l10n.refund,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
    ];
  }

// 显示退款确认悬浮窗
  void _showRefundConfirmationOverlay({
    required BuildContext context,
    required Decimal totalAmount,
    required int selectedCount,
    required Function(int,String) onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RefundConfirmationDialog(
        totalAmount: totalAmount,
        selectedCount: selectedCount,
        onConfirm: onConfirm,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

// 处理退款结果
  void _handleRefundResult(int result, AppLocalizations l10n) {
    String message;
    bool shouldResetState = false;

    switch (result) {
      case 1:
        message = l10n.refund_success_waiting_approval;
        shouldResetState = true;
        break;
      case 0:
        message = l10n.unknown_error;
        break;
      case -1:
        message = l10n.server_error;
        break;
      case 201:
        message = l10n.order_less_than_5_months;
        break;
      case 202:
        message = l10n.total_amount_less_than_5000;
        break;
      default:
        message = l10n.error;
    }

    if (shouldResetState) {
      setState(() {
        _isRefunding = false;
      });
    }

    _showDialog(context, message);
  }


  // 构建主体内容
  Widget _buildBody(BuildContext context, OrderProvider orderProvider) {
    return Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          // 金额信息卡片
          _buildAmountCard(context),
          const SizedBox(height: 16),

          // 主内容区域
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentIndex = page;
                });
              },
              children: [
                Consumer<OrderProvider>(
                  builder: (context, refundProvider, child) {
                    return OrderWidget(
                      models: orderProvider.orders ?? [],
                      isrefunding: _isRefunding,
                    );
                  },
                ),
                Consumer<RefundProvider>(
                  builder: (context, refundProvider, child) {
                    return RefundWidget(refunds: refundProvider.refunds ?? []);
                  },
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  // 构建金额显示卡片 - 使用多语言
  Widget _buildAmountCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // 获取退款提供者以访问统计数据
    final refundProvider = Provider.of<RefundProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // 使用新的用户模型字段
    final double balance = userProvider.user?.balance ?? 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.purple.shade500],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                l10n!.total_amount,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${balance.toStringAsFixed(2)} FCFA',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          _buildStatItem(context, l10n.today_orders, refundProvider.todayRefundCount.toString()),
          _buildStatItem(context, l10n.processing, refundProvider.pendingRefundCount.toString()),
        ],
      ),
    );
  }



  // 构建统计项目 - 使用多语言
  Widget _buildStatItem(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // 构建底部导航栏 - 使用多语言
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: _getBottomNavItems(context),
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }

  // 构建悬浮扫描按钮
  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade400.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _handleScanPressed,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        child: const Icon(Icons.qr_code_scanner_rounded, size: 28),
      ),
    );
  }

  // 处理扫描按钮点击
  Future<void> _handleScanPressed() async {
    final PermissionStatus status = await Permission.camera.status;

    if (Provider.of<UserProvider>(context, listen: false).isLogin){
      if (status.isGranted) {
        _navigateToScanner(context);
      } else {
        final PermissionStatus result = await Permission.camera.request();
        if (result.isGranted) {
          _navigateToScanner(context);
        } else {
          _showPermissionDeniedDialog(context);
        }
      }
    }else{
      _showDialog(context,AppLocalizations.of(context)!.please_login_to_view_profile);
    }

  }

  // 跳转到扫描页面
  void _navigateToScanner(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ScannerPage()));
  }

  // 显示权限被拒绝的对话框 - 使用多语言
  void _showPermissionDeniedDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(
          l10n!.camera_permission_required,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(l10n.camera_permission_description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: Text(l10n.go_to_settings),
          ),
        ],
      ),
    );
  }

  // 显示通用对话框 - 使用多语言
  void _showDialog(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            l10n!.notification,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(l10n.confirm, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateTotals() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    // 使用新的balance属性替代AmountSum
    _totalAmount = provider.user?.balance ?? 0.0;
    _processedAmount = 0.0; // 重新计算已处理金额
    _pendingApprovalCount = 0; // 重新计算待审批数量
    setState(() {});
  }

  void _showUserBalanceDialog() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    // 使用新的balance属性
    final double balance = provider.user?.balance ?? 0.0;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.account_settings),
          content: Text(
            '${AppLocalizations.of(context)!.total_amount}: ${balance.toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}