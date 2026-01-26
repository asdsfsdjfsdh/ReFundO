import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart';

/// 网络错误辅助工具类
/// 用于将 Dio 异常映射到本地化错误消息键
class NetworkErrors {
  /// 将 DioException 映射到本地化键
  static String getErrorKey(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'network_timeout';

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return 'server_error_404';
        } else if (statusCode == 500) {
          return 'server_error_500';
        } else {
          return 'unknown_error';
        }

      case DioExceptionType.cancel:
        return 'unknown_error';

      case DioExceptionType.connectionError:
        return 'network_error';

      case DioExceptionType.badCertificate:
        return 'network_error';

      case DioExceptionType.unknown:
      default:
        return 'unknown_error';
    }
  }

  /// 获取本地化错误消息
  static String getLocalizedErrorMessage(BuildContext context, String errorKey) {
    final l10n = AppLocalizations.of(context)!;

    switch (errorKey) {
      case 'network_timeout':
        return l10n.network_timeout;
      case 'network_error':
        return l10n.network_error;
      case 'server_error_404':
        return l10n.server_error_404;
      case 'server_error_500':
        return l10n.server_error_500;
      case 'unknown_error':
      default:
        return l10n.unknown_error;
    }
  }

  /// 从 DioException 获取本地化错误消息（便捷方法）
  static String getLocalizedErrorFromException(BuildContext context, DioException e) {
    final errorKey = getErrorKey(e);
    return getLocalizedErrorMessage(context, errorKey);
  }

  /// 检查错误键是否为网络错误
  static bool isNetworkError(String errorKey) {
    return errorKey == 'network_timeout' ||
        errorKey == 'network_error' ||
        errorKey == 'server_error_404' ||
        errorKey == 'server_error_500';
  }

  /// 检查错误键是否为超时错误
  static bool isTimeoutError(String errorKey) {
    return errorKey == 'network_timeout';
  }

  /// 检查错误键是否为连接错误
  static bool isConnectionError(String errorKey) {
    return errorKey == 'network_error';
  }

  /// 检查错误键是否为服务器错误
  static bool isServerError(String errorKey) {
    return errorKey == 'server_error_404' || errorKey == 'server_error_500';
  }
}
