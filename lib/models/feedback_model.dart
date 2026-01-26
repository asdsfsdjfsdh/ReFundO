import 'package:flutter/material.dart';

/// 反馈类型枚举
enum FeedbackType {
  issue(0, Icons.error_outline, '问题', 'Issue', 'error'),
  suggestion(1, Icons.lightbulb_outline, '建议', 'Suggestion', 'suggestion'),
  complaint(2, Icons.report_problem_outlined, '投诉', 'Complaint', 'complaint'),
  other(3, Icons.chat_bubble_outline, '其他', 'Other', 'other');

  final int code;
  final IconData icon;
  final String zhName;
  final String enName;
  final String key;

  const FeedbackType(this.code, this.icon, this.zhName, this.enName, this.key);

  String getLocalizedName(Locale locale) {
    return locale.languageCode == 'zh' ? zhName : enName;
  }

  static FeedbackType fromCode(int code) {
    return values.firstWhere(
      (type) => type.code == code,
      orElse: () => other,
    );
  }
}

/// 反馈状态枚举
enum FeedbackStatus {
  pending(0, '待处理', 'Pending', Colors.orange),
  processed(1, '已处理', 'Processed', Colors.green),
  withdrawn(2, '已撤回', 'Withdrawn', Colors.grey);

  final int code;
  final String zhName;
  final String enName;
  final Color color;

  const FeedbackStatus(this.code, this.zhName, this.enName, this.color);

  String getLocalizedName(Locale locale) {
    return locale.languageCode == 'zh' ? zhName : enName;
  }

  static FeedbackStatus fromCode(int code) {
    return values.firstWhere(
      (status) => status.code == code,
      orElse: () => pending,
    );
  }
}

/// 反馈模型
class FeedbackModel {
  final int feedbackId;
  final int userId;
  final int feedbackType;
  final String content;
  final String? contactInfo;
  final int feedbackStatus;
  final DateTime createTime;
  final String? attachmentUrl;
  final String errorMessage;

  FeedbackModel({
    required this.feedbackId,
    required this.userId,
    required this.feedbackType,
    required this.content,
    this.contactInfo,
    required this.feedbackStatus,
    required this.createTime,
    this.attachmentUrl,
    this.errorMessage = '',
  });

  /// 获取反馈类型
  FeedbackType get type => FeedbackType.fromCode(feedbackType);

  /// 获取反馈状态
  FeedbackStatus get status => FeedbackStatus.fromCode(feedbackStatus);

  /// 是否可以撤回
  bool get canWithdraw => feedbackStatus == 0 || feedbackStatus == 1;

  /// 从 JSON 创建
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    // 处理数据库字段命名 (snake_case) 转 Java 字段命名
    return FeedbackModel(
      feedbackId: (json['feedBackId'] as num?)?.toInt() ??
                 (json['feedback_id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ??
              (json['user_id'] as num?)?.toInt() ?? 0,
      feedbackType: (json['feedBackType'] as num?)?.toInt() ??
                    (json['feedback_type'] as num?)?.toInt() ?? 0,
      content: json['content'] as String? ?? '',
      contactInfo: json['contactInfo'] as String? ??
                   json['contact_info'] as String?,
      feedbackStatus: (json['feedBackStatus'] as num?)?.toInt() ??
                      (json['feedback_status'] as num?)?.toInt() ?? 0,
      createTime: json['createTime'] != null
          ? DateTime.parse(json['createTime'])
          : (json['create_time'] != null
              ? DateTime.parse(json['create_time'])
              : DateTime.now()),
      attachmentUrl: json['attachmentUrl'] as String? ??
                     json['attachment_url'] as String?,
    );
  }

  /// 成功响应模型
  factory FeedbackModel.success() {
    return FeedbackModel(
      feedbackId: 0,
      userId: 0,
      feedbackType: 0,
      content: '',
      feedbackStatus: 0,
      createTime: DateTime.now(),
    );
  }

  /// 错误响应模型
  factory FeedbackModel.error(String message) {
    return FeedbackModel(
      feedbackId: 0,
      userId: 0,
      feedbackType: 0,
      content: '',
      feedbackStatus: 0,
      createTime: DateTime.now(),
      errorMessage: message,
    );
  }

  @override
  String toString() {
    return 'FeedbackModel{feedbackId: $feedbackId, type: ${type.zhName}, status: ${status.zhName}, content: $content}';
  }
}
