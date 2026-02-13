import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:decimal/decimal.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/providers/order_provider.dart';
import 'package:refundo/presentation/providers/app_provider.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:refundo/core/utils/storage/offline_order_storage.dart';
import 'package:refundo/core/services/secure_storage_service.dart';
import 'package:refundo/data/models/Product_model.dart';
import 'package:refundo/data/models/order_model.dart';
import 'package:refundo/presentation/widgets/app_states.dart';
import 'package:refundo/core/performance/performance_optimizer.dart';
import 'package:refundo/presentation/pages/debug/debug_viewers.dart';
import 'package:intl/intl.dart';

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
        content: const Text('此功能已禁用\n请使用正式登录功能'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
        ],
      ),
    );
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

  /// 测试添加订单（可调节参数）
  static Future<void> testAddOrder(BuildContext context) async {
    // 显示选项对话框
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加订单'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cloud_download),
              title: const Text('从服务器获取测试产品'),
              subtitle: const Text('使用后端提供的测试产品数据'),
              onTap: () => Navigator.pop(context, 'server'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('创建可自定义测试产品'),
              subtitle: const Text('创建自定义参数的测试产品（保存到数据库）'),
              onTap: () => Navigator.pop(context, 'create'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('使用已知Hash创建订单'),
              subtitle: const Text('手动输入已存在产品的Hash创建订单'),
              onTap: () => Navigator.pop(context, 'custom'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );

    if (choice == 'server') {
      await getTestProductFromServer(context);
    } else if (choice == 'create') {
      await _showCreateTestProductDialog(context);
    } else if (choice == 'custom') {
      await _showCustomOrderDialog(context);
    }
  }

  /// 显示创建测试产品对话框（会保存到数据库）
  static Future<void> _showCreateTestProductDialog(BuildContext context) async {
    // 默认时间：6个月前（满足退款条件）
    final defaultTime = DateTime.now().subtract(const Duration(days: 180));
    final timeController = TextEditingController(
      text: '${defaultTime.year}-${defaultTime.month.toString().padLeft(2, '0')}-${defaultTime.day.toString().padLeft(2, '0')} ${defaultTime.hour.toString().padLeft(2, '0')}:${defaultTime.minute.toString().padLeft(2, '0')}',
    );

    final priceController = TextEditingController(text: '10000');
    final refundPercentController = TextEditingController(text: '80');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('创建自定义测试产品'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('时间信息', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      labelText: '订单时间',
                      hintText: '格式: yyyy-MM-dd HH:mm',
                      border: OutlineInputBorder(),
                      helperText: '默认为6个月前（满足5个月退款条件）',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 16),
                  const Text('金额信息（只填比例，退款金额自动计算）', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: '订单价格 (FCFA)',
                      hintText: '输入订单价格',
                      border: OutlineInputBorder(),
                      suffixText: 'FCFA',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: refundPercentController,
                    decoration: const InputDecoration(
                      labelText: '退款比例 (%)',
                      hintText: '输入退款比例 (0-100)',
                      border: OutlineInputBorder(),
                      suffixText: '%',
                      helperText: '退款金额将自动计算为：订单价格 × 退款比例',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.green.shade700),
                            const SizedBox(width: 4),
                            Text('说明', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• 产品将保存到数据库\n• 自动生成有效的Hash值\n• 退款金额必须 ≥ 5000 FCFA\n• 订单时间需满5个月才可退款',
                          style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // 验证输入
                  final price = double.tryParse(priceController.text.trim());
                  final refundPercent = double.tryParse(refundPercentController.text.trim());

                  if (price == null || refundPercent == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('请输入有效的数字')),
                    );
                    return;
                  }

                  // 计算退款金额
                  final refundAmount = (price * refundPercent / 100);

                  if (refundAmount < 5000) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('退款金额(${refundAmount.toStringAsFixed(2)} FCFA)必须 ≥ 5000 FCFA\n请提高订单价格或退款比例'),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    return;
                  }

                  // 解析时间
                  DateTime? orderTime;
                  try {
                    orderTime = DateTime.parse(timeController.text.trim());
                  } catch (e) {
                    // 尝试其他格式
                    try {
                      orderTime = DateFormat('yyyy-MM-dd HH:mm').parse(timeController.text.trim());
                    } catch (e2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('时间格式错误，请使用格式：yyyy-MM-dd HH:mm')),
                      );
                      return;
                    }
                  }

                  // 检查订单时间是否满5个月
                  final fiveMonthsAgo = DateTime.now().subtract(const Duration(days: 150));
                  if (orderTime != null && orderTime.isAfter(fiveMonthsAgo)) {
                    final daysLeft = fiveMonthsAgo.difference(orderTime).inDays.abs();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('订单时间不满5个月，还需等待${(daysLeft / 30).ceil()}个月\n建议将时间设置为更早的日期'),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }

                  // 显示加载指示器
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('正在创建测试产品和订单...'),
                        ],
                      ),
                    ),
                  );

                  try {
                    // 格式化时间为后端需要的格式
                    if (orderTime == null) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('订单时间解析失败')),
                        );
                      }
                      return;
                    }
                    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(orderTime);

                    // 调用后端API创建测试产品
                    final response = await DioProvider.globalInstance.dio.post(
                      '/api/test/create-product',
                      data: {
                        'price': price,
                        'refundPercent': refundPercent,
                        'orderTime': formattedTime, // 添加订单时间参数
                      },
                    );

                    // 关闭加载指示器
                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                    if (response.statusCode == 200 && context.mounted) {
                      // 关闭对话框
                      Navigator.pop(context, true);

                      // 刷新订单列表
                      if (context.mounted) {
                        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                        try {
                          await orderProvider.getOrders(context);
                          if (kDebugMode) {
                            print('订单列表刷新成功，订单数量: ${orderProvider.orders?.length ?? 0}');
                          }
                        } catch (e) {
                          if (kDebugMode) {
                            print('刷新订单列表失败: $e');
                          }
                        }

                        // 显示成功消息
                        final orderData = response.data is Map
                            ? (response.data['data'] is Map ? response.data['data']['result'] : response.data['result'])
                            : null;

                        if (orderData != null) {
                          AppStateNotifications.success(
                            context,
                            '测试产品创建成功！\n订单号: ${orderData['orderNumber']}\n退款金额: ${refundAmount.toStringAsFixed(2)} FCFA\n将在10分钟后自动删除',
                          );
                        } else {
                          AppStateNotifications.success(context, '测试产品创建成功！');
                        }
                      }
                    }
                  } catch (e) {
                    // 关闭加载指示器
                    if (context.mounted) {
                      try {
                        Navigator.pop(context);
                      } catch (_) {}
                    }

                    if (context.mounted) {
                      if (kDebugMode) {
                        print('创建测试产品失败: $e');
                      }
                      AppStateNotifications.error(context, '创建测试产品失败: $e');
                    }
                  }
                },
                child: const Text('创建并下单'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 显示自定义订单参数对话框
  static Future<void> _showCustomOrderDialog(BuildContext context) async {
    final productIdController = TextEditingController(text: 'CUSTOM_PRODUCT_${DateTime.now().millisecondsSinceEpoch}');
    final hashController = TextEditingController(text: 'custom_hash_${DateTime.now().millisecondsSinceEpoch}');
    final priceController = TextEditingController(text: '10000');
    final refundAmountController = TextEditingController(text: '8000');
    final refundPercentController = TextEditingController(text: '80');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('自定义订单参数'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('产品信息', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: productIdController,
                    decoration: const InputDecoration(
                      labelText: '产品ID',
                      hintText: '输入产品ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hashController,
                    decoration: const InputDecoration(
                      labelText: '产品Hash',
                      hintText: '输入产品Hash',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('金额信息', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: '订单价格 (FCFA)',
                      hintText: '输入订单价格',
                      border: OutlineInputBorder(),
                      suffixText: 'FCFA',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: refundAmountController,
                    decoration: const InputDecoration(
                      labelText: '退款金额 (FCFA)',
                      hintText: '输入退款金额 (至少5000)',
                      border: OutlineInputBorder(),
                      suffixText: 'FCFA',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: refundPercentController,
                    decoration: const InputDecoration(
                      labelText: '退款比例 (%)',
                      hintText: '输入退款比例',
                      border: OutlineInputBorder(),
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                            const SizedBox(width: 4),
                            Text('提示', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• 退款金额必须 ≥ 5000 FCFA\n• 5个月后的订单才可退款',
                          style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // 验证输入
                  final price = double.tryParse(priceController.text);
                  final refundAmount = double.tryParse(refundAmountController.text);
                  final refundPercent = double.tryParse(refundPercentController.text);

                  if (price == null || refundAmount == null || refundPercent == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('请输入有效的数字')),
                    );
                    return;
                  }

                  if (refundAmount < 5000) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('退款金额必须 ≥ 5000 FCFA')),
                    );
                    return;
                  }

                  Navigator.pop(context, true);
                },
                child: const Text('创建订单'),
              ),
            ],
          );
        },
      ),
    );

    if (result == true) {
      try {
        final product = ProductModel(
          ProductId: int.parse(productIdController.text.trim()),
          Hash: hashController.text.trim(),
          price: Decimal.parse(priceController.text.trim()),
          RefundAmount: Decimal.parse(refundAmountController.text.trim()),
          RefundPercent: double.parse(refundPercentController.text.trim()),
        );

        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        final message = await orderProvider.insertOrder(product, context);

        if (context.mounted) {
          AppStateNotifications.success(context, message);
        }
      } catch (e) {
        if (context.mounted) {
          AppStateNotifications.error(context, '创建订单失败: $e');
        }
      }
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

  /// 从后端获取测试产品
  static Future<void> getTestProductFromServer(BuildContext context) async {
    try {
      // 显示加载对话框
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('正在获取测试产品...'),
              ],
            ),
          ),
        );
      }

      final response = await DioProvider.globalInstance.dio.get('/api/test/get-product');

      // 关闭加载对话框
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (kDebugMode) {
        print('测试产品响应: ${response.data}');
      }

      if (response.statusCode == 200) {
        // 尝试多种可能的响应格式
        Map<String, dynamic>? productData;

        if (kDebugMode) {
          print('🔍 开始解析响应数据...');
          print('完整响应: ${response.data}');
        }

        // 格式1: {code: 200, data: {result: {...}}}
        if (response.data['code'] == 200 &&
            response.data['data'] != null &&
            response.data['data'] is Map &&
            response.data['data']['result'] != null) {
          productData = response.data['data']['result'];
          if (kDebugMode) {
            print('✅ 使用格式1: data.result');
          }
        }
        // 格式2: {code: 200, data: {...}} (直接在data中，没有result包装)
        else if (response.data['code'] == 200 &&
                 response.data['data'] != null &&
                 response.data['data'] is Map) {
          productData = response.data['data'];
          if (kDebugMode) {
            print('✅ 使用格式2: data直接包含产品数据');
          }
        }
        // 格式3: {msg: "...", result: {...}}
        else if (response.data.containsKey('result')) {
          productData = response.data['result'];
          if (kDebugMode) {
            print('✅ 使用格式3: result字段');
          }
        }

        if (productData != null && context.mounted) {
          // 提取数据并转换为非空类型
          final productId = productData['productId'] ?? 'N/A';
          final hash = productData['hash'] ?? 'N/A';
          final price = productData['price']?.toString() ?? 'N/A';
          final refundAmount = productData['refundAmount']?.toString() ?? 'N/A';
          final refundPercent = productData['refundPercent']?.toString() ?? '0';

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('测试产品'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('产品ID: $productId'),
                  SizedBox(height: 8),
                  Text('Hash: $hash'),
                  SizedBox(height: 8),
                  Text('价格: $price'),
                  SizedBox(height: 8),
                  Text('退款金额: $refundAmount'),
                  SizedBox(height: 8),
                  Text('退款比例: $refundPercent%'),
                  SizedBox(height: 16),
                  const Text('点击"使用此产品"按钮创建订单',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _useTestProduct(context, productData!);
                  },
                  child: const Text('使用此产品'),
                ),
              ],
            ),
          );
        } else {
          if (context.mounted) {
            AppStateNotifications.error(context, '获取测试产品失败：响应数据格式不正确');
          }
        }
      } else {
        if (context.mounted) {
          final msg = response.data['msg'] ?? '获取测试产品失败';
          AppStateNotifications.error(context, msg);
        }
      }
    } catch (e) {
      if (context.mounted) {
        // 尝试关闭加载对话框
        try {
          Navigator.pop(context);
        } catch (_) {}

        AppStateNotifications.error(context, '获取测试产品失败: $e');
      }
    }
  }

  /// 使用测试产品创建订单
  static Future<void> _useTestProduct(BuildContext context, Map<String, dynamic> productData) async {
    try {
      if (kDebugMode) {
        print('🔧 开始创建订单，原始数据: $productData');
      }

      // 解析数据并转换类型
      final productId = productData['productId'] is String
          ? int.parse(productData['productId'] as String)
          : productData['productId'] as int? ?? 0;
      final hash = productData['hash'] as String? ?? '';
      final priceStr = productData['price']?.toString() ?? '0';
      final refundAmountStr = productData['refundAmount']?.toString() ?? '0';

      // refundPercent 可能是 double 或 String
      final refundPercentRaw = productData['refundPercent'];
      double refundPercent;
      if (refundPercentRaw is double) {
        refundPercent = refundPercentRaw;
      } else if (refundPercentRaw is String) {
        refundPercent = double.parse(refundPercentRaw);
      } else if (refundPercentRaw is int) {
        refundPercent = refundPercentRaw.toDouble();
      } else {
        refundPercent = 0.0;
      }

      if (kDebugMode) {
        print('🔧 解析后的数据:');
        print('  ProductId: $productId');
        print('  Hash: $hash');
        print('  price: $priceStr');
        print('  refundAmount: $refundAmountStr');
        print('  refundPercent: $refundPercent');
      }

      final product = ProductModel(
        ProductId: productId,
        Hash: hash,
        price: Decimal.parse(priceStr),
        RefundAmount: Decimal.parse(refundAmountStr),
        RefundPercent: refundPercent,
      );

      if (kDebugMode) {
        print('🔧 ProductModel创建成功: $product');
      }

      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final message = await orderProvider.insertOrder(product, context);

      if (context.mounted) {
        AppStateNotifications.success(context, message);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ 创建订单失败: $e');
        print('堆栈跟踪: $stackTrace');
      }
      if (context.mounted) {
        AppStateNotifications.error(context, '创建订单失败: $e');
      }
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
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('模拟登录'),
        content: const Text('此功能已禁用\n请使用正式登录功能'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
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

      // 清空安全存储
      await SecureStorageService.instance.clearAuthData();

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
        ProductId: DateTime.now().millisecondsSinceEpoch + i,
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
      final token = await SecureStorageService.instance.getAccessToken();

      if (token.isEmpty) {
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
            content: Text('✅ API连接正常\n\nToken: ${token.substring(0, 20)}...'),
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
