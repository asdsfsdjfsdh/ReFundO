import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';
import 'package:intl/intl.dart';

/// 网络请求日志条目
class NetworkLogEntry {
  final String id;
  final DateTime timestamp;
  final String method;
  final String url;
  final Map<String, dynamic> headers;
  final dynamic body;
  final int? statusCode;
  final String? statusMessage;
  final dynamic responseData;
  final int duration; // 毫秒
  final bool isError;

  NetworkLogEntry({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.url,
    required this.headers,
    this.body,
    this.statusCode,
    this.statusMessage,
    this.responseData,
    required this.duration,
    this.isError = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'method': method,
      'url': url,
      'headers': headers,
      'body': body,
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'responseData': responseData,
      'duration': duration,
      'isError': isError,
    };
  }

  factory NetworkLogEntry.fromJson(Map<String, dynamic> json) {
    return NetworkLogEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      method: json['method'] as String,
      url: json['url'] as String,
      headers: Map<String, dynamic>.from(json['headers'] as Map),
      body: json['body'],
      statusCode: json['statusCode'] as int?,
      statusMessage: json['statusMessage'] as String?,
      responseData: json['responseData'],
      duration: json['duration'] as int,
      isError: json['isError'] as bool? ?? false,
    );
  }

  String get formattedDuration {
    if (duration < 1000) {
      return '${duration}ms';
    }
    return '${(duration / 1000).toStringAsFixed(2)}s';
  }

  Color get statusColor {
    if (isError) return Colors.red;
    if (statusCode == null) return Colors.grey;
    if (statusCode! >= 200 && statusCode! < 300) return Colors.green;
    if (statusCode! >= 300 && statusCode! < 400) return Colors.orange;
    if (statusCode! >= 400 && statusCode! < 500) return Colors.deepOrange;
    return Colors.red;
  }
}

/// 网络请求拦截器
class NetworkLogger extends Interceptor {
  final List<NetworkLogEntry> _logs = [];
  final int maxLogs = 500;
  final Map<String, int> _requestCounts = {};
  static NetworkLogger? _instance;

  static NetworkLogger get instance => _instance ??= NetworkLogger._();

  NetworkLogger._();

  List<NetworkLogEntry> get logs => _logs.toList();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    // 记录请求统计
    final key = '${options.method}:${options.uri.path}';
    _requestCounts[key] = (_requestCounts[key] ?? 0) + 1;

    // 详细日志：打印请求信息
    if (kDebugMode) {
      debugPrint('========================================');
      debugPrint('🌐 [REQUEST] ${options.method} ${options.uri.path}');
      debugPrint('Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('Request Body: ${options.data}');
        debugPrint('Request Body Type: ${options.data.runtimeType}');
      }
      if (options.queryParameters.isNotEmpty) {
        debugPrint('Query Parameters: ${options.queryParameters}');
      }
      debugPrint('========================================');
    }

    // 继续请求
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 详细日志：打印响应信息
    if (kDebugMode) {
      debugPrint('========================================');
      debugPrint('✅ [RESPONSE] ${response.requestOptions.method} ${response.requestOptions.uri.path}');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');
      debugPrint('Response Data Type: ${response.data.runtimeType}');
      debugPrint('========================================');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 详细日志：打印错误信息
    if (kDebugMode) {
      debugPrint('========================================');
      debugPrint('❌ [ERROR] ${err.requestOptions.method} ${err.requestOptions.uri.path}');
      debugPrint('Error Type: ${err.type}');
      debugPrint('Error Message: ${err.message}');
      if (err.response != null) {
        debugPrint('Error Status Code: ${err.response?.statusCode}');
        debugPrint('Error Response Data: ${err.response?.data}');
      }
      if (err.requestOptions.data != null) {
        debugPrint('Request Body that caused error: ${err.requestOptions.data}');
      }
      debugPrint('========================================');
    }

    handler.next(err);
  }

  void _addLog(NetworkLogEntry log) {
    _logs.insert(0, log);

    // 限制日志数量
    if (_logs.length > maxLogs) {
      _logs.removeRange(maxLogs ~/ 2, _logs.length);
    }
  }

  void clear() {
    _logs.clear();
    _requestCounts.clear();
  }

  Map<String, int> getRequestStats() {
    return Map.from(_requestCounts);
  }

  List<NetworkLogEntry> getFailedRequests() {
    return _logs.where((log) => log.isError).toList();
  }

  List<NetworkLogEntry> getSlowRequests({int thresholdMs = 1000}) {
    return _logs.where((log) => log.duration >= thresholdMs).toList();
  }

  /// 导出为JSON
  String exportToJson() {
    final json = {
      'timestamp': DateTime.now().toIso8601String(),
      'requestStats': _requestCounts,
      'logs': _logs.map((log) => log.toJson()).toList(),
    };
    return JsonEncoder.withIndent('  ').convert(json);
  }

  /// 从JSON导入
  void importFromJson(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _requestCounts.clear();
      (json['requestStats'] as Map<String, dynamic>).forEach((key, value) {
        _requestCounts[key] = value as int;
      });

      _logs.clear();
      (json['logs'] as List).forEach((logJson) {
        _logs.add(NetworkLogEntry.fromJson(logJson as Map<String, dynamic>));
      });
    } catch (e) {
      print('导入日志失败: $e');
    }
  }
}

/// 网络日志查看器
class NetworkLoggerViewer extends StatefulWidget {
  const NetworkLoggerViewer({super.key});

  @override
  State<NetworkLoggerViewer> createState() => _NetworkLoggerViewerState();
}

class _NetworkLoggerViewerState extends State<NetworkLoggerViewer> {
  final NetworkLogger _logger = NetworkLogger.instance;
  String _searchQuery = '';
  bool _showOnlyErrors = false;
  String _filter = 'all'; // all, success, error

  @override
  Widget build(BuildContext context) {
    final logs = _getFilteredLogs();

    return Scaffold(
      appBar: AppBar(
        title: Text('网络日志 (${_logger.logs.length})'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: '筛选',
            itemBuilder: (context) {
              return [
                const PopupMenuItem(value: 'all', child: Text('全部请求')),
                const PopupMenuItem(value: 'success', child: Text('仅成功')),
                const PopupMenuItem(value: 'error', child: Text('仅错误')),
                const PopupMenuDivider(),
                const PopupMenuItem(value: 'export', child: Text('导出日志')),
                const PopupMenuItem(value: 'import', child: Text('导入日志')),
                const PopupMenuItem(value: 'clear', child: Text('清空日志', style: TextStyle(color: Colors.red))),
              ];
            },
            onSelected: (value) {
              _handleMenuAction(value);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatsBar(),
          Expanded(
            child: logs.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return _LogEntryTile(
                        log: log,
                        onTap: () => _showLogDetail(context, log),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<NetworkLogEntry> _getFilteredLogs() {
    var logs = _logger.logs;

    // 搜索过滤
    if (_searchQuery.isNotEmpty) {
      logs = logs.where((log) =>
        log.method.contains(_searchQuery) ||
        log.url.contains(_searchQuery) ||
        log.id.contains(_searchQuery)
      ).toList();
    }

    // 错误过滤
    if (_showOnlyErrors) {
      logs = logs.where((log) => log.isError).toList();
    }

    // 状态过滤
    if (_filter == 'success') {
      logs = logs.where((log) => !log.isError && log.statusCode != null && log.statusCode! >= 200 && log.statusCode! < 300).toList();
    } else if (_filter == 'error') {
      logs = logs.where((log) => log.isError || (log.statusCode != null && log.statusCode! >= 400)).toList();
    }

    return logs;
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索日志...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          if (_showOnlyErrors)
            IconButton(
              icon: const Icon(Icons.error_outline),
              color: Colors.red,
              tooltip: '显示全部',
              onPressed: () {
                setState(() => _showOnlyErrors = false);
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.filter_list),
              color: Colors.grey,
              tooltip: '仅错误',
              onPressed: () {
                setState(() => _showOnlyErrors = true);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    final stats = _logger.getRequestStats();
    final totalRequests = stats.values.fold(0, (a, b) => a + b);
    final failedRequests = _logger.getFailedRequests().length;
    final slowRequests = _logger.getSlowRequests().length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade100,
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _StatChip('总请求', '$totalRequests'),
          _StatChip('失败', '$failedRequests', color: Colors.red),
          _StatChip('慢请求(>1s)', '$slowRequests', color: Colors.orange),
          _StatChip('缓存命中', '${stats.values.length}'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.network_check, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            '暂无网络日志',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '网络请求会自动记录在这里',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'all':
        setState(() => _filter = 'all');
        break;
      case 'success':
        setState(() => _filter = 'success');
        break;
      case 'error':
        setState(() => _filter = 'error');
        break;
      case 'export':
        _exportLogs();
        break;
      case 'import':
        _importLogs();
        break;
      case 'clear':
        _clearLogs();
        break;
    }
  }

  void _exportLogs() {
    final jsonString = _logger.exportToJson();
    // 这里可以实现保存到文件或分享
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导出日志'),
        content: SingleChildScrollView(
          child: Text(
            jsonString,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已复制到剪贴板')),
              );
            },
            child: const Text('复制'),
          ),
        ],
      ),
    );
  }

  void _importLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导入日志'),
        content: const TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: '粘贴JSON日志',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 实现导入逻辑
              Navigator.pop(context);
            },
            child: const Text('导入'),
          ),
        ],
      ),
    );
  }

  void _clearLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空日志'),
        content: const Text('确定要清空所有网络日志吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              _logger.clear();
              Navigator.pop(context);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('确定清空'),
          ),
        ],
      ),
    );
  }

  void _showLogDetail(BuildContext context, NetworkLogEntry log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('请求详情'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow('请求时间', log.timestamp.toString()),
              _DetailRow('请求方法', log.method),
              _DetailRow('请求URL', log.url),
              _DetailRow('状态码', log.statusCode?.toString() ?? 'N/A'),
              _DetailRow('状态消息', log.statusMessage ?? 'N/A'),
              _DetailRow('耗时', log.formattedDuration),
              const Divider(),
              _DetailRow('请求头', _formatMap(log.headers)),
              if (log.body != null) _DetailRow('请求体', _formatData(log.body)),
              if (log.responseData != null) _DetailRow('响应体', _formatData(log.responseData)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: log.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('请求ID已复制')),
              );
            },
            child: const Text('复制ID'),
          ),
        ],
      ),
    );
  }

  String _formatMap(Map<String, dynamic> map) {
    if (map.isEmpty) return 'N/A';
    return map.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');
  }

  String _formatData(dynamic data) {
    if (data == null) return 'N/A';
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatChip(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: color?.withOpacity(0.1),
      avatar: Text(
        value,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
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
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  final NetworkLogEntry log;
  final VoidCallback onTap;

  const _LogEntryTile({
    required this.log,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: log.statusColor.withOpacity(0.1),
          child: Icon(
            _getStatusIcon(log),
            color: log.statusColor,
            size: 20,
          ),
        ),
        title: Text(
          log.method,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              log.url,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${log.statusCode ?? 'PENDING'} • ${log.formattedDuration}',
                  style: TextStyle(
                    fontSize: 11,
                    color: log.statusColor,
                  ),
                ),
                if (log.isError)
                  const Text(' • 错误', style: TextStyle(fontSize: 11, color: Colors.red)),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  IconData _getStatusIcon(NetworkLogEntry log) {
    if (log.isError) return Icons.error;
    if (log.statusCode == null) return Icons.schedule;
    if (log.statusCode! >= 200 && log.statusCode! < 300) return Icons.check_circle;
    if (log.statusCode! >= 300 && log.statusCode! < 400) return Icons.warning;
    if (log.statusCode! >= 400 && log.statusCode! < 500) return //error_outline;
    Icons.error_outline;
    return Icons.info;
  }
}
