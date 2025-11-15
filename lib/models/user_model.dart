class UserModel{
  // 用户名
  String username;
  // 用户账号
  final String userAccount;
  // 用户可返还总金额
  final double AmountSum;
  // 用户已返现金额
  final double RefundedAmount;

  String? avatarUrl;

  String Email;

  String phoneNumber;

  final String errorMessage;

  String password;

  // 初始化方法
  UserModel({
    required this.username,
    required this.userAccount,
    required this.AmountSum,
    required this.RefundedAmount,
    required this.Email,
    required this.phoneNumber,
    required this.password,
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

  // 从Json的转化方法
factory UserModel.fromJson(Map<String,dynamic> json, {String errorMessage = ''}) {
  return UserModel(
      username: json['name'] as String? ?? '',
      userAccount: (json['uid'] as num?)?.toString() ?? '',
      AmountSum: (json['amountSum'] as num?)?.toDouble() ?? 0.0,
      RefundedAmount: (json['refundedAmount'] as num?)?.toDouble() ?? 0.0,
      Email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      password: json['password'] as String? ?? '',
      errorMessage: errorMessage
  );
}

  // 重写输出方法
  @override
  String toString() {
    return "用户：$username,账号:$userAccount,总可返现金额:$AmountSum,已经返现金额：$RefundedAmount,邮箱:$Email,银行卡号:$phoneNumber,错误信息:$errorMessage";
  }

}