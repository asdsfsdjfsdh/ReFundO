/// 性能优化配置
class PerformanceConfig {
  /// 图片缓存配置
  static const int imageCacheSize = 100; // 图片缓存数量
  static const Duration imageCacheDuration = Duration(hours: 1); // 图片缓存时间

  /// 网络请求配置
  static const int maxConcurrentRequests = 3; // 最大并发请求数
  static const Duration requestTimeout = Duration(seconds: 10); // 请求超时时间
  static const bool enableRequestCache = true; // 启用请求缓存
  static const Duration requestCacheDuration = Duration(minutes: 5); // 请求缓存时间

  /// 列表优化配置
  static const int listItemCacheExtent = 250; // 列表项预加载范围
  static const bool enableListPagination = true; // 启用列表分页
  static const int itemsPerPage = 20; // 每页项目数

  /// 动画配置
  static const Duration animationDuration = Duration(milliseconds: 300); // 动画持续时间
  static const bool enableAnimationOptimization = true; // 启用动画优化

  /// 内存管理配置
  static const int maxOfflineOrders = 50; // 最大离线订单数
  static const bool enableMemoryProfiling = false; // 启用内存分析（开发模式）
}