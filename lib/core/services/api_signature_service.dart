import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

/// API签名服务
/// 用于为受保护的API请求生成签名
class ApiSignatureService {
  // 从后端配置中获取的密钥和AppId
  static const String _apiSecret = 'refundO-api-secret-key-2024-change-in-production';
  static const String _appId = 'refundO-app';

  // 需要签名验证的路径前缀
  static const List<String> _protectedPaths = [
    '/api/refund',
    '/api/orders',
    '/api/admin',
  ];

  // 不需要签名验证的路径
  static const List<String> _excludedPaths = [
    '/api/user/register',
    '/api/user/login',
    '/api/user/info',
    '/api/user/update',
    '/api/user/check',
    '/api/email',
  ];

  /// 判断请求是否需要签名
  static bool requiresSignature(String path) {
    // 检查是否在排除列表中
    for (String excludedPath in _excludedPaths) {
      if (path.startsWith(excludedPath)) {
        return false;
      }
    }

    // 检查是否在保护列表中
    for (String protectedPath in _protectedPaths) {
      if (path.startsWith(protectedPath)) {
        return true;
      }
    }

    return false;
  }

  /// 为请求添加签名头
  static Map<String, String> generateSignatureHeaders(
    String path,
    String method,
    Map<String, dynamic>? queryParams,
    dynamic body,
  ) {
    if (!requiresSignature(path)) {
      return {};
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final nonce = _generateNonce();

    // 构建签名字符串
    final signature = _generateSignature(
      queryParams,
      body,
      timestamp,
      nonce,
    );

    return {
      'X-Timestamp': timestamp,
      'X-Nonce': nonce,
      'X-Signature': signature,
      'X-App-Id': _appId,
    };
  }

  /// 生成随机数
  static String _generateNonce() {
    final random = Random.secure();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(1000000);
    return '$timestamp$randomNum';
  }

  /// 生成HMAC-SHA256签名
  ///
  /// 签名算法: HMAC-SHA256(Sort(queryParams) + Timestamp + Nonce + AppId)
  /// 注意：只使用查询参数，不包含请求体（与后端保持一致）
  static String _generateSignature(
    Map<String, dynamic>? queryParams,
    dynamic body,
    String timestamp,
    String nonce,
  ) {
    // 收集所有参数并排序（只使用查询参数）
    final params = <String, String>{};

    // 添加查询参数
    if (queryParams != null) {
      final sortedKeys = queryParams.keys.toList()..sort();
      for (String key in sortedKeys) {
        final value = queryParams[key];
        if (value != null) {
          params[key] = value.toString();
        }
      }
    }

    // 注意：后端不包含请求体参数，所以前端也不包含
    // 这样可以确保前后端签名一致

    // 构建签名字符串：params&timestamp+nonce+appId
    final signatureBuilder = StringBuffer();

    // 添加排序后的参数
    for (var entry in params.entries) {
      signatureBuilder.write('${entry.key}=${entry.value}&');
    }

    // 添加时间戳、随机数和AppId
    signatureBuilder.write('$timestamp$nonce$_appId');

    final signatureString = signatureBuilder.toString();

    // 调试日志
    print('🔐 签名字符串: "$signatureString"');
    print('🔐 参数数量: ${params.length}');

    // 生成HMAC-SHA256签名
    final key = utf8.encode(_apiSecret);
    final data = utf8.encode(signatureString);

    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(data);

    // 转换为Base64
    final signature = base64.encode(digest.bytes);
    print('🔐 生成签名: $signature');

    return signature;
  }
}

/// API签名拦截器
///
/// 自动为受保护的API请求添加签名头
class ApiSignatureInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 检查是否需要签名
    if (ApiSignatureService.requiresSignature(options.path)) {
      // 生成签名头
      final signatureHeaders = ApiSignatureService.generateSignatureHeaders(
        options.path,
        options.method,
        options.queryParameters,
        options.data,
      );

      // 添加签名头到请求
      options.headers.addAll(signatureHeaders);
    }

    handler.next(options);
  }
}
