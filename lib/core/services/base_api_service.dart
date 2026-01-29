import 'package:dio/dio.dart';
import 'package:refundo/core/utils/error_handler.dart';

/// API 服务基类
/// 提供统一的错误处理和响应解析
abstract class BaseApiService {
  late final Dio _dio;

  BaseApiService({Dio? dio}) {
    _dio = dio ?? Dio();
  }

  Dio get dio => _dio;

  /// 执行 GET 请求
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 执行 POST 请求
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 执行 PUT 请求
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 执行 DELETE 请求
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 处理成功响应
  T _handleResponse<T>(Response response) {
    // 检查状态码
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      // 如果返回类型是 Response，直接返回
      if (T == Response) {
        return response as T;
      }
      // 否则返回 data
      return response.data as T;
    } else {
      throw AppError(
        message: response.statusMessage ?? '请求失败',
        type: AppErrorType.server,
        statusCode: response.statusCode,
      );
    }
  }

  /// 统一错误处理
  AppError _handleError(dynamic error) {
    if (error is AppError) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    // 未知错误
    return AppError(
      message: error.toString(),
      type: AppErrorType.unknown,
    );
  }

  /// 处理 Dio 错误
  AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return AppError(
          message: '连接超时，请检查网络',
          type: AppErrorType.network,
        );

      case DioExceptionType.sendTimeout:
        return AppError(
          message: '发送超时，请重试',
          type: AppErrorType.network,
        );

      case DioExceptionType.receiveTimeout:
        return AppError(
          message: '接收超时，请重试',
          type: AppErrorType.network,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return AppError(
          message: '请求已取消',
          type: AppErrorType.cancel,
        );

      case DioExceptionType.connectionError:
        return AppError(
          message: '网络连接失败，请检查网络设置',
          type: AppErrorType.network,
        );

      case DioExceptionType.badCertificate:
        return AppError(
          message: '证书验证失败',
          type: AppErrorType.network,
        );

      case DioExceptionType.unknown:
      default:
        return AppError(
          message: '网络错误: ${error.message}',
          type: AppErrorType.network,
        );
    }
  }

  /// 处理错误响应
  AppError _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // 尝试从响应中提取错误消息
    String message = '请求失败';
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
    } else if (data is String) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        return AppError(
          message: message.isNotEmpty ? message : '请求参数错误',
          type: AppErrorType.validation,
          statusCode: statusCode,
        );

      case 401:
        return AppError(
          message: message.isNotEmpty ? message : '未授权，请重新登录',
          type: AppErrorType.auth,
          statusCode: statusCode,
        );

      case 403:
        return AppError(
          message: message.isNotEmpty ? message : '没有权限访问',
          type: AppErrorType.auth,
          statusCode: statusCode,
        );

      case 404:
        return AppError(
          message: message.isNotEmpty ? message : '请求的资源不存在',
          type: AppErrorType.notFound,
          statusCode: statusCode,
        );

      case 500:
        return AppError(
          message: message.isNotEmpty ? message : '服务器错误',
          type: AppErrorType.server,
          statusCode: statusCode,
        );

      case 502:
      case 503:
      case 504:
        return AppError(
          message: message.isNotEmpty ? message : '服务暂时不可用',
          type: AppErrorType.server,
          statusCode: statusCode,
        );

      default:
        return AppError(
          message: message.isNotEmpty ? message : '请求失败 (错误码: $statusCode)',
          type: AppErrorType.server,
          statusCode: statusCode,
        );
    }
  }
}

/// API 结果封装
class ApiResult<T> {
  final bool success;
  final T? data;
  final AppError? error;

  ApiResult.success(this.data)
      : success = true,
        error = null;

  ApiResult.failure(this.error)
      : success = false,
        data = null;

  bool get isSuccess => success && error == null;
  bool get isFailure => !success || error != null;

  /// 获取数据，如果失败则抛出异常
  T get dataOrThrow {
    if (isSuccess && data != null) {
      return data!;
    }
    throw error ?? AppError(message: 'Unknown error', type: AppErrorType.unknown);
  }

  /// 获取数据或默认值
  T dataOrDefault(T defaultValue) {
    return isSuccess ? (data ?? defaultValue) : defaultValue;
  }

  /// 执行成功回调
  ApiResult<T> onSuccess(void Function(T data) callback) {
    if (isSuccess && data != null) {
      callback(data!);
    }
    return this;
  }

  /// 执行失败回调
  ApiResult<T> onFailure(void Function(AppError error) callback) {
    if (isFailure && error != null) {
      callback(error!);
    }
    return this;
  }

  /// 转换数据类型
  ApiResult<R> map<R>(R Function(T data) transform) {
    if (isSuccess && data != null) {
      try {
        return ApiResult.success(transform(data!));
      } catch (e) {
        return ApiResult.failure(
          AppError(
            message: 'Data transformation failed: $e',
            type: AppErrorType.unknown,
          ),
        );
      }
    }
    return ApiResult.failure(error!);
  }
}
