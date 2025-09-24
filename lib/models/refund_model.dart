class RefundModel{
  // 返还金额
  final double refundAmount;
  // 提现时间
  final DateTime timestamp;
  // 提现审批状态
  final RefundStates refundState;

  // 初始化方法
  RefundModel({
    required this.refundAmount,
    required this.timestamp,
    required this.refundState
  });

  // 配置转化Json方法
  Map<String, dynamic> toJson() =>{
    'refundAmount': refundAmount,
    'timestamp': timestamp,
    'refundState': refundState
  };

  // 从Json的转化方法
  factory RefundModel.fromJson(Map<String,dynamic> json){
    return RefundModel(
        refundAmount: json['refundAmount'],
        timestamp: json['timestamp'],
        refundState: json['refundState']
    );
  }

  // 重写输出方法
  @override
  String toString() {
    return "返还金额：$refundAmount，提现时间：$timestamp，审批状态:$refundState";
  }

}

enum RefundStates{
  approval,
  success
}