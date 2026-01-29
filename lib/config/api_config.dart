/// API 配置
class ApiConfig {
  /// API 基础 URL
  /// TODO: 生产环境请使用 HTTPS
  static const String baseUrl = 'http://localhost:8080';

  /// API 超时时间（毫秒）
  static const Duration timeout = Duration(seconds: 30);

  /// 最大离线订单数量
  static const int maxOfflineOrders = 100;
}
