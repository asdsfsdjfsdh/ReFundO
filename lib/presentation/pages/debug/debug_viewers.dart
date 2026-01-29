import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refundo/core/utils/storage/offline_order_storage.dart';
import 'package:refundo/data/models/order_model.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

/// SharedPreferences 查看器
class SharedPreferencesViewer extends StatefulWidget {
  const SharedPreferencesViewer({super.key});

  @override
  State<SharedPreferencesViewer> createState() => _SharedPreferencesViewerState();
}

class _SharedPreferencesViewerState extends State<SharedPreferencesViewer> {
  Map<String, dynamic> _prefs = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final data = <String, dynamic>{};

      for (final key in keys) {
        final value = prefs.get(key);
        data[key] = value;
      }

      setState(() {
        _prefs = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrefs,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearAll,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _prefs.isEmpty
              ? const Center(child: Text('暂无数据'))
              : ListView.builder(
                  itemCount: _prefs.length,
                  itemBuilder: (context, index) {
                    final key = _prefs.keys.elementAt(index);
                    final value = _prefs[key];
                    return ListTile(
                      leading: const Icon(Icons.key, color: Colors.purple),
                      title: Text(key, style: const TextStyle(fontFamily: 'monospace')),
                      subtitle: Text(
                        value.toString(),
                        style: const TextStyle(fontFamily: 'monospace'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteItem(key),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _deleteItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    _loadPrefs();
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认'),
        content: const Text('确定要清空所有数据吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _loadPrefs();
    }
  }
}

/// 离线订单查看器
class OfflineOrdersViewer extends StatefulWidget {
  const OfflineOrdersViewer({super.key});

  @override
  State<OfflineOrdersViewer> createState() => _OfflineOrdersViewerState();
}

class _OfflineOrdersViewerState extends State<OfflineOrdersViewer> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await OfflineOrderStorage.getOfflineOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('离线订单 (${_orders.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
          if (_orders.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAll,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('暂无离线订单'))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final orderData = _orders[index];
                    final product = orderData['product'];
                    final timestamp = orderData['timestamp'];

                    return ExpansionTile(
                      leading: const Icon(Icons.cloud_off, color: Colors.orange),
                      title: Text('订单 #${index + 1}'),
                      subtitle: Text(
                        timestamp.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DetailRow('产品ID', product['ProductId']?.toString() ?? 'N/A'),
                              _DetailRow('哈希', product['Hash']?.toString() ?? 'N/A'),
                              _DetailRow('价格', '${product['price'] ?? 'N/A'} FCFA'),
                              _DetailRow('退款金额', '${product['RefundAmount'] ?? 'N/A'} FCFA'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteOrder(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.upload),
                                    onPressed: () => _syncOrder(context, orderData),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }

  Future<void> _deleteOrder(int index) async {
    // 实现删除单个离线订单
    _loadOrders();
  }

  Future<void> _syncOrder(BuildContext context, Map<String, dynamic> orderData) async {
    // 实现同步单个订单
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('同步功能开发中...')),
    );
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认'),
        content: const Text('确定要清空所有离线订单吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await OfflineOrderStorage.clearOfflineOrders();
      _loadOrders();
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 缓存查看器
class CacheViewer extends StatelessWidget {
  const CacheViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final dioProvider = Provider.of<DioProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('网络缓存'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              dioProvider.clearCache();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已清理')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('缓存说明'),
              subtitle: const Text(
                'Dio 缓存会自动缓存GET请求的响应\n'
                '缓存时间：5分钟\n'
                '可缓存的路径：/api/orders/init, /api/user/info',
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('缓存状态'),
              subtitle: const Text('缓存已启用'),
              trailing: TextButton(
                onPressed: () {
                  dioProvider.clearCache();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('缓存已清理')),
                  );
                },
                child: const Text('清理'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 文件系统查看器
class FileSystemViewer extends StatefulWidget {
  const FileSystemViewer({super.key});

  @override
  State<FileSystemViewer> createState() => _FileSystemViewerState();
}

class _FileSystemViewerState extends State<FileSystemViewer> {
  List<FileSystemEntity> _entities = [];
  bool _isLoading = true;
  String _currentPath = '';

  @override
  void initState() {
    super.initState();
    _loadDirectory();
  }

  Future<void> _loadDirectory([String? path]) async {
    setState(() => _isLoading = true);
    try {
      Directory directory;
      if (path != null) {
        directory = Directory(path);
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      _currentPath = directory.path;

      final entities = directory.listSync();
      entities.sort((a, b) => a.path.compareTo(b.path));

      setState(() {
        _entities = entities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('文件系统'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadDirectory(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              '当前路径: $_currentPath',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _entities.isEmpty
                    ? const Center(child: Text('目录为空'))
                    : ListView.builder(
                        itemCount: _entities.length,
                        itemBuilder: (context, index) {
                          final entity = _entities[index];
                          final name = entity.path.split('/').last;
                          final isDirectory = entity is Directory;

                          return ListTile(
                            leading: Icon(
                              isDirectory ? Icons.folder : Icons.insert_drive_file,
                              color: isDirectory ? Colors.blue : Colors.grey,
                            ),
                            title: Text(name),
                            subtitle: Text(
                              entity.path,
                              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              if (isDirectory) {
                                _loadDirectory(entity.path);
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
