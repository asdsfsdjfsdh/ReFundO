import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refundo/data/models/Product_model.dart';

/// 扫描历史记录存储服务
class ScanHistoryService {
  static const String _scanHistoryKey = 'scan_history';
  static const int _maxHistoryCount = 50; // 最多保存50条记录

  /// 保存扫描记录
  static Future<bool> saveScan(ProductModel product) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList(_scanHistoryKey) ?? [];

      // 添加到历史记录开头
      final json = jsonEncode(product.toJson());
      history.insert(0, json);

      // 限制历史记录数量
      if (history.length > _maxHistoryCount) {
        history = history.sublist(0, _maxHistoryCount);
      }

      return await prefs.setStringList(_scanHistoryKey, history);
    } catch (e) {
      print('保存扫描历史失败: $e');
      return false;
    }
  }

  /// 获取扫描历史记录
  static Future<List<ProductModel>> getScanHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList(_scanHistoryKey) ?? [];

      return history
          .map((json) => ProductModel.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('获取扫描历史失败: $e');
      return [];
    }
  }

  /// 清空扫描历史
  static Future<bool> clearScanHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_scanHistoryKey);
    } catch (e) {
      print('清空扫描历史失败: $e');
      return false;
    }
  }

  /// 删除单条记录
  static Future<bool> deleteScan(String hash) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList(_scanHistoryKey) ?? [];

      history.removeWhere((json) {
        final product = ProductModel.fromJson(jsonDecode(json));
        return product.Hash == hash;
      });

      return await prefs.setStringList(_scanHistoryKey, history);
    } catch (e) {
      print('删除扫描记录失败: $e');
      return false;
    }
  }

  /// 获取历史记录数量
  static Future<int> getScanHistoryCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList(_scanHistoryKey) ?? [];
      return history.length;
    } catch (e) {
      print('获取历史记录数量失败: $e');
      return 0;
    }
  }
}
