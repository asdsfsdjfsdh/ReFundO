class UserModel{
  // 用户名
  String username;
  // 用户账号
  final String userAccount;
  // 用户可返还总金额
  final double AmountSum;
  // 用户已返现金额
  final double RefundedAmount;

  final bool role;

  String? avatarUrl;

  String Email;

  String phoneNumber;

  final String errorMessage;

  String password;

  // Getter for email (lowercase alias for Email)
  String get email => Email;

  // 初始化方法
  UserModel({
    required this.username,
    required this.userAccount,
    required this.AmountSum,
    required this.RefundedAmount,
    required this.Email,
    required this.phoneNumber,
    required this.password,
    required this.role,
    this.errorMessage = '',
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() =>{
    'name': username,
    'userid': userAccount,
    'amountSum': AmountSum,
    'refundedAmount': RefundedAmount,
    'email': Email,
    'phoneNumber': phoneNumber,
    'password':password
  };

  // 从Json的转化方法
  // factory UserModel.fromJson(Map<String,dynamic> json){
  //   return UserModel(
  //       username: json['name'],
  //       userAccount: json['userid'],
  //       AmountSum: json['AmountSum'],
  //       RefundedAmount: json['RefundedAmount'],
  //       Email: json['Email'] as String? ?? '',
  //       CardNumber: json['CardNumber'] as String? ?? ''
  //   );
  // }

  // 从Json的转化方法 - 更健壮的处理null值和类型转换，支持多种后端字段名
factory UserModel.fromJson(Map<String,dynamic> json, {String errorMessage = ''}) {
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

  // 辅助函数：安全地从dynamic获取布尔值，支持多个可能的字段名
  bool getBool(List<String> keys) {
    for (String key in keys) {
      final value = json[key];
      if (value != null) {
        if (value is bool) return value;
        if (value is String) return value.toLowerCase() == 'true';
        if (value is num) return value != 0;
      }
    }
    return false;
  }

  return UserModel(
      username: getString(['username', 'name', 'nickName']),
      userAccount: getString(['userId', 'uid', 'userid', 'userAccount']),
      AmountSum: getDouble(['balance', 'amountSum', 'AmountSum']),
      RefundedAmount: getDouble(['refundedAmount', 'RefundedAmount']),
      Email: getString(['email', 'Email']),
      phoneNumber: getString(['phoneNumber', 'cardNumber', 'CardNumber']),
      password: getString(['password', 'Password']),
      errorMessage: errorMessage,
      role: getBool(['isAdmin', 'role', 'isManager', 'isManager'])
  );
}

  // 重写输出方法
  @override
  String toString() {
    return "用户：$username,账号:$userAccount,总可返现金额:$AmountSum,已经返现金额：$RefundedAmount,邮箱:$Email,银行卡号:$phoneNumber,错误信息:$errorMessage";
  }

}