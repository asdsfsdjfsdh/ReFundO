/// 应用环境配置
class AppEnvironment {
  // 环境类型
  static const String dev = 'dev';
  static const String test = 'test';
  static const String prod = 'prod';

  // 默认环境
  static String _currentEnvironment = dev;

  /// 获取当前环境
  static String get currentEnvironment => _currentEnvironment;

  /// 设置当前环境
  static void setEnvironment(String env) {
    if (env == dev || env == test || env == prod) {
      _currentEnvironment = env;
    } else {
      throw ArgumentError('Invalid environment: $env. Must be dev, test, or prod.');
    }
  }

  /// 是否为开发环境
  static bool get isDev => _currentEnvironment == dev;

  /// 是否为测试环境
  static bool get isTest => _currentEnvironment == test;

  /// 是否为生产环境
  static bool get isProd => _currentEnvironment == prod;

  /// 获取 API Base URL
  static String get apiBaseUrl {
    switch (_currentEnvironment) {
      case dev:
        // Android模拟器使用10.0.2.2访问主机localhost
        // iOS模拟器和真机可以使用localhost
        return 'http://10.0.2.2:8080'; // 开发环境 - 指向本地后端服务器
      case test:
        return 'http://120.26.110.204:8080'; // 测试环境
      case prod:
        return 'https://api.production.com'; // 生产环境（需要配置）
      default:
        return 'http://10.0.2.2:4040';
    }
  }

  /// 获取版本更新专用 Base URL（用于下载 APK 等大文件）
  static String get updateBaseUrl {
    switch (_currentEnvironment) {
      case dev:
      case test:
        return 'http://120.26.110.204:8080';
      case prod:
        return 'https://api.production.com'; // 生产环境（需要配置）
      default:
        return 'http://120.26.110.204:8080';
    }
  }

  /// 获取超时时间（毫秒）
  static Duration get connectTimeout => const Duration(milliseconds: 15000);
  static Duration get receiveTimeout => const Duration(milliseconds: 15000);

  /// 是否启用调试日志
  static bool get enableDebugLog => !isProd;

  /// 是否启用网络日志
  static bool get enableNetworkLogging => !isProd;
}

/// 环境配置管理器
class EnvironmentManager {
  /// 从存储加载环境配置
  static Future<void> loadEnvironment() async {
    // 这里可以从 SecureStorageService 读取保存的环境
    // 目前使用默认开发环境
    AppEnvironment.setEnvironment(AppEnvironment.dev);
  }

  /// 保存环境配置
  static Future<void> saveEnvironment(String env) async {
    AppEnvironment.setEnvironment(env);
    // 可以保存到 SecureStorageService
  }
}

