import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refundo/core/utils/network_logger.dart';
import 'package:refundo/core/services/secure_storage_service.dart';
import 'package:refundo/core/services/api_signature_service.dart';
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
  // 静态实例，用于全局访问
  static DioProvider? _instance;
  static DioProvider get globalInstance =>
      _instance ??= DioProvider._internal();

  final Dio _dio = Dio();

  // 专用于获取CSRF Token的Dio实例（不添加签名拦截器）
  final Dio _csrfDio = Dio();

  // CSRF Token
  String? _csrfToken;

  // 内存缓存
  final Map<String, _CacheEntry> _cache = {};

  // 可缓存的路径前缀（这些GET请求可以被缓存）
  static const List<String> _cacheablePaths = [
    '/api/orders/init',
    '/api/user/info',
  ];

  // 私有构造函数（用于内部创建单例）
  DioProvider._internal() : super() {
    _setupDio();
  }

  // 公共构造函数（用于Provider）
  DioProvider() : super() {
    _setupDio();
  }

  Dio get dio => _dio;

  /// 初始化Dio配置
  void _setupDio() {
    // 配置主Dio实例
    _dio.options.baseUrl = AppEnvironment.apiBaseUrl;
    _dio.options.contentType = Headers.jsonContentType;
    _dio.options.connectTimeout = AppEnvironment.connectTimeout;
    _dio.options.receiveTimeout = AppEnvironment.receiveTimeout;

    // 配置CSRF专用Dio实例（不添加签名和CSRF拦截器）
    _csrfDio.options.baseUrl = AppEnvironment.apiBaseUrl;
    _csrfDio.options.contentType = Headers.jsonContentType;
    _csrfDio.options.connectTimeout = AppEnvironment.connectTimeout;
    _csrfDio.options.receiveTimeout = AppEnvironment.receiveTimeout;

    // 为CSRF Dio添加自动Token拦截器
    _csrfDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 从安全存储获取 Token
          final token = await SecureStorageService.instance.getAccessToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            if (AppEnvironment.enableDebugLog) {
              debugPrint('CSRF Request: Adding Authorization header');
            }
          }

          // 添加语言标识请求头
          final prefs = await SharedPreferences.getInstance();
          final languageCode = prefs.getString('languageCode') ?? 'zh';
          final countryCode = prefs.getString('countryCode') ?? 'CN';
          options.headers['Accept-Language'] = '$languageCode-${countryCode.toLowerCase()}';
          if (AppEnvironment.enableDebugLog) {
            debugPrint('CSRF Request: Adding Accept-Language header: $languageCode-${countryCode.toLowerCase()}');
          }

          return handler.next(options);
        },
      ),
    );

    // 添加拦截器
    // 先添加网络日志拦截器（必须第一个添加，确保记录所有请求）
    _dio.interceptors.add(NetworkLogger.instance);

    // 添加API签名拦截器
    _dio.interceptors.add(ApiSignatureInterceptor());

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 从安全存储获取 Token
          final token = await SecureStorageService.instance.getAccessToken();

          if (token.isNotEmpty) {
            if (AppEnvironment.enableDebugLog) {
              debugPrint('Adding Authorization header with token: ${token.substring(0, 20)}...');
            }
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            if (AppEnvironment.enableDebugLog) {
              debugPrint('No token found, skipping Authorization header');
            }
          }

          // 添加语言标识请求头
          final prefs = await SharedPreferences.getInstance();
          final languageCode = prefs.getString('languageCode') ?? 'zh';
          final countryCode = prefs.getString('countryCode') ?? 'CN';
          options.headers['Accept-Language'] = '$languageCode-${countryCode.toLowerCase()}';
          if (AppEnvironment.enableDebugLog) {
            debugPrint('Adding Accept-Language header: $languageCode-${countryCode.toLowerCase()}');
          }

          // 只对需要CSRF Token的路径添加CSRF Token
          // /api/refund 需要CSRF Token
          if (_csrfToken != null && _csrfToken!.isNotEmpty && options.path.startsWith('/api/refund')) {
            options.headers['X-CSRF-Token'] = _csrfToken;
            if (AppEnvironment.enableDebugLog) {
              debugPrint('========================================');
              debugPrint('Adding CSRF Token to ${options.path}');
              debugPrint('CSRF Token: $_csrfToken');
              debugPrint('JWT Token (first 30 chars): ${token.substring(0, token.length > 30 ? 30 : token.length)}...');
              debugPrint('========================================');
            }
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
          // 从响应头中提取CSRF Token
          final csrfToken = response.headers['X-CSRF-Token']?.first ??
              response.headers['X-XSRF-Token']?.first;
          if (csrfToken != null && csrfToken.isNotEmpty) {
            _csrfToken = csrfToken;
            if (AppEnvironment.enableDebugLog) {
              debugPrint('CSRF Token received and stored: $csrfToken');
            }
          }

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

    // Token保存成功后，自动获取CSRF Token
    // await _fetchCsrfToken();
  }

  /// 获取CSRF Token
  Future<void> _fetchCsrfToken() async {
    try {
      if (AppEnvironment.enableDebugLog) {
        debugPrint('Fetching CSRF Token...');
      }

      // 获取当前JWT Token用于日志
      final currentJwt = await SecureStorageService.instance.getAccessToken();
      if (AppEnvironment.enableDebugLog) {
        debugPrint('Current JWT Token (first 30 chars): ${currentJwt.substring(0, currentJwt.length > 30 ? 30 : currentJwt.length)}...');
      }

      // 使用专用的_csrfDio实例（自动携带JWT Token，不需要签名）
      final response = await _csrfDio.post('/api/security/csrf-token');

      if (AppEnvironment.enableDebugLog) {
        debugPrint('CSRF Token response status: ${response.statusCode}');
        debugPrint('CSRF Token response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final result = data?['result'];
        final token = result?['token'];

        if (token != null) {
          _csrfToken = token;
          if (AppEnvironment.enableDebugLog) {
            debugPrint('CSRF Token fetched and stored successfully: $token');
            debugPrint('This token should be stored in Redis with key: security:csrf:<JWT_TOKEN>');
          }
        } else {
          if (AppEnvironment.enableDebugLog) {
            debugPrint('CSRF Token is null in response');
          }
        }
      }
    } catch (e) {
      if (AppEnvironment.enableDebugLog) {
        debugPrint('Failed to fetch CSRF Token: $e');
      }
      // CSRF Token获取失败不影响登录流程
    }
  }

  /// 刷新CSRF Token（用于需要重新获取Token的场景）
  Future<void> refreshCsrfToken() async {
    await _fetchCsrfToken();
  }
}
