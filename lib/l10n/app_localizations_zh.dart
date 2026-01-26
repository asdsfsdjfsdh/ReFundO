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

  @override
  String get user_registration => '用户注册';

  @override
  String get username => '用户名';

  @override
  String get email => '邮箱';

  @override
  String get verification_code => '验证码';

  @override
  String get get_verification_code => '获取验证码';

  @override
  String countdown_seconds(Object seconds) {
    return '$seconds秒';
  }

  @override
  String get password => '密码';

  @override
  String get confirm_password => '确认密码';

  @override
  String get register => '注册';

  @override
  String get already_have_account => '已有账号?';

  @override
  String get login_now => '立即登录';

  @override
  String get please_enter_username => '请输入用户名';

  @override
  String get please_enter_valid_email => '请输入有效的邮箱地址';

  @override
  String get please_enter_verification_code => '请输入验证码';

  @override
  String get password_length_at_least_6 => '密码长度至少6位';

  @override
  String get passwords_do_not_match => '两次输入的密码不一致';

  @override
  String get verification_code_send_failed => '验证码发送失败，请重试';

  @override
  String get user_login => '用户登录';

  @override
  String get username_or_email => '用户名/邮箱';

  @override
  String get remember_me => '记住我';

  @override
  String get forgot_password => '忘记密码?';

  @override
  String get login => '登录';

  @override
  String get no_account_register_now => '没有账号？点击注册';

  @override
  String get please_enter_username_and_password => '请输入用户名和密码';

  @override
  String get audit => '审核';

  @override
  String get audit_page => '审核界面';

  @override
  String get audit_records => '审核记录';

  @override
  String get detail_info => '详细信息';

  @override
  String get user_id => '用户ID';

  @override
  String get nickname => '昵称';

  @override
  String get refund_time => '返现时间';

  @override
  String get refund_method => '返现方式';

  @override
  String get refund_amount => '返现金额';

  @override
  String get approve => '审批通过';

  @override
  String get reject => '拒绝审批';

  @override
  String get approved => '已通过';

  @override
  String get rejected => '已拒绝';

  @override
  String get items => '项';

  @override
  String get no_audit_records => '暂无审核记录';

  @override
  String get select_record_to_view => '请选择一条记录查看详情';

  @override
  String get already_approved => '已审批通过';

  @override
  String get already_rejected => '已拒绝审批';

  @override
  String get approve_success => '审批通过成功';

  @override
  String get approve_failed => '审批通过失败';

  @override
  String get reject_success => '拒绝审批成功';

  @override
  String get reject_failed => '拒绝审批失败';

  @override
  String get filter_conditions => '筛选条件';

  @override
  String get time_range => '时间范围';

  @override
  String get all => '全部';

  @override
  String get one_day => '一天内';

  @override
  String get one_week => '一周内';

  @override
  String get one_month => '一个月内';

  @override
  String get approval_status => '审批状态';

  @override
  String get reset => '重置';

  @override
  String get no_records_found => '未找到符合条件的记录';

  @override
  String get adjust_filters => '请尝试调整筛选条件';

  @override
  String get not_manager => '你不是管理员';

  @override
  String get refund_confirmation => '退款确认';

  @override
  String total_amount_orders(Object selectedCount, Object totalAmount) {
    return '总计: $totalAmount FCFA | $selectedCount 个订单';
  }

  @override
  String get select_payment_method => '选择支付方式';

  @override
  String get phone_payment => '手机号支付';

  @override
  String get sanke_money => '桑克钱';

  @override
  String get wave_payment => 'WAVE支付';

  @override
  String get enter_phone_number => '请输入手机号码';

  @override
  String get invalid_phone_format => '手机号码格式不正确';

  @override
  String get enter_sanke_account => '请输入桑克钱账户';

  @override
  String get account_length_at_least_6 => '账户长度至少6位';

  @override
  String get enter_wave_account => '请输入WAVE账户ID';

  @override
  String get wave_account_start_with_wave => 'WAVE账户ID应以WAVE开头';

  @override
  String get confirm_phone_number => '确认手机号码';

  @override
  String get confirm_refund => '确认退款';

  @override
  String get scan_the_QR => '扫描二维码';

  @override
  String get order_less_than_5_months => '订单未满5个月';

  @override
  String get total_amount_less_than_5000 => '订单总金额小于5000';

  @override
  String get change_name => '修改昵称';

  @override
  String get save => '保存';

  @override
  String get new_name => '新名称';

  @override
  String get please_enter_name => '没有输入名称，请重新填写';

  @override
  String get update_success => '修改成功';

  @override
  String get callback_password => '找回密码';

  @override
  String get hint_enter_email => '请输入邮箱';

  @override
  String get next_step => '下一步';

  @override
  String get hint_enter_verification_code => '请输入验证码';

  @override
  String get resend_verification_code => '重新获取';

  @override
  String resend_with_countdown(Object count) {
    return '重新获取($count)';
  }

  @override
  String get please_enter_code_first => '请先输入验证码';

  @override
  String get verification_code_expired => '验证码已过期，请重新获取';

  @override
  String get verification_code_correct => '验证码正确';

  @override
  String get verification_code_incorrect => '验证码错误';

  @override
  String get invalid_request_format => '请求参数格式不正确';

  @override
  String get verification_service_unavailable => '验证码服务暂时不可用，请稍后重试';

  @override
  String get please_get_code_first => '请先获取验证码';

  @override
  String get verification_code_sent => '验证码已发送至您的邮箱，请查收';

  @override
  String get verification_code_sent_success => '验证码已发送';

  @override
  String get email_send_failed => '邮件发送失败，请检查邮箱地址或稍后重试';

  @override
  String get user_info_not_unique => '用户信息不唯一，请联系客服处理';

  @override
  String get no_user_found_for_email => '未找到与该邮箱关联的用户账户';

  @override
  String get email_service_unavailable => '邮件服务暂时不可用，请稍后重试';

  @override
  String get send_failed => '发送失败';

  @override
  String get set_new_password => '设置新密码';

  @override
  String get new_password => '新密码';

  @override
  String get hint_enter_new_password => '请输入新密码';

  @override
  String get hint_confirm_new_password => '请再次输入新密码';

  @override
  String get password_set_success => '密码设置成功';

  @override
  String get error_username_required => '用户名不能为空';

  @override
  String get error_username_length => '用户名长度应为3-20个字符';

  @override
  String get error_email_required => '邮箱不能为空';

  @override
  String get error_password_required => '密码不能为空';

  @override
  String get error_password_length => '密码长度应为6-20个字符';

  @override
  String get error_code_required => '验证码不能为空';

  @override
  String get error_code_format => '验证码格式不正确';

  @override
  String get error_account_repetition_username => '用户名已存在';

  @override
  String get error_account_repetition_email => '邮箱已被使用';

  @override
  String get error_code_send_too_frequently => '验证码发送过于频繁，请60秒后再试';

  @override
  String get error_server_signup_failed => '注册失败，请重试';

  @override
  String error_login_ip_locked(Object minutes) {
    return 'IP已被锁定，请$minutes分钟后再试';
  }

  @override
  String error_login_account_locked(Object minutes) {
    return '账号已被锁定，请$minutes分钟后再试';
  }

  @override
  String get login_success => '登录成功';

  @override
  String get register_success => '注册成功';

  @override
  String get get_user_info_success => '获取用户信息成功';

  @override
  String get update_username_success => '用户名更新成功';

  @override
  String get update_password_success => '密码修改成功';

  @override
  String get update_email_success => '邮箱更新成功';

  @override
  String get update_phone_success => '电话号码更新成功';

  @override
  String get send_email_success => '邮件发送成功';

  @override
  String get create_order_success => '订单创建成功';

  @override
  String get get_orders_success => '获取订单列表成功';

  @override
  String get create_refund_success => '退款申请成功';

  @override
  String get get_refunds_success => '获取退款列表成功';

  @override
  String get scan_product_success => '商品扫描成功';

  @override
  String get get_product_success => '获取商品信息成功';

  @override
  String get network_timeout => '请求超时，请检查网络连接';

  @override
  String get network_error => '网络连接失败';

  @override
  String get server_error_404 => '请求的资源未找到';

  @override
  String get server_error_500 => '服务器内部错误';

  @override
  String get feedback_title => '意见反馈';

  @override
  String get feedback_subtitle => '我们重视您的每一条反馈';

  @override
  String get feedback_tab_submit => '提交反馈';

  @override
  String get feedback_tab_history => '历史记录';

  @override
  String get feedback_type_label => '反馈类型';

  @override
  String get feedback_content_label => '反馈内容';

  @override
  String get feedback_content_hint => '请详细描述您的问题、建议或投诉内容...';

  @override
  String get feedback_content_min_chars => '至少输入10个字符';

  @override
  String get feedback_contact_label => '联系方式（选填）';

  @override
  String get feedback_contact_hint => '邮箱或手机号';

  @override
  String get feedback_upload_label => '相关截图（选填）';

  @override
  String get feedback_upload_hint => '点击上传截图';

  @override
  String get feedback_upload_format_hint => '支持 JPG、PNG 格式，最大 5MB';

  @override
  String get feedback_submit => '提交反馈';

  @override
  String get feedback_submit_success => '反馈提交成功，感谢您的意见！';

  @override
  String get feedback_submit_failed => '反馈提交失败，请重试';

  @override
  String get feedback_no_records => '暂无反馈记录';

  @override
  String get feedback_withdraw => '撤回';

  @override
  String get feedback_withdraw_confirm_title => '确认撤回';

  @override
  String get feedback_withdraw_confirm_message => '确定要撤回这条反馈吗？';

  @override
  String get feedback_withdraw_success => '反馈已撤回';

  @override
  String get feedback_withdraw_failed => '撤回失败';

  @override
  String get feedback_detail_title => '反馈详情';

  @override
  String get feedback_status_label => '状态';

  @override
  String get feedback_time_label => '提交时间';

  @override
  String get feedback_attachment => '附件';

  @override
  String get error_feedback_content_length => '反馈内容长度应为10-1000个字符';

  @override
  String get error_feedback_file_too_large => '文件大小不能超过5MB';

  @override
  String get error_feedback_file_format => '仅支持 JPG、PNG 格式';

  @override
  String get error_upload_failed => '图片上传失败，请重试';

  @override
  String get get_feedbacks_success => '获取反馈列表成功';

  @override
  String get get_feedbacks_failed => '获取反馈列表失败';

  @override
  String get faq_title => '帮助中心';

  @override
  String get faq_search_hint => '搜索问题...';

  @override
  String get faq_categories => '快速分类';

  @override
  String get faq_popular => '热门问题';

  @override
  String get faq_view_all => '查看全部';

  @override
  String get faq_no_results => '没有找到相关问题';

  @override
  String get faq_contact_support => '联系客服';

  @override
  String get faq_category_refund => '退款流程';

  @override
  String get faq_category_account => '账户问题';

  @override
  String get faq_category_scan => '产品扫描';

  @override
  String get faq_category_refund_desc => '申请退款';

  @override
  String get faq_category_account_desc => '登录注册';

  @override
  String get faq_category_scan_desc => '扫码查询';

  @override
  String get get_faqs_success => '获取FAQ列表成功';

  @override
  String get get_faqs_failed => '获取FAQ列表失败';

  @override
  String get get_faq_success => '获取FAQ详情成功';

  @override
  String get get_faq_failed => '获取FAQ详情失败';

  @override
  String get get_categories_success => '获取分类列表成功';

  @override
  String get get_categories_failed => '获取分类列表失败';

  @override
  String get get_category_success => '获取分类详情成功';

  @override
  String get get_category_failed => '获取分类详情失败';

  @override
  String get faq_close => '关闭';

  @override
  String get faq_all => '全部';

  @override
  String get faq_pinned => '置顶';

  @override
  String get faq_contact_support_hint => '如果您需要更多帮助，请联系我们';

  @override
  String get status_pending => '待处理';

  @override
  String get status_approved => '已批准';

  @override
  String get status_rejected => '已拒绝';

  @override
  String get status_processing => '处理中';

  @override
  String get status_completed => '已完成';

  @override
  String get status_failed => '失败';

  @override
  String get status_unknown => '未知状态';

  @override
  String get transaction_pending => '待处理';

  @override
  String get transaction_success => '成功';

  @override
  String get transaction_failed => '失败';

  @override
  String get transaction_processing => '处理中';

  @override
  String get transaction_details => '交易详情';

  @override
  String get no_transaction_records => '暂无交易记录';

  @override
  String get change_avatar => '修改头像';

  @override
  String get take_photo => '拍照';

  @override
  String get choose_from_gallery => '从相册选择';

  @override
  String get discount_voucher => '优惠凭证 (可选)';

  @override
  String get tap_to_upload_voucher => '点击上传优惠凭证';

  @override
  String get voucherUrl => '凭证';
}
