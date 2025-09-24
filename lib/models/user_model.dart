class UserModel{
  // 用户名
  final String username;
  // 用户账号
  final String userAccount;
  // 用户可返还总金额
  final double refundAll;
  // 用户已返现金额
  final double refundedAll;

  // 初始化方法
  UserModel({
    required this.username,
    required this.userAccount,
    required this.refundAll,
    required this.refundedAll
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() =>{
    'username': username,
    'userAccount': userAccount,
    'refundAll': refundAll,
    'refundedAll': refundedAll
  };

  // 从Json的转化方法
  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
        username: json['username'],
        userAccount: json['userAccount'],
        refundAll: json['refundAll'],
        refundedAll: json['refundedAll']
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "用户：$username,账号:$userAccount,总可返现金额:$refundAll,已经返现金额：$refundedAll";
  }

}