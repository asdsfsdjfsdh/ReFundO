import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/data/services/api_update_service.dart';
import 'package:refundo/data/models/app_update_model.dart';

/// 版本更新服务
class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  final ApiUpdateService _apiService = ApiUpdateService();

  /// 初始化更新服务
  Future<void> initXUpdate() async {
    // 请求存储权限
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
    LogUtil.d("更新服务", "初始化完成");
  }

  /// 检查更新（用于设置页面手动检查）
  Future<void> checkUpdate(BuildContext context, {bool showNoUpdate = true}) async {
    try {
      // 获取当前版本信息
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      LogUtil.d("更新服务", "当前版本: $currentVersion");

      // 从后端 API 获取最新版本信息
      final updateInfo = await _apiService.checkUpdate(context);

      if (updateInfo == null) {
        LogUtil.e("更新服务", "未获取到版本信息");
        if (showNoUpdate && context.mounted) {
          _showErrorDialog(context);
        }
        return;
      }

      // 检查后端返回的 updateStatus
      if (!updateInfo.hasUpdate) {
        // 没有更新
        if (showNoUpdate && context.mounted) {
          _showNoUpdateDialog(context, currentVersion);
        }
        return;
      }

      // 有更新，显示更新对话框
      if (context.mounted) {
        _showUpdateDialog(
          context,
          currentVersion,
          updateInfo.versionName,
          updateInfo.modifyContent ?? '',
          updateInfo.downloadUrl,
          updateInfo.apkSizeBytes,
          updateInfo.isForce,
        );
      }
    } catch (e) {
      LogUtil.e("更新服务", "检查更新失败: $e");
      if (showNoUpdate && context.mounted) {
        _showErrorDialog(context);
      }
    }
  }

  /// 自动检查更新（启动时调用，有更新才弹窗）
  Future<void> autoCheckUpdate(BuildContext context) async {
    try {
      // 获取 current version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // 从后端 API 获取最新版本信息
      final updateInfo = await _apiService.checkUpdate(context);

      if (updateInfo == null) {
        LogUtil.e("更新服务", "未获取到版本信息");
        return;
      }

      // 检查是否有更新
      if (!updateInfo.hasUpdate) {
        LogUtil.d("更新服务", "没有新版本");
        return;
      }

      // 有更新才显示更新对话框
      if (context.mounted) {
        _showUpdateDialog(
          context,
          currentVersion,
          updateInfo.versionName,
          updateInfo.modifyContent ?? '',
          updateInfo.downloadUrl,
          updateInfo.apkSizeBytes,
          updateInfo.isForce,
        );
      }
    } catch (e) {
      LogUtil.e("更新服务", "自动检查更新失败: $e");
      // 静默失败，不打扰用户
    }
  }

  /// 显示更新对话框
  void _showUpdateDialog(
    BuildContext context,
    String currentVersion,
    String latestVersion,
    String updateLog,
    String downloadUrl,
    int apkSize,
    bool isForce,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final sizeMB = (apkSize / (1024 * 1024)).toStringAsFixed(1);

    showDialog(
      context: context,
      barrierDismissible: !isForce, // 强制更新不允许点击外部关闭
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isForce ? Colors.orange.shade50 : Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isForce ? Icons.system_update_alt : Icons.system_update,
                color: isForce ? Colors.orange.shade700 : Colors.blue.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isForce ? '重要更新' : l10n.new_version_available,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${l10n.current_version}: $currentVersion → $latestVersion',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 强制更新提示
              if (isForce)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange.shade700, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '重要更新，请立即升级以继续使用',
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // APK 大小
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.file_download, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.download_size}: $sizeMB MB',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 更新日志
              Text(
                l10n.update_log,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  updateLog.isNotEmpty
                      ? updateLog
                      : l10n.no_update_log_available,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          // 非强制更新才显示"稍后提醒"
          if (!isForce)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.remind_later,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),

          // 立即更新
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _downloadAndInstall(context, downloadUrl, latestVersion);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isForce ? Colors.orange.shade700 : Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.update_now),
          ),
        ],
      ),
    );
  }

  /// 显示已是最新版本对话框
  void _showNoUpdateDialog(BuildContext context, String currentVersion) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.already_latest_version,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          '${l10n.current_version}: $currentVersion',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  /// 显示错误对话框
  void _showErrorDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error,
                color: Colors.red.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.check_update_failed,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(l10n.check_update_failed_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  /// 下载并安装更新
  Future<void> _downloadAndInstall(
    BuildContext context,
    String downloadUrl,
    String version,
  ) async {
    // 显示下载进度对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DownloadProgressDialog(
        downloadUrl: downloadUrl,
        version: version,
      ),
    );
  }
}

/// 下载进度对话框
class _DownloadProgressDialog extends StatefulWidget {
  final String downloadUrl;
  final String version;

  const _DownloadProgressDialog({
    required this.downloadUrl,
    required this.version,
  });

  @override
  State<_DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  double _progress = 0;
  bool _isDownloading = true;
  bool _isError = false;
  String? _apkPath;

  @override
  void initState() {
    super.initState();
    _downloadApk();
  }

  Future<void> _downloadApk() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      // 获取临时目录
      final tempDir = await getTemporaryDirectory();
      final apkPath = '${tempDir.path}/app_${widget.version}.apk';

      // 下载文件
      await Dio().download(
        widget.downloadUrl,
        apkPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );

      _apkPath = apkPath;
      setState(() {
        _isDownloading = false;
      });

      // 自动打开安装
      await _installApk();
    } catch (e) {
      LogUtil.e("更新服务", "下载失败: $e");
      setState(() {
        _isDownloading = false;
        _isError = true;
      });
    }
  }

  Future<void> _installApk() async {
    if (_apkPath == null) return;

    try {
      final result = await OpenFile.open(_apkPath!);
      if (result.type == ResultType.done) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      LogUtil.e("更新服务", "安装失败: $e");
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (_isDownloading)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 3,
              ),
            )
          else if (_isError)
            Icon(Icons.error, color: Colors.red.shade700, size: 24)
          else
            Icon(Icons.check_circle, color: Colors.green.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isDownloading
                  ? l10n.downloading_update
                  : _isError
                      ? l10n.download_failed
                      : l10n.downloading_update,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isDownloading)
            Column(
              children: [
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          else if (_isError)
            Text(l10n.download_failed)
          else
            Text(l10n.downloading_update),
        ],
      ),
      actions: [
        if (_isError)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(l10n.ok),
          )
        else if (!_isDownloading && _apkPath != null)
          TextButton(
            onPressed: () => _installApk(),
            child: Text(l10n.retry),
          )
        else
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
      ],
    );
  }
}
