import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 安全存储服务
/// 用于存储敏感信息（Token、密码等）
class SecureStorageService {
  static SecureStorageService? _instance;
  static SecureStorageService get instance => _instance ??= SecureStorageService._();

  SecureStorageService._();

  // Flutter Secure Storage 实例（用于敏感数据）
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // Android 使用加密的 SharedPreferences
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock, // iOS 需要首次解锁后访问
    ),
  );

  // SharedPreferences 实例（用于非敏感数据）
  SharedPreferences? _prefs;

  /// 初始化服务
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ==================== Token 管理 ====================

  /// 保存访问 Token（安全存储）
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _StorageKeys.accessToken, value: token);
  }

  /// 获取访问 Token
  Future<String> getAccessToken() async {
    return await _secureStorage.read(key: _StorageKeys.accessToken) ?? '';
  }

  /// 删除访问 Token
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _StorageKeys.accessToken);
  }

  /// 保存刷新 Token（安全存储）
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _StorageKeys.refreshToken, value: token);
  }

  /// 获取刷新 Token
  Future<String> getRefreshToken() async {
    return await _secureStorage.read(key: _StorageKeys.refreshToken) ?? '';
  }

  /// 删除刷新 Token
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: _StorageKeys.refreshToken);
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token.isNotEmpty;
  }

  /// 清除所有认证信息
  Future<void> clearAuthData() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }

  // ==================== 用户数据管理 ====================

  /// 保存用户 ID（非敏感，使用 SharedPreferences）
  Future<void> saveUserId(String userId) async {
    await init();
    await _prefs!.setString(_StorageKeys.userId, userId);
  }

  /// 获取用户 ID
  Future<String> getUserId() async {
    await init();
    return _prefs?.getString(_StorageKeys.userId) ?? '';
  }

  /// 保存用户名（非敏感，使用 SharedPreferences）
  Future<void> saveUsername(String username) async {
    await init();
    await _prefs!.setString(_StorageKeys.username, username);
  }

  /// 获取用户名
  Future<String> getUsername() async {
    await init();
    return _prefs?.getString(_StorageKeys.username) ?? '';
  }

  // ==================== 环境配置管理 ====================

  /// 保存当前环境（非敏感，使用 SharedPreferences）
  Future<void> saveEnvironment(String env) async {
    await init();
    await _prefs!.setString(_StorageKeys.environment, env);
  }

  /// 获取当前环境
  Future<String> getEnvironment() async {
    await init();
    return _prefs?.getString(_StorageKeys.environment) ?? 'dev';
  }

  // ==================== 其他安全数据 ====================

  /// 保存自定义安全数据
  Future<void> saveSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// 获取自定义安全数据
  Future<String?> getSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// 删除自定义安全数据
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  // ==================== 非敏感数据 ====================

  /// 保存非敏感数据（使用 SharedPreferences）
  Future<void> setData(String key, dynamic value) async {
    await init();
    if (value is String) {
      await _prefs!.setString(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    } else if (value is bool) {
      await _prefs!.setBool(key, value);
    }
  }

  /// 获取非敏感数据
  dynamic getData(String key) {
    return _prefs?.get(key);
  }

  /// 删除数据
  Future<void> deleteData(String key) async {
    await _prefs?.remove(key);
  }

  /// 清除所有数据（包括安全存储）
  Future<void> clearAll() async {
    await clearAuthData();
    await _secureStorage.deleteAll();
    await _prefs?.clear();
  }
}

/// 存储键常量
class _StorageKeys {
  // 认证相关（安全存储）
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  // 用户数据（非敏感，SharedPreferences）
  static const String userId = 'user_id';
  static const String username = 'username';

  // 环境配置（非敏感，SharedPreferences）
  static const String environment = 'app_environment';
}
