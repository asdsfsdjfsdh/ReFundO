class UserModel{
  // 用户名
  final String username;
  // 用户账号
  final String userAccount;
  // 用户可返还总金额
  final double AmountSum;
  // 用户已返现金额
  final double RefundedAmount;

  final String Email;

  final String CardNumber;

  final String errorMessage;

  // 初始化方法
  UserModel({
    required this.username,
    required this.userAccount,
    required this.AmountSum,
    required this.RefundedAmount,
    required this.Email,
    required this.CardNumber
  , this.errorMessage = ''
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() =>{
    'name': username,
    'userid': userAccount,
    'AmountSum': AmountSum,
    'RefundedAmount': RefundedAmount,
    'Email': Email,
    'CardNumber': CardNumber
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
      userAccount: json['userid'] as String? ?? '',
      AmountSum: (json['AmountSum'] as num?)?.toDouble() ?? 0.0,
      RefundedAmount: (json['RefundedAmount'] as num?)?.toDouble() ?? 0.0,
      Email: json['Email'] as String? ?? '',
      CardNumber: json['CardNumber'] as String? ?? '',
      errorMessage: errorMessage
  );
}

  // 重写输出方法
  @override
  String toString() {
    return "用户：$username,账号:$userAccount,总可返现金额:$AmountSum,已经返现金额：$RefundedAmount,邮箱:$Email,银行卡号:$CardNumber";
  }

}