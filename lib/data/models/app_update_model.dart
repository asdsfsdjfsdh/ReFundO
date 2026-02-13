import 'package:decimal/decimal.dart';

/// 版本更新模型
class AppUpdateModel {
  final int? versionId;        // 版本ID
  final int updateStatus;       // 更新状态（0=不更新，1=有更新不强制，2=有更新强制）
  final String versionCode;     // 版本代码
  final String versionName;     // 版本名（如 "1.0.0"）
  final String? modifyContent;  // 更新内容/日志
  final String downloadUrl;     // APK下载地址
  final double? apkSize;       // APK大小（MB）
  final String? apkMd5;         // APK MD5

  AppUpdateModel({
    this.versionId,
    required this.updateStatus,
    required this.versionCode,
    required this.versionName,
    this.modifyContent,
    required this.downloadUrl,
    this.apkSize,
    this.apkMd5,
  });

  /// 从 JSON 创建实例
  factory AppUpdateModel.fromJson(Map<String, dynamic> json) {
    // 解析 apkSize - 可能是 int、double、String 或 Decimal
    double? parsedApkSize;
    if (json['apkSize'] != null) {
      if (json['apkSize'] is double) {
        parsedApkSize = json['apkSize'] as double;
      } else if (json['apkSize'] is int) {
        parsedApkSize = (json['apkSize'] as int).toDouble();
      } else if (json['apkSize'] is String) {
        parsedApkSize = double.tryParse(json['apkSize']!) ?? 0.0;
      } else if (json['apkSize'] is Decimal) {
        parsedApkSize = (json['apkSize'] as Decimal).toDouble();
      }
    }

    return AppUpdateModel(
      versionId: json['versionId'] as int?,
      updateStatus: json['updateStatus'] is int
          ? json['updateStatus'] as int
          : int.tryParse(json['updateStatus']?.toString() ?? '0') ?? 0,
      versionCode: json['versionCode']?.toString() ?? '0',
      versionName: json['versionName']?.toString() ?? '',
      modifyContent: json['modifyContent']?.toString(),
      downloadUrl: json['downloadUrl']?.toString() ?? '',
      apkSize: parsedApkSize,
      apkMd5: json['apkMd5']?.toString(),
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() => {
    'versionId': versionId,
    'updateStatus': updateStatus,
    'versionCode': versionCode,
    'versionName': versionName,
    'modifyContent': modifyContent,
    'downloadUrl': downloadUrl,
    'apkSize': apkSize,
    'apkMd5': apkMd5,
  };

  /// 是否有更新（updateStatus != 0）
  bool get hasUpdate => updateStatus != 0;

  /// 是否强制更新（updateStatus == 2）
  bool get isForce => updateStatus == 2;

  /// 获取 APK 大小（字节）
  int get apkSizeBytes => ((apkSize ?? 0) * 1024 * 1024).toInt();

  @override
  String toString() {
    return 'AppUpdateModel{versionName: $versionName, updateStatus: $updateStatus, downloadUrl: $downloadUrl, apkSize: $apkSize}';
  }
}
