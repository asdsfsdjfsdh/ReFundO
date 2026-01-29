import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refundo/data/models/Product_model.dart';

/// 离线订单存储类
/// 用于在网络不可用时缓存扫码记录
class OfflineOrderStorage {
  static const String _keyOfflineOrders = 'offline_orders';
  static const int _maxOfflineOrders = 100; // 最多缓存100条

  /// 保存离线订单
  /// 返回保存是否成功
  static Future<bool> saveOfflineOrder(ProductModel product) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 获取已有的离线订单列表
      List<String> offlineOrders = prefs.getStringList(_keyOfflineOrders) ?? [];

      // 创建订单数据
      final orderData = {
        'product': product.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      // 添加到列表开头
      offlineOrders.insert(0, jsonEncode(orderData));

      // 限制最大数量
      if (offlineOrders.length > _maxOfflineOrders) {
        offlineOrders = offlineOrders.sublist(0, _maxOfflineOrders);
      }

      // 保存
      return await prefs.setStringList(_keyOfflineOrders, offlineOrders);
    } catch (e) {
      print('保存离线订单失败: $e');
      return false;
    }
  }

  /// 获取所有离线订单
  static Future<List<Map<String, dynamic>>> getOfflineOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> offlineOrders = prefs.getStringList(_keyOfflineOrders) ?? [];

      return offlineOrders.map((order) {
        return jsonDecode(order) as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('获取离线订单失败: $e');
      return [];
    }
  }

  /// 删除指定的离线订单
  static Future<bool> removeOfflineOrder(Map<String, dynamic> order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> offlineOrders = prefs.getStringList(_keyOfflineOrders) ?? [];

      // 移除指定的订单
      final orderJson = jsonEncode(order);
      offlineOrders.remove(orderJson);

      return await prefs.setStringList(_keyOfflineOrders, offlineOrders);
    } catch (e) {
      print('删除离线订单失败: $e');
      return false;
    }
  }

  /// 删除多个离线订单
  static Future<bool> removeOfflineOrders(List<Map<String, dynamic>> orders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> offlineOrders = prefs.getStringList(_keyOfflineOrders) ?? [];

      // 移除指定的订单
      final ordersToRemove = orders.map((o) => jsonEncode(o)).toSet();
      offlineOrders.removeWhere((order) => ordersToRemove.contains(order));

      return await prefs.setStringList(_keyOfflineOrders, offlineOrders);
    } catch (e) {
      print('删除离线订单失败: $e');
      return false;
    }
  }

  /// 清空所有离线订单
  static Future<bool> clearOfflineOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_keyOfflineOrders);
    } catch (e) {
      print('清空离线订单失败: $e');
      return false;
    }
  }

  /// 获取离线订单数量
  static Future<int> getOfflineOrderCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> offlineOrders = prefs.getStringList(_keyOfflineOrders) ?? [];
      return offlineOrders.length;
    } catch (e) {
      print('获取离线订单数量失败: $e');
      return 0;
    }
  }
}
