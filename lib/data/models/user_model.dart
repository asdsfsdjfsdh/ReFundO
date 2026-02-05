/// 用户数据模型
/// 完全对齐后端 UserLoginVO 结构
class UserModel {
  /// 用户ID (后端: UserId)
  final int? userId;

  /// 用户名 (后端: UserName)
  final String username;

  /// 余额 (后端: Balance)
  final double balance;

  /// 手机号 (后端: PhoneNumber)
  final String? phoneNumber;

  /// 邮箱 (后端: Email)
  final String? email;

  /// 桑科字段 (后端: Sangke)
  final String? sangke;

  /// WAVE字段 (后端: WAVE)
  final String? wave;

  /// JWT令牌 (后端: Token)
  final String? token;

  /// 已返现金额 (前端保留，用于UI展示)
  final double refundedAmount;

  /// 头像URL (后端: AvatarUrl)
  final String? avatarUrl;

  /// 错误信息 (前端内部使用)
  final String errorMessage;

  // Getter for email (兼容性)
  String get Email => email ?? '';

  UserModel({
    this.userId,
    required this.username,
    required this.balance,
    this.phoneNumber,
    this.email,
    this.sangke,
    this.wave,
    this.token,
    this.refundedAmount = 0.0,
    this.avatarUrl,
    this.errorMessage = '',
  });

  /// 从JSON创建用户模型
  /// 支持后端 UserLoginVO 的驼峰命名和前端可能的下划线命名
  factory UserModel.fromJson(Map<String, dynamic> json, {String errorMessage = ''}) {
    // 辅助函数：安全地从dynamic获取字符串，支持多个可能的字段名
    String getString(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
      return '';
    }

    // 辅助函数：安全地从dynamic获取数字，支持多个可能的字段名
    double getDouble(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null) {
          if (value is num) return value.toDouble();
          if (value is String) return double.tryParse(value) ?? 0.0;
        }
      }
      return 0.0;
    }

    // 辅助函数：安全地从dynamic获取整数
    int? getInt(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null) {
          if (value is int) return value;
          if (value is String) return int.tryParse(value);
          if (value is num) return value.toInt();
        }
      }
      return null;
    }

    return UserModel(
      userId: getInt(['UserId', 'userId', 'uid']),
      username: getString(['UserName', 'userName', 'username', 'name']),
      balance: getDouble(['Balance', 'balance', 'AmountSum', 'amountSum']),
      phoneNumber: getString(['PhoneNumber', 'phoneNumber', 'phone']),
      email: getString(['Email', 'email']),
      sangke: getString(['Sangke', 'sangke']),
      wave: getString(['WAVE', 'Wave', 'wave']),
      token: getString(['Token', 'token']),
      refundedAmount: getDouble(['RefundedAmount', 'refundedAmount']),
      avatarUrl: getString(['AvatarUrl', 'avatarUrl', 'avatar']),
      errorMessage: errorMessage,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': username,
    'balance': balance,
    'phoneNumber': phoneNumber,
    'email': email,
    'sangke': sangke,
    'WAVE': wave,
    'token': token,
    'refundedAmount': refundedAmount,
    'avatarUrl': avatarUrl,
  };

  /// 创建副本并修改部分字段
  UserModel copyWith({
    int? userId,
    String? username,
    double? balance,
    String? phoneNumber,
    String? email,
    String? sangke,
    String? wave,
    String? token,
    double? refundedAmount,
    String? avatarUrl,
    String? errorMessage,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      balance: balance ?? this.balance,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      sangke: sangke ?? this.sangke,
      wave: wave ?? this.wave,
      token: token ?? this.token,
      refundedAmount: refundedAmount ?? this.refundedAmount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// 判断是否为空（错误状态）
  bool get isEmpty => errorMessage.isNotEmpty;

  /// 判断是否有效
  bool get isValid => errorMessage.isEmpty && userId != null;

  @override
  String toString() {
    return 'UserModel{userId: $userId, username: $username, balance: $balance, '
        'phoneNumber: $phoneNumber, email: $email, sangke: $sangke, '
        'wave: $wave, token: ${token?.substring(0, 20)}..., '
        'refundedAmount: $refundedAmount, avatarUrl: $avatarUrl, '
        'errorMessage: $errorMessage}';
  }
}
