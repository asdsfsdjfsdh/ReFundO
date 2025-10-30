// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get bottom_home_page => '主页';

  @override
  String get bottom_setting_page => '设置';

  @override
  String get start_initialization_starting => '初始化中，请耐性等待...';

  @override
  String get start_initialization_loadingData => '正在获取数据...';

  @override
  String get start_initialization_complete => '初始化完成';

  @override
  String get start_initialization_unknown => '未知的初始化进行中...';

  @override
  String get account_settings => '账户设置';

  @override
  String get email_address => '邮箱地址';

  @override
  String get modify_login_email => '修改登录邮箱';

  @override
  String get login_password => '登录密码';

  @override
  String get modify_account_password => '修改账户密码';

  @override
  String get bank_card_number => '银行卡号';

  @override
  String get bank_card_tail_number => '尾号 6789';

  @override
  String get manage_payment_info => '管理支付信息';

  @override
  String get app_settings => '应用设置';

  @override
  String get language_settings => '语言设置';

  @override
  String get select_app_language => '选择应用语言';

  @override
  String get logout_account => '注销账号';

  @override
  String get login_account => '登录账号';

  @override
  String get exit_current_account => '退出当前账户';

  @override
  String get login_your_account => '登录您的账户';

  @override
  String get privacy_policy => '隐私政策';

  @override
  String get view_app_privacy_terms => '查看应用隐私条款';

  @override
  String get about_app => '关于应用';

  @override
  String get version_info_and_help => '版本信息和帮助';

  @override
  String get please_login_to_view_account_info => '请登录以查看账户信息';

  @override
  String get please_login_first => '请先登录';

  @override
  String get privacy_policy_page_under_development => '隐私政策页面开发中';

  @override
  String get about_page_under_development => '关于页面开发中';

  @override
  String get select_language => '选择语言';

  @override
  String get language_switched_to => '语言已切换到';

  @override
  String get app_name => 'Refundo';

  @override
  String get app_slogan => '智能退款管理系统';

  @override
  String get starting_initialization => '开始初始化...';

  @override
  String get loading_user_data => '加载用户数据...';

  @override
  String get unknown_error => '未知错误';

  @override
  String get ready => '准备就绪...';

  @override
  String get initializing => '初始化中...';

  @override
  String get orders => '订单';

  @override
  String get refunds => '退款';

  @override
  String get manage_orders => '管理订单';

  @override
  String get cancel => '取消';

  @override
  String get refund => '退款';

  @override
  String get select_at_least_one_order => '请选中至少一个订单';

  @override
  String get refund_success_waiting_approval => '退款成功，请等待审批';

  @override
  String get server_error => '服务器异常';

  @override
  String get error => 'Error';

  @override
  String get total_amount => '总金额';

  @override
  String get today_orders => '今日订单';

  @override
  String get processing => '处理中';

  @override
  String get camera_permission_required => '需要相机权限';

  @override
  String get camera_permission_description => '扫码功能需要访问您的相机。请到系统设置中为应用启用相机权限。';

  @override
  String get go_to_settings => '去设置';

  @override
  String get notification => '提示';

  @override
  String get confirm => '确定';

  @override
  String get select_all => '全选';

  @override
  String selected_count(Object selectedCount, Object total) {
    return '已选择 $selectedCount/$total';
  }

  @override
  String get select_orders_to_refund => '选择订单进行退款';

  @override
  String get no_orders => '暂无订单';

  @override
  String get order_list_empty => '订单列表为空';

  @override
  String get order_number => '订单号';

  @override
  String get time => '时间';

  @override
  String get refundable => '可退款';

  @override
  String get no_withdrawal_records => '暂无提现记录';

  @override
  String get withdrawal_records_will_appear_here => '提现记录将显示在这里';

  @override
  String get withdrawal_application => '提现申请';

  @override
  String get completed => '已完成';

  @override
  String get pending => '待处理';

  @override
  String get withdrawal_details => '提现详情';

  @override
  String get withdrawal_amount => '提现金额';

  @override
  String get application_time => '申请时间';

  @override
  String get processing_status => '处理状态';

  @override
  String get payment_method => '到账方式';

  @override
  String get bank_card => '银行卡';

  @override
  String get close => '关闭';

  @override
  String get uid_label => 'UID';

  @override
  String get not_logged_in => '未登录';

  @override
  String get please_login_to_view_profile => '请登录以查看个人信息';

  @override
  String get card_change_title => '修改银行卡';

  @override
  String get enter_email => '请输入邮箱';

  @override
  String get enter_password => '请输入密码';

  @override
  String get enter_new_card_number => '请输入新的银行卡号';

  @override
  String get please_enter_complete_info => '请输入完整信息';

  @override
  String get verification_success => '验证成功';

  @override
  String get email_or_password_incorrect => '邮箱或密码错误';

  @override
  String get verification_failed => '验证失败';

  @override
  String get please_enter_card_number => '请输入银行卡号';

  @override
  String get modification_success => '修改成功';

  @override
  String get modification_failed => '修改失败';

  @override
  String get email_change_title => '修改邮箱';

  @override
  String get enter_old_email => '请输入旧邮箱';

  @override
  String get enter_new_email => '请输入新邮箱';

  @override
  String get please_enter_new_email => '请输入新邮箱';

  @override
  String get invalid_email_format => '邮箱格式不正确';
}
