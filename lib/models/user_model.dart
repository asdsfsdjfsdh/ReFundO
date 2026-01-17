class UserModel {
  // 用户ID
  final int userId;
  // 用户名 - 改为可变的，以便更新
  String userName;
  // 密码 - 改为可变的，以便更新
  String? password;
  // 余额
  final double balance;
  // 邮箱 - 改为可变的，以便更新
  String email;
  // 电话号码
  String? phoneNumber;
  // Token
  String? token;
  // 其他字段
  String? sangke;
  String? wave;
  // 头像URL
  String? avatarUrl;

  final String errorMessage;

  // 初始化方法
  UserModel({
    required this.userId,
    required this.userName,
    required this.balance,
    required this.email,
    this.password,
    this.phoneNumber,
    this.token,
    this.sangke,
    this.wave,
    this.avatarUrl,
    this.errorMessage = '',
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'password': password,
        'balance': balance,
        'email': email,
        'phoneNumber': phoneNumber,
        'sangke': sangke,
        'wave': wave,
        'avatarUrl': avatarUrl
      };

  // 从Json的转化方法
  factory UserModel.fromJson(Map<String, dynamic> json, {String errorMessage = ''}) {
    // 如果json为空，返回一个默认实例
    if (json.isEmpty) {
      return UserModel(
        userId: 0,
        userName: '',
        password: null,
        balance: 0.0,
        email: '',
        phoneNumber: null,
        token: null,
        sangke: null,
        wave: null,
        avatarUrl: null,
        errorMessage: errorMessage,
      );
    }

    // 检查是否是包含data的完整响应格式
    Map<String, dynamic>? userData;
    String? tokenFromResponse;

    if (json.containsKey('data') && json['data'] != null) {
      // 完整响应格式：{"message": null, "data": {...}, "code": 1}
      userData = json['data'];
      tokenFromResponse = userData!['token'];
    } else {
      // 直接是用户数据格式
      userData = json;
    }

    return UserModel(
      userId: (userData!['userId'] as num?)?.toInt() ?? 0,
      userName: userData['userName'] as String? ?? '',
      balance: (userData['balance'] as num?)?.toDouble() ?? 0.0,
      email: userData['email'] as String? ?? '',
      phoneNumber: userData['phoneNumber'] as String?,
      token: tokenFromResponse ?? userData['token'] as String?,
      sangke: userData['sangke'] as String?,
      wave: userData['wave'] as String?,
      avatarUrl: userData['avatarUrl'] as String?,
      errorMessage: errorMessage,
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "用户ID：$userId, 用户名：$userName, 余额：$balance, 邮箱：$email, 电话：$phoneNumber, Token：$token";
  }
}