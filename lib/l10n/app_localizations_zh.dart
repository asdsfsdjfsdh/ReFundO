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
  String get enter_password => '输入密码';

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
  String get refund_amount => '退款金额';

  @override
  String get approve => '审批通过';

  @override
  String get reject => '拒绝审批';

  @override
  String get approved => '已通过';

  @override
  String get rejected => '审批拒绝';

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
  String get sync_offline_orders => '同步离线订单';

  @override
  String get no_offline_orders => '没有离线订单需要同步';

  @override
  String get syncing_offline_orders => '正在同步离线订单...';

  @override
  String get sync_completed => '同步完成';

  @override
  String get orders_successfully => '个订单成功';

  @override
  String get orders_failed => '个订单失败';

  @override
  String get sync_failed => '同步失败';

  @override
  String get sync_error => '同步错误';

  @override
  String get statistics => '统计';

  @override
  String get profile => '我的';

  @override
  String get total_orders => '总订单';

  @override
  String get balance => '余额';

  @override
  String get total => '总计';

  @override
  String get in_review => '审批中';

  @override
  String submit_for_approval(Object count) {
    return '提交审批($count)';
  }

  @override
  String get deselect_all => '取消全选';

  @override
  String get scan_to_add => '扫码添加';

  @override
  String selected_orders_count(Object count) {
    return '已选择 $count 个订单';
  }

  @override
  String estimated_refund(Object amount) {
    return '预计退款: $amount FCFA';
  }

  @override
  String order_number_with_hash(Object number) {
    return '订单 #$number';
  }

  @override
  String refund_amount_with_currency(Object amount) {
    return '退款: $amount FCFA';
  }

  @override
  String order_amount_with_currency(Object amount) {
    return '订单: $amount FCFA';
  }

  @override
  String get order_details => '订单详情';

  @override
  String get refund_details => '退款详情';

  @override
  String get product_id => '产品ID';

  @override
  String get order_id_label => '订单ID';

  @override
  String get creation_time => '创建时间';

  @override
  String get order_status_label => '订单状态';

  @override
  String get refund_account => '退款账户';

  @override
  String get approval_status_label => '审批状态';

  @override
  String get refundable_status => '可退款';

  @override
  String get needs_multi_select => '需多选';

  @override
  String get not_refundable => '不可退款';

  @override
  String get already_refunded => '已申请退款';

  @override
  String wait_months(Object months) {
    return '需等待$months个月';
  }

  @override
  String get insufficient_amount_need_more => '金额不足，需多选';

  @override
  String get got_it => '知道了';

  @override
  String get insufficient_refund_amount_error => '该订单退款金额不足5000 FCFA，请选择多个订单累积退款';

  @override
  String cumulative_amount_insufficient(Object amount) {
    return '累积退款金额不足5000 FCFA，还需至少 $amount FCFA。请选择更多订单。';
  }

  @override
  String get contains_non_refundable_orders => '所选订单中包含不可退款的订单，请检查选择';

  @override
  String get submitting_refund_application => '正在提交退款申请...';

  @override
  String get refund_application_submitted => '退款申请提交成功！';

  @override
  String get network_error_check_connection => '网络错误，请检查网络连接';

  @override
  String get order_needs_5_months => '订单需满5个月才能申请退款';

  @override
  String get refund_amount_less_than_5000 => '订单退款金额小于5000，不符合退款条件';

  @override
  String get please_select_orders_first => '请先选择要退款的订单';

  @override
  String refund_failed_with_code(Object code) {
    return '退款申请失败，错误码: $code';
  }

  @override
  String get select_refund_method => '选择退款方式';

  @override
  String order_count_label(Object count) {
    return '订单数量: $count';
  }

  @override
  String total_refund_amount_label(Object amount) {
    return '退款总额: $amount FCFA';
  }

  @override
  String get refund_method_label => '退款方式:';

  @override
  String get refund_account_optional => '退款账号（选填）';

  @override
  String get submit => '提交';

  @override
  String get direct_submit_approval => '直接提交审批';

  @override
  String get orange_money => 'Orange Money';

  @override
  String get wave => 'Wave';

  @override
  String get phone_number_label => '手机号';

  @override
  String get data_statistics => '数据统计';

  @override
  String get order_heatmap => '订单热力图';

  @override
  String get detailed_statistics => '详细统计';

  @override
  String get average_order_amount => '平均订单金额';

  @override
  String get max_order_amount => '最大订单金额';

  @override
  String get total_orders_count => '总订单数';

  @override
  String get weekday_mon => '一';

  @override
  String get weekday_tue => '二';

  @override
  String get weekday_wed => '三';

  @override
  String get weekday_thu => '四';

  @override
  String get weekday_fri => '五';

  @override
  String get weekday_sat => '六';

  @override
  String get weekday_sun => '日';

  @override
  String get heatmap_few => '少';

  @override
  String get heatmap_medium => '中';

  @override
  String get heatmap_many => '多';

  @override
  String get heatmap_many_many => '很多';

  @override
  String get guest_user => '访客用户';

  @override
  String version_info(Object build, Object version) {
    return '版本 $version ($build)';
  }

  @override
  String get main_features => '主要功能';

  @override
  String get open_source_license => '开源许可';

  @override
  String get view_third_party_licenses => '查看第三方库许可协议';

  @override
  String get quick_links => '快速链接';

  @override
  String get feature_scan_orders => '扫码快速添加订单';

  @override
  String get feature_manage_orders => '订单管理和筛选';

  @override
  String get feature_smart_refund => '智能退款系统';

  @override
  String get feature_data_statistics => '数据统计和分析';

  @override
  String last_updated_date(Object date) {
    return '最后更新: $date';
  }

  @override
  String get invalid_qr_code => '无效的二维码';

  @override
  String get illegal_qr_content => '二维码内容非法';

  @override
  String get qr_content_not_json => '二维码内容不是有效的 JSON 格式';

  @override
  String get statistical_analysis => '统计分析';

  @override
  String get this_week => '本周';

  @override
  String get this_month => '本月';

  @override
  String get this_quarter => '本季';

  @override
  String get this_year => '本年';

  @override
  String get orders_count => '个订单';

  @override
  String get fcfa => 'FCFA';

  @override
  String get order_statistics => '订单统计';

  @override
  String get refund_statistics => '退款统计';

  @override
  String get smart_refund_management_system => '智能退款管理系统';

  @override
  String get refundo_app_name => 'RefundO';

  @override
  String get all_rights_reserved => 'All rights reserved';

  @override
  String get scan_history => '扫描历史';

  @override
  String get view_scan_history => '查看扫描记录';

  @override
  String get help_and_feedback => '帮助与反馈';

  @override
  String get faq => '常见问题';

  @override
  String get clear_all => '清空全部';

  @override
  String get delete => '删除';

  @override
  String get product_details => '产品详情';

  @override
  String get price => '价格';

  @override
  String get refund_percent => '退款比例';

  @override
  String get rescan => '重新扫描';

  @override
  String get delete_history_item => '删除历史记录';

  @override
  String get confirm_delete_scan_history => '确认删除此扫描记录？';

  @override
  String get clear_all_history => '清空所有历史';

  @override
  String get confirm_clear_all_history => '确认清空所有扫描历史记录？';

  @override
  String get deleted_successfully => '删除成功';

  @override
  String get history_cleared => '历史记录已清空';

  @override
  String get no_scan_history => '暂无扫描历史';

  @override
  String get scan_products_to_see_history => '扫码添加产品后，扫描记录将显示在这里';

  @override
  String get rescan_function_coming_soon => '重新扫描功能即将推出';

  @override
  String get privacy_policy_title => '隐私政策';

  @override
  String get info_collection => '信息收集';

  @override
  String get info_collection_1 => '我们收集以下类型的信息：';

  @override
  String get info_collection_2 => '• 个人信息：包括姓名、电子邮件地址、电话号码和银行卡信息';

  @override
  String get info_collection_3 => '• 订单信息：包括购买记录、退款申请和交易历史';

  @override
  String get info_collection_4 => '• 使用数据：包括应用使用情况和偏好设置';

  @override
  String get info_collection_5 => '• 设备信息：包括设备型号、操作系统版本和唯一标识符';

  @override
  String get info_usage => '信息使用';

  @override
  String get info_usage_1 => '我们使用收集的信息用于：';

  @override
  String get info_usage_2 => '• 处理您的订单和退款申请';

  @override
  String get info_usage_3 => '• 改进我们的服务和功能';

  @override
  String get info_usage_4 => '• 与您沟通，包括客户支持';

  @override
  String get info_usage_5 => '• 分析应用使用情况，优化用户体验';

  @override
  String get info_usage_6 => '• 防止欺诈和确保安全';

  @override
  String get info_sharing => '信息共享';

  @override
  String get info_sharing_1 => '我们不会出售、出租或交易您的个人信息。我们仅在以下情况下共享信息：';

  @override
  String get info_sharing_2 => '• 获得您的明确同意';

  @override
  String get info_sharing_3 => '• 为处理交易和服务所必需';

  @override
  String get info_sharing_4 => '• 遵守法律要求或法院命令';

  @override
  String get info_sharing_5 => '• 保护我们的权利、财产或安全';

  @override
  String get info_sharing_6 => '• 与可信的服务提供商合作（在保密协议下）';

  @override
  String get data_security => '数据安全';

  @override
  String get data_security_1 => '我们采取以下措施保护您的信息：';

  @override
  String get data_security_2 => '• 使用SSL/TLS加密技术传输数据';

  @override
  String get data_security_3 => '• 安全存储您的密码（加密哈希）';

  @override
  String get data_security_4 => '• 定期安全审计和漏洞扫描';

  @override
  String get data_security_5 => '• 限制员工对个人信息的访问';

  @override
  String get data_security_6 => '• 要求服务提供商遵守严格的安全标准';

  @override
  String get your_rights => '您的权利';

  @override
  String get your_rights_1 => '您对自己的个人信息拥有以下权利：';

  @override
  String get your_rights_2 => '• 访问权：查看我们持有的您的信息';

  @override
  String get your_rights_3 => '• 更正权：更新或修正不准确的信息';

  @override
  String get your_rights_4 => '• 删除权：要求删除您的个人信息';

  @override
  String get your_rights_5 => '• 反对权：反对某些数据处理活动';

  @override
  String get your_rights_6 => '• 撤回同意：撤回之前给予的同意';

  @override
  String get your_rights_7 => '• 数据可携性：以结构化格式接收您的数据';

  @override
  String get cookie_policy => 'Cookie政策';

  @override
  String get cookie_policy_1 => '我们使用Cookie和类似技术来：';

  @override
  String get cookie_policy_2 => '• 记住您的登录凭据';

  @override
  String get cookie_policy_3 => '• 记住您的偏好设置';

  @override
  String get cookie_policy_4 => '• 分析应用性能';

  @override
  String get cookie_policy_5 => '• 提供个性化内容';

  @override
  String get cookie_policy_6 => '您可以通过设备设置管理Cookie偏好';

  @override
  String get child_privacy => '儿童隐私';

  @override
  String get child_privacy_1 => '我们的服务不面向13岁以下的儿童。';

  @override
  String get child_privacy_2 => '如果我们发现收集了13岁以下儿童的个人信息，';

  @override
  String get child_privacy_3 => '我们将采取措施删除该信息。';

  @override
  String get policy_changes => '政策变更';

  @override
  String get policy_changes_1 => '我们可能会不时更新本隐私政策。';

  @override
  String get policy_changes_2 => '变更后，我们将在应用内通知您。';

  @override
  String get policy_changes_3 => '继续使用我们的服务即表示您接受更新后的政策。';

  @override
  String get policy_changes_4 => '建议您定期查看本页面以了解最新信息。';

  @override
  String get contact_us_section => '联系我们';

  @override
  String get contact_us_1 => '如果您对本隐私政策有任何疑问或关注，请通过以下方式联系我们：';

  @override
  String get contact_us_2 => '• 邮箱: support@refundo.com';

  @override
  String get contact_us_3 => '• 应用内反馈: 设置 > 帮助与反馈';

  @override
  String get contact_us_4 => '• 我们将在30天内回复您的询问';

  @override
  String get view_privacy_policy => '查看隐私政策';

  @override
  String get get_help_and_feedback => '获取帮助和反馈';

  @override
  String get not_set => '未设置';

  @override
  String get search_help => '搜索帮助主题...';

  @override
  String get frequently_asked_questions => '常见问题';

  @override
  String get faq1_question => '如何扫描订单？';

  @override
  String get faq1_answer => '点击订单页面上的扫描按钮，将摄像头对准收据上的二维码。';

  @override
  String get faq2_question => '退款要求是什么？';

  @override
  String get faq2_answer => '订单必须至少满5个月，且最低退款金额为5000 FCFA。';

  @override
  String get faq3_question => '退款处理需要多长时间？';

  @override
  String get faq3_answer => '退款申请通常在3-5个工作日内处理完毕。';

  @override
  String get faq4_question => '我可以跟踪退款状态吗？';

  @override
  String get faq4_answer => '是的，您可以在应用的退款部分跟踪退款状态。';

  @override
  String get video_tutorials => '视频教程';

  @override
  String get tutorial1_title => 'RefundO入门指南';

  @override
  String get tutorial1_desc => '学习扫描订单和申请退款的基础知识';

  @override
  String get tutorial2_title => '高级功能指南';

  @override
  String get tutorial2_desc => '探索批量退款和统计等高级功能';

  @override
  String get contact_us => '联系我们';

  @override
  String get email_support => '邮件支持';

  @override
  String get email_support_address => 'support@refundo.com';

  @override
  String get phone_support => '电话支持';

  @override
  String get phone_support_number => '+237 XXX XXX XXX';

  @override
  String get whatsapp_support => 'WhatsApp支持';

  @override
  String get whatsapp_available => '周一至周五 9:00-17:00';

  @override
  String get send_feedback => '发送反馈';

  @override
  String get feedback_description => '我们重视您的反馈！请让我们知道如何改进我们的服务。';

  @override
  String get enter_your_feedback => '在此输入您的反馈...';

  @override
  String get submit_feedback => '提交反馈';

  @override
  String get feedback_submitted_successfully => '谢谢！您的反馈已成功提交。';

  @override
  String get verify_identity => '验证身份';

  @override
  String get new_email => '新邮箱';

  @override
  String get confirm_new_email => '确认邮箱';

  @override
  String get enter_old_password => '输入旧密码';

  @override
  String get please_enter_new_password => '请输入新密码';

  @override
  String get please_enter_password => '请输入密码';

  @override
  String get enter_password_to_verify => '请输入密码验证您的身份';

  @override
  String get enter_old_password_tip => '输入当前密码以确认修改';

  @override
  String get email_format_tip => '请输入有效的邮箱地址（例如：example@domain.com）';

  @override
  String get emails_do_not_match => '两次输入的邮箱地址不一致';

  @override
  String get tips => '提示';

  @override
  String get retry => '重试';

  @override
  String get no_orders_yet => '暂无订单';

  @override
  String get scan_products_to_add_orders => '扫描产品以添加订单';

  @override
  String get scan_now => '立即扫描';

  @override
  String get no_refunds_yet => '暂无退款';

  @override
  String get submit_refund_requests_here => '在此提交退款申请';

  @override
  String get date_range => '日期范围';

  @override
  String get sort_by => '排序方式';

  @override
  String get filter => '筛选';

  @override
  String get apply => '应用';

  @override
  String get status => '状态';

  @override
  String get transaction_failed => '交易失败';

  @override
  String get transaction_receipt => '交易凭证';

  @override
  String get few_label => '少';

  @override
  String get withdrawn => '已提现';

  @override
  String get pending_withdrawal => '未提现';

  @override
  String get click_to_view_full_image => '点击查看大图';

  @override
  String get image_load_failed => '加载失败';

  @override
  String get no_orders_yet_detail => '扫描二维码添加您的第一个订单';

  @override
  String get no_refunds_yet_detail => '您的退款申请将显示在这里';

  @override
  String get no_search_results => '未找到相关结果';

  @override
  String no_search_results_detail(Object query) {
    return '没有找到与 \"$query\" 相关的内容';
  }

  @override
  String get clear_search => '清除搜索';

  @override
  String get network_connection_failed => '网络连接失败';

  @override
  String get check_network_settings => '请检查网络设置后重试';

  @override
  String get server_error_title => '服务器错误';

  @override
  String get server_error_detail => '服务器暂时无法响应，请稍后重试';

  @override
  String get no_more_data => '没有更多数据了';

  @override
  String get total_orders_label => '总订单';

  @override
  String get orders_count_label => '个订单';

  @override
  String get total_amount_label => '总金额';

  @override
  String get order_statistics_section => '订单统计';

  @override
  String get todays_orders => '今日订单';

  @override
  String get refund_statistics_section => '退款统计';

  @override
  String get pending_label => '待处理';

  @override
  String get completed_label => '已完成';
}
