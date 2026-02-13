import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:refundo/data/models/app_update_model.dart';
import 'package:refundo/presentation/providers/dio_provider.dart';

/// 版本更新 API 服务
class ApiUpdateService {
  /// 检查更新
  ///
  /// 后端返回格式: {code: 1, data: {version_id, update_status, version_code, version_name, modify_content, download_url, apk_size, apk_md5}}
  Future<AppUpdateModel?> checkUpdate(BuildContext context) async {
    final dioProvider = DioProvider.globalInstance;

    if (kDebugMode) {
      print('🔄 检查版本更新');
    }

    try {
      final response = await dioProvider.dio.get(
        '/api/version/get',
      );

      if (kDebugMode) {
        print('🔄 版本更新响应: ${response.data}');
      }

      // 处理后端返回的数据结构: {code: 1, data: {...}}
      final code = response.data['code'];
      if (code != 1) {
        if (kDebugMode) {
          print('❌ 后端返回错误码: $code');
        }
        return null;
      }

      final data = response.data['data'];
      if (data == null) {
        if (kDebugMode) {
          print('❌ 后端返回数据为空');
        }
        return null;
      }

      // 解析版本信息
      final updateInfo = AppUpdateModel.fromJson(data);

      if (kDebugMode) {
        print('✅ 版本信息: $updateInfo');
        print('✅ 是否有更新: ${updateInfo.hasUpdate}');
        print('✅ 是否强制: ${updateInfo.isForce}');
      }

      return updateInfo;
    } catch (e) {
      if (kDebugMode) {
        print('❌ 检查更新失败: $e');
      }
      return null;
    }
  }

  /// 比较版本号
  ///
  /// 返回 true 表示 serverVersion 更新
  bool compareVersions(String currentVersion, String serverVersion) {
    try {
      final current = currentVersion.split('.').map(int.parse).toList();
      final server = serverVersion.split('.').map(int.parse).toList();

      for (int i = 0; i < 3; i++) {
        final currentPart = i < current.length ? current[i] : 0;
        final serverPart = i < server.length ? server[i] : 0;

        if (serverPart > currentPart) {
          return true; // 需要更新
        } else if (serverPart < currentPart) {
          return false; // 不需要更新
        }
      }
      return false; // 版本相同
    } catch (e) {
      if (kDebugMode) {
        print('❌ 版本号比较失败: $e');
      }
      return false;
    }
  }
}
