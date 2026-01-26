import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

class OrderModel {
  // 订单金额
  final double value;
  // 用户ID
  final int userId;
  // 产品ID
  final int productId;
  // 扫描时间
  final String scanTime;
  // 退款比率
  final double? refundRatio;
  // 扫描编号
  final String scanNumber;
  // 原价
  final double? originalPrice;
  // 扫描ID
  final int scanId;
  final String errorMessage;
  final String successMessageKey;

  // 初始化方法
  OrderModel({
    required this.value,
    required this.userId,
    required this.productId,
    required this.scanTime,
    this.refundRatio,
    required this.scanNumber,
    this.originalPrice,
    required this.scanId,
    this.errorMessage = '',
    this.successMessageKey = '',
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() => {
    'value': value,
    'userId': userId,
    'productId': productId,
    'scanTime': scanTime,
    'refundRatio': refundRatio,
    'scanNumber': scanNumber,
    'originalPrice': originalPrice,
    'scanId': scanId,
  };

  // 从Json的转化方法
  factory OrderModel.fromJson(Map<String, dynamic> json, {String errorMessage = '', String successMessageKey = ''}) {
    return OrderModel(
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      userId: json['userId'] as int? ?? 0,
      productId: json['productId'] as int? ?? 0,
      scanTime: json['scanTime'] as String? ?? '',
      refundRatio: (json['refundRatio'] as num?)?.toDouble(),
      scanNumber: json['scanNumber'] as String? ?? '',
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      scanId: json['scanId'] as int? ?? 0,
      errorMessage: errorMessage,
      successMessageKey: successMessageKey,
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "扫描ID：$scanId，扫描编号：$scanNumber，产品ID：$productId，金额：$value，扫描时间：$scanTime，原价：${originalPrice?.toString() ?? 'N/A'}，退款比率：${refundRatio?.toString() ?? 'N/A'}，用户ID：$userId";
  }
  
  // 格式化日期显示
  String get formattedScanTime {
    try {
      DateTime dateTime = DateTime.parse(scanTime);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    } catch (e) {
      return scanTime; // 如果解析失败，返回原始字符串
    }
  }
}