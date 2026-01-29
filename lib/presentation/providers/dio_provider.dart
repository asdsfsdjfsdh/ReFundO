import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:refundo/core/utils/network_logger.dart';
import 'package:refundo/core/services/secure_storage_service.dart';
import 'package:refundo/config/environment/app_environment.dart';

/// 简单的内存缓存条目
class _CacheEntry {
  final Response data;
  final DateTime timestamp;

  _CacheEntry(this.data, this.timestamp);

  /// 检查缓存是否过期（默认5分钟）
  bool isExpired({int durationMinutes = 5}) {
    return DateTime.now().difference(timestamp).inMinutes > durationMinutes;
  }
}

class DioProvider extends ChangeNotifier {
  Dio _dio = Dio();

  // 内存缓存
  final Map<String, _CacheEntry> _cache = {};

  // 可缓存的路径前缀（这些GET请求可以被缓存）
  static const List<String> _cacheablePaths = [
    '/api/orders/init',
    '/api/user/info',
  ];

  Dio get dio => _dio;

  DioProvider() {
    // 使用环境配置的 Base URL
    _dio.options.baseUrl = AppEnvironment.apiBaseUrl;
    _dio.options.contentType = Headers.jsonContentType;

    // 设置超时时间
    _dio.options.connectTimeout = AppEnvironment.connectTimeout;
    _dio.options.receiveTimeout = AppEnvironment.receiveTimeout;

    // 添加拦截器
    // 先添加网络日志拦截器（必须第一个添加，确保记录所有请求）
    _dio.interceptors.add(NetworkLogger.instance);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 从安全存储获取 Token
          final token = await SecureStorageService.instance.getAccessToken();

          if (token.isNotEmpty) {
            if (AppEnvironment.enableDebugLog) {
              debugPrint('Token: $token');
            }
            options.headers['Authorization'] = 'Bearer $token';
          }

          // 处理GET请求缓存
          if (options.method == 'GET' && _isCacheable(options.path)) {
            final cacheKey = _getCacheKey(options);
            final cachedEntry = _cache[cacheKey];

            // 如果有缓存且未过期，直接返回缓存数据
            if (cachedEntry != null && !cachedEntry.isExpired()) {
              if (AppEnvironment.enableDebugLog) {
                debugPrint('Cache hit for: $cacheKey');
              }
              return handler.resolve(cachedEntry.data);
            }
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 缓存成功的GET响应
          if (response.requestOptions.method == 'GET' &&
              _isCacheable(response.requestOptions.path)) {
            final cacheKey = _getCacheKey(response.requestOptions);
            _cache[cacheKey] = _CacheEntry(response, DateTime.now());

            if (AppEnvironment.enableDebugLog) {
              debugPrint('Cached response for: $cacheKey');
            }
          }

          if (AppEnvironment.enableDebugLog) {
            debugPrint('响应状态码: ${response.statusCode}');
          }
          return handler.next(response);
        },
        onError: (e, handler) async {
          // 处理 Token 过期
          if (e.response?.statusCode == 401) {
            if (AppEnvironment.enableDebugLog) {
              debugPrint('Token expired, clearing auth data');
            }
            // 清除过期的认证信息
            await SecureStorageService.instance.clearAuthData();
            // 清除缓存
            clearCache();
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// 检查请求是否可缓存
  bool _isCacheable(String path) {
    return _cacheablePaths.any((prefix) => path.startsWith(prefix));
  }

  /// 生成缓存键
  String _getCacheKey(RequestOptions options) {
    return '${options.method}:${options.path}:${options.uri.query}';
  }

  /// 清除所有缓存
  void clearCache() {
    _cache.clear();
    if (const bool.fromEnvironment('dart.vm.product')) {
      debugPrint('Cache cleared');
    }
  }

  /// 清除特定路径的缓存
  void clearCacheForPath(String path) {
    _cache.removeWhere((key, value) => key.contains(path));
    if (AppEnvironment.enableDebugLog) {
      debugPrint('Cache cleared for path: $path');
    }
  }

  /// 保存Token到安全存储
  Future<void> saveToken(String token) async {
    await SecureStorageService.instance.saveAccessToken(token);
    if (AppEnvironment.enableDebugLog) {
      debugPrint('Token saved successfully');
    }
  }
}
