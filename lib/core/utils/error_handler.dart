import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:refundo/core/utils/log_util.dart';

/// 应用错误类型
enum AppErrorType {
  network,      // 网络错误
  auth,         // 认证错误
  validation,   // 验证错误
  notFound,     // 资源未找到
  server,       // 服务器错误
  cancel,       // 请求取消
  unknown,      // 未知错误
}

/// 应用错误类
class AppError implements Exception {
  final String message;
  final AppErrorType type;
  final int? statusCode;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppError({
    required this.message,
    required this.type,
    this.statusCode,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppError: $message (type: $type, statusCode: $statusCode)';
  }

  /// 获取用户友好的错误消息
  String getUserMessage() {
    switch (type) {
      case AppErrorType.network:
        return '网络连接失败，请检查网络设置';
      case AppErrorType.auth:
        return '登录已过期，请重新登录';
      case AppErrorType.validation:
        return message;
      case AppErrorType.notFound:
        return '请求的资源不存在';
      case AppErrorType.server:
        return '服务器错误，请稍后重试';
      case AppErrorType.cancel:
        return '请求已取消';
      case AppErrorType.unknown:
        return '发生未知错误，请稍后重试';
    }
  }
}

/// 错误处理工具类
class ErrorHandler {
  static ErrorHandler? _instance;
  static ErrorHandler get instance => _instance ??= ErrorHandler._();

  ErrorHandler._() {
    _initializeErrorHandling();
  }

  /// 初始化全局错误处理
  void _initializeErrorHandling() {
    // 捕获Flutter框架错误
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
      _handleFlutterError(details);
    };

    // 捕获异步错误
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true;
    };

    LogUtil.i('ErrorHandler', '错误处理器已初始化');
  }

  /// 处理Flutter错误
  void _handleFlutterError(FlutterErrorDetails details) {
    final exception = details.exception;
    final stack = details.stack;

    LogUtil.e(
      'FlutterError',
      'Flutter错误: ${exception.toString()}',
      exception,
      stack,
    );

    // 可以在这里添加错误上报逻辑
    _reportError(exception, stack);
  }

  /// 处理平台错误
  void _handlePlatformError(Object error, StackTrace stack) {
    LogUtil.e(
      'PlatformError',
      '平台错误: ${error.toString()}',
      error,
      stack,
    );

    _reportError(error, stack);
  }

  /// 报告错误（可以接入错误监控服务）
  void _reportError(Object error, StackTrace? stack) {
    // TODO: 接入Sentry、Firebase Crashlytics等错误监控服务
    if (kDebugMode) {
      print('错误已报告: $error');
    }
  }

  /// 处理Dio异常
  static AppError handleDioError(dynamic error) {
    if (error is AppError) return error;

    AppErrorType type = AppErrorType.unknown;
    int? statusCode;
    String message = '请求失败';

    if (error.toString().contains('SocketException')) {
      type = AppErrorType.network;
      message = '网络连接失败';
    } else if (error.toString().contains('TimeoutException')) {
      type = AppErrorType.network;
      message = '请求超时';
    } else if (error.toString().contains('401')) {
      type = AppErrorType.auth;
      message = '未授权，请重新登录';
      statusCode = 401;
    } else if (error.toString().contains('404')) {
      type = AppErrorType.notFound;
      message = '资源不存在';
      statusCode = 404;
    } else if (error.toString().contains('500')) {
      type = AppErrorType.server;
      message = '服务器错误';
      statusCode = 500;
    }

    return AppError(
      message: message,
      type: type,
      statusCode: statusCode,
      originalError: error,
    );
  }

  /// 捕获同步代码中的错误
  static T catchError<T>(
    T Function() fn, {
    T? defaultValue,
    void Function(AppError)? onError,
  }) {
    try {
      return fn();
    } catch (error, stack) {
      final appError = _convertToAppError(error, stack);
      LogUtil.e('ErrorHandler', appError.toString(), error, stack);

      if (onError != null) {
        onError(appError);
      }

      return defaultValue as T;
    }
  }

  /// 捕获异步代码中的错误
  static Future<T> catchAsyncError<T>(
    Future<T> Function() fn, {
    T? defaultValue,
    void Function(AppError)? onError,
  }) async {
    try {
      return await fn();
    } catch (error, stack) {
      final appError = _convertToAppError(error, stack);
      LogUtil.e('ErrorHandler', appError.toString(), error, stack);

      if (onError != null) {
        onError(appError);
      }

      return defaultValue as T;
    }
  }

  /// 将错误转换为AppError
  static AppError _convertToAppError(dynamic error, StackTrace? stack) {
    if (error is AppError) return error;

    return AppError(
      message: error.toString(),
      type: AppErrorType.unknown,
      originalError: error,
      stackTrace: stack,
    );
  }

  /// 显示错误对话框
  static void showErrorDialog(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getErrorIcon(error.type),
              color: _getErrorColor(error.type),
            ),
            const SizedBox(width: 8),
            const Text('错误'),
          ],
        ),
        content: Text(error.getUserMessage()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('重试'),
            ),
        ],
      ),
    );
  }

  /// 显示错误SnackBar
  static void showErrorSnackBar(
    BuildContext context,
    AppError error, {
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getErrorIcon(error.type),
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(error.getUserMessage())),
          ],
        ),
        backgroundColor: _getErrorColor(error.type),
        action: action,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 获取错误图标
  static IconData _getErrorIcon(AppErrorType type) {
    switch (type) {
      case AppErrorType.network:
        return Icons.wifi_off;
      case AppErrorType.auth:
        return Icons.lock_outline;
      case AppErrorType.validation:
        return Icons.error_outline;
      case AppErrorType.notFound:
        return Icons.search_off;
      case AppErrorType.server:
        return Icons.cloud_off;
      case AppErrorType.cancel:
        return Icons.cancel;
      case AppErrorType.unknown:
        return Icons.warning_amber;
    }
  }

  /// 获取错误颜色
  static Color _getErrorColor(AppErrorType type) {
    switch (type) {
      case AppErrorType.network:
        return Colors.orange;
      case AppErrorType.auth:
        return Colors.red;
      case AppErrorType.validation:
        return Colors.amber;
      case AppErrorType.notFound:
        return Colors.blue;
      case AppErrorType.server:
        return Colors.red;
      case AppErrorType.cancel:
        return Colors.grey;
      case AppErrorType.unknown:
        return Colors.grey;
    }
  }
}

/// 错误边界Widget - 捕获子树中的错误
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stack)? errorBuilder;
  final void Function(Object error, StackTrace? stack)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stack;

  @override
  void initState() {
    super.initState();
    _error = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _stack);
      }

      // 默认错误UI
      return _DefaultErrorWidget(
        error: _error!,
        stack: _stack,
        onRetry: () {
          setState(() {
            _error = null;
          });
        },
      );
    }

    return widget.child;
  }
}

/// 默认错误Widget
class _DefaultErrorWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stack;
  final VoidCallback onRetry;

  const _DefaultErrorWidget({
    required this.error,
    required this.stack,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                '出错了',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
