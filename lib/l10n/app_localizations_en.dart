// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get bottom_home_page => 'home';

  @override
  String get bottom_setting_page => 'setting';

  @override
  String get start_initialization_starting => 'Initializing，please wait patiently...';

  @override
  String get start_initialization_loadingData => 'Fetching data...';

  @override
  String get start_initialization_complete => 'Initialization completed.';

  @override
  String get start_initialization_unknown => 'Initialization in progress with unknown status...';

  @override
  String get account_settings => 'Account Settings';

  @override
  String get email_address => 'Email Address';

  @override
  String get modify_login_email => 'Modify Login Email';

  @override
  String get login_password => 'Login Password';

  @override
  String get modify_account_password => 'Modify Account Password';

  @override
  String get bank_card_number => 'Bank Card Number';

  @override
  String get bank_card_tail_number => 'Tail Number 6789';

  @override
  String get manage_payment_info => 'Manage Payment Information';

  @override
  String get app_settings => 'App Settings';

  @override
  String get language_settings => 'Language Settings';

  @override
  String get select_app_language => 'Select App Language';

  @override
  String get logout_account => 'Logout Account';

  @override
  String get login_account => 'Login Account';

  @override
  String get exit_current_account => 'Exit Current Account';

  @override
  String get login_your_account => 'Login Your Account';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get view_app_privacy_terms => 'View App Privacy Terms';

  @override
  String get about_app => 'About App';

  @override
  String get version_info_and_help => 'Version Information and Help';

  @override
  String get please_login_to_view_account_info => 'Please login to view account information';

  @override
  String get please_login_first => 'Please login first';

  @override
  String get privacy_policy_page_under_development => 'Privacy policy page under development';

  @override
  String get about_page_under_development => 'About page under development';

  @override
  String get select_language => 'Select Language';

  @override
  String get language_switched_to => 'Language switched to';

  @override
  String get app_name => 'Refundo';

  @override
  String get app_slogan => 'Intelligent Refund Management System';

  @override
  String get starting_initialization => 'Starting initialization...';

  @override
  String get loading_user_data => 'Loading user data...';

  @override
  String get unknown_error => 'Unknown error';

  @override
  String get ready => 'Ready...';

  @override
  String get initializing => 'Initializing...';

  @override
  String get orders => 'Orders';

  @override
  String get refunds => 'Refunds';

  @override
  String get manage_orders => 'Manage Orders';

  @override
  String get cancel => 'Cancel';

  @override
  String get refund => 'Refund';

  @override
  String get select_at_least_one_order => 'Please select at least one order';

  @override
  String get refund_success_waiting_approval => 'Refund successful, please wait for approval';

  @override
  String get server_error => 'Server error';

  @override
  String get error => 'Error';

  @override
  String get total_amount => 'Total Amount';

  @override
  String get today_orders => 'Today\'s Orders';

  @override
  String get processing => 'Processing';

  @override
  String get camera_permission_required => 'Camera Permission Required';

  @override
  String get camera_permission_description => 'Scanning function requires access to your camera. Please enable camera permission for the app in system settings.';

  @override
  String get go_to_settings => 'Go to Settings';

  @override
  String get notification => 'Notification';

  @override
  String get confirm => 'Confirm';

  @override
  String get select_all => 'Select All';

  @override
  String selected_count(Object selectedCount, Object total) {
    return 'Selected $selectedCount/$total';
  }

  @override
  String get select_orders_to_refund => 'Select orders to refund';

  @override
  String get no_orders => 'No Orders';

  @override
  String get order_list_empty => 'Order list is empty';

  @override
  String get order_number => 'Order Number';

  @override
  String get time => 'Time';

  @override
  String get refundable => 'Refundable';

  @override
  String get no_withdrawal_records => 'No Withdrawal Records';

  @override
  String get withdrawal_records_will_appear_here => 'Withdrawal records will appear here';

  @override
  String get withdrawal_application => 'Withdrawal Application';

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String get withdrawal_details => 'Withdrawal Details';

  @override
  String get withdrawal_amount => 'Withdrawal Amount';

  @override
  String get application_time => 'Application Time';

  @override
  String get processing_status => 'Processing Status';

  @override
  String get payment_method => 'Payment Method';

  @override
  String get bank_card => 'Bank Card';

  @override
  String get close => 'Close';

  @override
  String get uid_label => 'UID';

  @override
  String get not_logged_in => 'Not Logged In';

  @override
  String get please_login_to_view_profile => 'Please login to view profile';

  @override
  String get card_change_title => 'Change Bank Card';

  @override
  String get enter_email => 'Enter email';

  @override
  String get enter_password => 'Enter Password';

  @override
  String get enter_new_card_number => 'Enter new bank card number';

  @override
  String get please_enter_complete_info => 'Please enter complete information';

  @override
  String get verification_success => 'Verification successful';

  @override
  String get email_or_password_incorrect => 'Email or password incorrect';

  @override
  String get verification_failed => 'Verification failed';

  @override
  String get please_enter_card_number => 'Please enter card number';

  @override
  String get modification_success => 'Modification successful';

  @override
  String get modification_failed => 'Modification failed';

  @override
  String get email_change_title => 'Change Email';

  @override
  String get enter_old_email => 'Enter old email';

  @override
  String get enter_new_email => 'Enter new email';

  @override
  String get please_enter_new_email => 'Please enter new email';

  @override
  String get invalid_email_format => 'Invalid email format';

  @override
  String get user_registration => 'User Registration';

  @override
  String get username => 'Username';

  @override
  String get email => 'Email';

  @override
  String get verification_code => 'Verification Code';

  @override
  String get get_verification_code => 'Get Code';

  @override
  String countdown_seconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get password => 'Password';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get register => 'Register';

  @override
  String get already_have_account => 'Already have an account?';

  @override
  String get login_now => 'Login Now';

  @override
  String get please_enter_username => 'Please enter username';

  @override
  String get please_enter_valid_email => 'Please enter a valid email address';

  @override
  String get please_enter_verification_code => 'Please enter verification code';

  @override
  String get password_length_at_least_6 => 'Password must be at least 6 characters';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get verification_code_send_failed => 'Verification code send failed, please try again';

  @override
  String get user_login => 'User Login';

  @override
  String get username_or_email => 'Username/Email';

  @override
  String get remember_me => 'Remember me';

  @override
  String get forgot_password => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get no_account_register_now => 'No account? Register now';

  @override
  String get please_enter_username_and_password => 'Please enter username and password';

  @override
  String get audit => 'Audit';

  @override
  String get audit_page => 'Audit Page';

  @override
  String get audit_records => 'Audit Records';

  @override
  String get detail_info => 'Detail Information';

  @override
  String get user_id => 'User ID';

  @override
  String get nickname => 'Nickname';

  @override
  String get refund_time => 'Refund Time';

  @override
  String get refund_method => 'Refund Method';

  @override
  String get refund_amount => 'Refund Amount';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get items => 'items';

  @override
  String get no_audit_records => 'No audit records';

  @override
  String get select_record_to_view => 'Select a record to view details';

  @override
  String get already_approved => 'Already approved';

  @override
  String get already_rejected => 'Already rejected';

  @override
  String get approve_success => 'Approved successfully';

  @override
  String get approve_failed => 'Approval failed';

  @override
  String get reject_success => 'Rejected successfully';

  @override
  String get reject_failed => 'Rejection failed';

  @override
  String get filter_conditions => 'Filter Conditions';

  @override
  String get time_range => 'Time Range';

  @override
  String get all => 'All';

  @override
  String get one_day => '24 Hours';

  @override
  String get one_week => '1 Week';

  @override
  String get one_month => '1 Month';

  @override
  String get approval_status => 'Approval Status';

  @override
  String get reset => 'Reset';

  @override
  String get no_records_found => 'No matching records found';

  @override
  String get adjust_filters => 'Please try adjusting your filters';

  @override
  String get not_manager => 'you are not a manager';

  @override
  String get refund_confirmation => 'Refund Confirmation';

  @override
  String total_amount_orders(Object selectedCount, Object totalAmount) {
    return 'Total: $totalAmount FCFA | $selectedCount orders';
  }

  @override
  String get select_payment_method => 'Select Payment Method';

  @override
  String get phone_payment => 'Phone';

  @override
  String get sanke_money => 'Sanke';

  @override
  String get wave_payment => 'WAVE';

  @override
  String get enter_phone_number => 'Enter phone number';

  @override
  String get invalid_phone_format => 'Invalid phone number format';

  @override
  String get enter_sanke_account => 'Enter Sanke Money account';

  @override
  String get account_length_at_least_6 => 'Account length at least 6 digits';

  @override
  String get enter_wave_account => 'Enter WAVE account ID';

  @override
  String get wave_account_start_with_wave => 'WAVE account ID should start with WAVE';

  @override
  String get confirm_phone_number => 'Confirm phone number';

  @override
  String get confirm_refund => 'Confirm Refund';

  @override
  String get scan_the_QR => 'Please scan the QR code';

  @override
  String get order_less_than_5_months => 'The order is less than 5 months old.';

  @override
  String get total_amount_less_than_5000 => 'The total order amount is less than 5,000,.';

  @override
  String get change_name => 'to change your name';

  @override
  String get save => 'Save';

  @override
  String get new_name => 'New Name';

  @override
  String get please_enter_name => 'Please enter a name';

  @override
  String get update_success => 'Update successful';

  @override
  String get callback_password => 'Retrieve Password';

  @override
  String get hint_enter_email => 'Please enter email';

  @override
  String get next_step => 'Next';

  @override
  String get hint_enter_verification_code => 'Please enter verification code';

  @override
  String get resend_verification_code => 'Resend';

  @override
  String resend_with_countdown(Object count) {
    return 'Resend ($count)';
  }

  @override
  String get please_enter_code_first => 'Please enter verification code first';

  @override
  String get verification_code_expired => 'Verification code expired, please resend';

  @override
  String get verification_code_correct => 'Verification code correct';

  @override
  String get verification_code_incorrect => 'Verification code incorrect';

  @override
  String get invalid_request_format => 'Invalid request format';

  @override
  String get verification_service_unavailable => 'Verification service temporarily unavailable, please try again later';

  @override
  String get please_get_code_first => 'Please get verification code first';

  @override
  String get verification_code_sent => 'Verification code has been sent to your email';

  @override
  String get verification_code_sent_success => 'Verification code sent successfully';

  @override
  String get email_send_failed => 'Email sending failed, please check email address or try again later';

  @override
  String get user_info_not_unique => 'User information not unique, please contact customer service';

  @override
  String get no_user_found_for_email => 'No user account found associated with this email';

  @override
  String get email_service_unavailable => 'Email service temporarily unavailable, please try again later';

  @override
  String get send_failed => 'Send failed';

  @override
  String get set_new_password => 'Set New Password';

  @override
  String get new_password => 'New Password';

  @override
  String get hint_enter_new_password => 'Please enter new password';

  @override
  String get hint_confirm_new_password => 'Please enter new password again';

  @override
  String get password_set_success => 'Password set successfully';

  @override
  String get sync_offline_orders => 'Sync Offline Orders';

  @override
  String get no_offline_orders => 'No offline orders to sync';

  @override
  String get syncing_offline_orders => 'Syncing offline orders...';

  @override
  String get sync_completed => 'Sync completed';

  @override
  String get orders_successfully => 'orders successfully';

  @override
  String get orders_failed => 'orders failed';

  @override
  String get sync_failed => 'Sync failed';

  @override
  String get sync_error => 'Sync error';

  @override
  String get failed_to_load_data => 'Failed to load data';

  @override
  String get statistics => 'Statistics';

  @override
  String get profile => 'Profile';

  @override
  String get total_orders => 'Total Orders';

  @override
  String get balance => 'Balance';

  @override
  String get total => 'Total';

  @override
  String get in_review => 'In Review';

  @override
  String submit_for_approval(Object count) {
    return 'Submit for Approval ($count)';
  }

  @override
  String get deselect_all => 'Deselect All';

  @override
  String get scan_to_add => 'Scan to Add';

  @override
  String selected_orders_count(Object count) {
    return '$count orders selected';
  }

  @override
  String estimated_refund(Object amount) {
    return 'Estimated Refund: $amount FCFA';
  }

  @override
  String order_number_with_hash(Object number) {
    return 'Order #$number';
  }

  @override
  String refund_amount_with_currency(Object amount) {
    return 'Refund: $amount FCFA';
  }

  @override
  String order_amount_with_currency(Object amount) {
    return 'Order: $amount FCFA';
  }

  @override
  String get order_details => 'Order Details';

  @override
  String get refund_details => 'Refund Details';

  @override
  String get product_id => 'Product ID';

  @override
  String get order_id_label => 'Order ID';

  @override
  String get creation_time => 'Creation Time';

  @override
  String get order_status_label => 'Order Status';

  @override
  String get refund_account => 'Refund Account';

  @override
  String get approval_status_label => 'Approval Status';

  @override
  String get refundable_status => 'Refundable';

  @override
  String get needs_multi_select => 'Needs Multi-Select';

  @override
  String get not_refundable => 'Not Refundable';

  @override
  String get already_refunded => 'Already Refunded';

  @override
  String wait_months(Object months) {
    return 'Wait $months months';
  }

  @override
  String get insufficient_amount_need_more => 'Insufficient Amount, Need More';

  @override
  String get got_it => 'Got it';

  @override
  String get insufficient_refund_amount_error => 'The order refund amount is less than 5000 FCFA, please select multiple orders for cumulative refund';

  @override
  String cumulative_amount_insufficient(Object amount) {
    return 'Cumulative refund amount is less than 5000 FCFA, at least $amount FCFA more needed. Please select more orders.';
  }

  @override
  String get contains_non_refundable_orders => 'Selected orders contain non-refundable orders, please check your selection';

  @override
  String get calculating_refund_amount => 'Calculating refund amount...';

  @override
  String get submitting_refund_application => 'Submitting refund application...';

  @override
  String get refund_application_submitted => 'Refund application submitted successfully!';

  @override
  String get network_error_check_connection => 'Network error, please check your connection';

  @override
  String get order_needs_5_months => 'Order must be 5 months old to apply for refund';

  @override
  String get refund_amount_less_than_5000 => 'Order refund amount is less than 5000, does not meet refund conditions';

  @override
  String get please_select_orders_first => 'Please select orders to refund first';

  @override
  String refund_failed_with_code(Object code) {
    return 'Refund application failed, error code: $code';
  }

  @override
  String get select_refund_method => 'Select Refund Method';

  @override
  String order_count_label(Object count) {
    return 'Order Count: $count';
  }

  @override
  String total_refund_amount_label(Object amount) {
    return 'Total Refund: $amount FCFA';
  }

  @override
  String get refund_method_label => 'Refund Method:';

  @override
  String get refund_account_optional => 'Refund Account (Optional)';

  @override
  String get submit => 'Submit';

  @override
  String get direct_submit_approval => 'Submit for Approval';

  @override
  String get orange_money => 'Orange Money';

  @override
  String get wave => 'Wave';

  @override
  String get phone_number_label => 'Phone Number';

  @override
  String get data_statistics => 'Data Statistics';

  @override
  String get order_heatmap => 'Order Heatmap';

  @override
  String get detailed_statistics => 'Detailed Statistics';

  @override
  String get average_order_amount => 'Average Order Amount';

  @override
  String get max_order_amount => 'Max Order Amount';

  @override
  String get total_orders_count => 'Total Orders Count';

  @override
  String get weekday_mon => 'Mon';

  @override
  String get weekday_tue => 'Tue';

  @override
  String get weekday_wed => 'Wed';

  @override
  String get weekday_thu => 'Thu';

  @override
  String get weekday_fri => 'Fri';

  @override
  String get weekday_sat => 'Sat';

  @override
  String get weekday_sun => 'Sun';

  @override
  String get heatmap_few => 'Few';

  @override
  String get heatmap_medium => 'Medium';

  @override
  String get heatmap_many => 'Many';

  @override
  String get heatmap_many_many => 'Very Many';

  @override
  String get guest_user => 'Guest User';

  @override
  String version_info(Object build, Object version) {
    return 'Version $version ($build)';
  }

  @override
  String get main_features => 'Main Features';

  @override
  String get open_source_license => 'Open Source License';

  @override
  String get view_third_party_licenses => 'View Third-Party Licenses';

  @override
  String get quick_links => 'Quick Links';

  @override
  String get feature_scan_orders => 'Scan to Add Orders';

  @override
  String get feature_manage_orders => 'Order Management & Filtering';

  @override
  String get feature_smart_refund => 'Smart Refund System';

  @override
  String get feature_data_statistics => 'Data Statistics & Analysis';

  @override
  String last_updated_date(Object date) {
    return 'Last Updated: $date';
  }

  @override
  String get invalid_qr_code => 'Invalid QR Code';

  @override
  String get illegal_qr_content => 'Illegal QR Content';

  @override
  String get qr_content_not_json => 'QR content is not valid JSON format';

  @override
  String get statistical_analysis => 'Statistical Analysis';

  @override
  String get this_week => 'This Week';

  @override
  String get this_month => 'This Month';

  @override
  String get this_quarter => 'This Quarter';

  @override
  String get this_year => 'This Year';

  @override
  String get orders_count => 'orders';

  @override
  String get fcfa => 'FCFA';

  @override
  String get order_statistics => 'Order Statistics';

  @override
  String get refund_statistics => 'Refund Statistics';

  @override
  String get smart_refund_management_system => 'Smart Refund Management System';

  @override
  String get refundo_app_name => 'RefundO';

  @override
  String get all_rights_reserved => 'All rights reserved';

  @override
  String get scan_history => 'Scan History';

  @override
  String get view_scan_history => 'View Scan History';

  @override
  String get help_and_feedback => 'Help & Feedback';

  @override
  String get faq => 'FAQ';

  @override
  String get clear_all => 'Clear All';

  @override
  String get delete => 'Delete';

  @override
  String get product_details => 'Product Details';

  @override
  String get price => 'Price';

  @override
  String get refund_percent => 'Refund Percent';

  @override
  String get rescan => 'Rescan';

  @override
  String get delete_history_item => 'Delete History Item';

  @override
  String get confirm_delete_scan_history => 'Confirm delete this scan history?';

  @override
  String get clear_all_history => 'Clear All History';

  @override
  String get confirm_clear_all_history => 'Confirm clear all scan history?';

  @override
  String get deleted_successfully => 'Deleted Successfully';

  @override
  String get history_cleared => 'History Cleared';

  @override
  String get no_scan_history => 'No Scan History';

  @override
  String get scan_products_to_see_history => 'Scan products to see history here';

  @override
  String get rescan_function_coming_soon => 'Rescan function coming soon';

  @override
  String get privacy_policy_title => 'Privacy Policy';

  @override
  String get info_collection => 'Information Collection';

  @override
  String get info_collection_1 => 'We collect the following types of information:';

  @override
  String get info_collection_2 => '• Personal Information: Including name, email address, phone number and bank card information';

  @override
  String get info_collection_3 => '• Order Information: Including purchase records, refund applications and transaction history';

  @override
  String get info_collection_4 => '• Usage Data: Including app usage and preferences';

  @override
  String get info_collection_5 => '• Device Information: Including device model, operating system version and unique identifier';

  @override
  String get info_usage => 'Information Usage';

  @override
  String get info_usage_1 => 'We use the collected information for:';

  @override
  String get info_usage_2 => '• Processing your orders and refund applications';

  @override
  String get info_usage_3 => '• Improving our services and features';

  @override
  String get info_usage_4 => '• Communicating with you, including customer support';

  @override
  String get info_usage_5 => '• Analyzing app usage to optimize user experience';

  @override
  String get info_usage_6 => '• Preventing fraud and ensuring security';

  @override
  String get info_sharing => 'Information Sharing';

  @override
  String get info_sharing_1 => 'We do not sell, rent or trade your personal information. We only share information in the following cases:';

  @override
  String get info_sharing_2 => '• With your explicit consent';

  @override
  String get info_sharing_3 => '• Necessary for processing transactions and services';

  @override
  String get info_sharing_4 => '• To comply with legal requirements or court orders';

  @override
  String get info_sharing_5 => '• To protect our rights, property or safety';

  @override
  String get info_sharing_6 => '• With trusted service providers (under confidentiality agreements)';

  @override
  String get data_security => 'Data Security';

  @override
  String get data_security_1 => 'We take the following measures to protect your information:';

  @override
  String get data_security_2 => '• Using SSL/TLS encryption to transmit data';

  @override
  String get data_security_3 => '• Secure storage of your password (encrypted hash)';

  @override
  String get data_security_4 => '• Regular security audits and vulnerability scanning';

  @override
  String get data_security_5 => '• Restricting employee access to personal information';

  @override
  String get data_security_6 => '• Requiring service providers to comply with strict security standards';

  @override
  String get your_rights => 'Your Rights';

  @override
  String get your_rights_1 => 'You have the following rights regarding your personal information:';

  @override
  String get your_rights_2 => '• Access Right: View information we hold about you';

  @override
  String get your_rights_3 => '• Correction Right: Update or correct inaccurate information';

  @override
  String get your_rights_4 => '• Deletion Right: Request deletion of your personal information';

  @override
  String get your_rights_5 => '• Objection Right: Object to certain data processing activities';

  @override
  String get your_rights_6 => '• Withdraw Consent: Withdraw previously given consent';

  @override
  String get your_rights_7 => '• Data Portability: Receive your data in a structured format';

  @override
  String get cookie_policy => 'Cookie Policy';

  @override
  String get cookie_policy_1 => 'We use cookies and similar technologies to:';

  @override
  String get cookie_policy_2 => '• Remember your login credentials';

  @override
  String get cookie_policy_3 => '• Remember your preferences';

  @override
  String get cookie_policy_4 => '• Analyze app performance';

  @override
  String get cookie_policy_5 => '• Provide personalized content';

  @override
  String get cookie_policy_6 => 'You can manage cookie preferences through your device settings';

  @override
  String get child_privacy => 'Child Privacy';

  @override
  String get child_privacy_1 => 'Our services are not directed at children under 13.';

  @override
  String get child_privacy_2 => 'If we discover we have collected personal information from children under 13,';

  @override
  String get child_privacy_3 => 'we will take steps to delete that information.';

  @override
  String get policy_changes => 'Policy Changes';

  @override
  String get policy_changes_1 => 'We may update this privacy policy from time to time.';

  @override
  String get policy_changes_2 => 'After changes, we will notify you within the app.';

  @override
  String get policy_changes_3 => 'Continued use of our services indicates acceptance of the updated policy.';

  @override
  String get policy_changes_4 => 'We recommend checking this page regularly for the latest information.';

  @override
  String get contact_us_section => 'Contact Us';

  @override
  String get contact_us_1 => 'If you have any questions or concerns about this privacy policy, please contact us:';

  @override
  String get contact_us_2 => '• Email: support@refundo.com';

  @override
  String get contact_us_3 => '• In-App Feedback: Settings > Help & Feedback';

  @override
  String get contact_us_4 => '• We will respond within 30 days';

  @override
  String get view_privacy_policy => 'View Privacy Policy';

  @override
  String get get_help_and_feedback => 'Get Help and Feedback';

  @override
  String get not_set => 'Not Set';

  @override
  String get search_help => 'Search help topics...';

  @override
  String get frequently_asked_questions => 'Frequently Asked Questions';

  @override
  String get faq1_question => 'How do I scan an order?';

  @override
  String get faq1_answer => 'Tap the scan button on the orders page and point your camera at the QR code on your receipt.';

  @override
  String get faq2_question => 'What are the refund requirements?';

  @override
  String get faq2_answer => 'Orders must be at least 5 months old and have a minimum refund amount of 5000 FCFA.';

  @override
  String get faq3_question => 'How long does refund processing take?';

  @override
  String get faq3_answer => 'Refund applications are typically processed within 3-5 business days.';

  @override
  String get faq4_question => 'Can I track my refund status?';

  @override
  String get faq4_answer => 'Yes, you can track your refund status in the Refunds section of the app.';

  @override
  String get video_tutorials => 'Video Tutorials';

  @override
  String get tutorial1_title => 'Getting Started with RefundO';

  @override
  String get tutorial1_desc => 'Learn the basics of scanning orders and requesting refunds';

  @override
  String get tutorial2_title => 'Advanced Features Guide';

  @override
  String get tutorial2_desc => 'Explore advanced features like batch refunds and statistics';

  @override
  String get contact_us => 'Contact Us';

  @override
  String get email_support => 'Email Support';

  @override
  String get email_support_address => 'support@refundo.com';

  @override
  String get phone_support => 'Phone Support';

  @override
  String get phone_support_number => '+237 XXX XXX XXX';

  @override
  String get whatsapp_support => 'WhatsApp Support';

  @override
  String get whatsapp_available => 'Available Mon-Fri 9:00-17:00';

  @override
  String get send_feedback => 'Send Feedback';

  @override
  String get feedback_description => 'We value your feedback! Please let us know how we can improve our services.';

  @override
  String get enter_your_feedback => 'Enter your feedback here...';

  @override
  String get submit_feedback => 'Submit Feedback';

  @override
  String get feedback_submitted_successfully => 'Thank you! Your feedback has been submitted successfully.';

  @override
  String get verify_identity => 'Verify Your Identity';

  @override
  String get new_email => 'New Email';

  @override
  String get confirm_new_email => 'Confirm Email';

  @override
  String get enter_old_password => 'Enter Old Password';

  @override
  String get please_enter_new_password => 'Please enter new password';

  @override
  String get please_enter_password => 'Please enter password';

  @override
  String get enter_password_to_verify => 'Please enter your password to verify your identity';

  @override
  String get enter_old_password_tip => 'Enter your current password to confirm the change';

  @override
  String get email_format_tip => 'Please enter a valid email address (e.g., example@domain.com)';

  @override
  String get emails_do_not_match => 'The email addresses do not match';

  @override
  String get tips => 'Tips';

  @override
  String get retry => 'Retry';

  @override
  String get no_orders_yet => 'No Orders Yet';

  @override
  String get scan_products_to_add_orders => 'Scan products to add orders';

  @override
  String get scan_now => 'Scan Now';

  @override
  String get no_refunds_yet => 'No Refunds Yet';

  @override
  String get submit_refund_requests_here => 'Submit refund requests here';

  @override
  String get date_range => 'Date Range';

  @override
  String get sort_by => 'Sort By';

  @override
  String get filter => 'Filter';

  @override
  String get apply => 'Apply';

  @override
  String get status => 'Status';

  @override
  String get transaction_failed => 'Transaction Failed';

  @override
  String get transaction_receipt => 'Transaction Receipt';

  @override
  String get few_label => 'Few';

  @override
  String get withdrawn => 'Withdrawn';

  @override
  String get pending_withdrawal => 'Pending Withdrawal';

  @override
  String get click_to_view_full_image => 'Tap to view full image';

  @override
  String get image_load_failed => 'Failed to load';

  @override
  String get no_orders_yet_detail => 'Scan QR code to add your first order';

  @override
  String get no_refunds_yet_detail => 'Your refund applications will appear here';

  @override
  String get no_search_results => 'No results found';

  @override
  String no_search_results_detail(Object query) {
    return 'No content found matching \"$query\"';
  }

  @override
  String get clear_search => 'Clear Search';

  @override
  String get network_connection_failed => 'Network Connection Failed';

  @override
  String get check_network_settings => 'Please check your network settings and try again';

  @override
  String get server_error_title => 'Server Error';

  @override
  String get server_error_detail => 'Server temporarily unavailable, please try again later';

  @override
  String get no_more_data => 'No more data';

  @override
  String get total_orders_label => 'Total Orders';

  @override
  String get orders_count_label => 'orders';

  @override
  String get total_amount_label => 'Total Amount';

  @override
  String get order_statistics_section => 'Order Statistics';

  @override
  String get todays_orders => 'Today\'s Orders';

  @override
  String get refund_statistics_section => 'Refund Statistics';

  @override
  String get pending_label => 'Pending';

  @override
  String get completed_label => 'Completed';

  @override
  String get registration_successful_please_login => 'Registration successful! Please login with your account';

  @override
  String get registration_failed_please_try_again => 'Registration failed, please try again';

  @override
  String get check_for_updates => 'Check for Updates';

  @override
  String get check_update_subtitle => 'Check if a new version is available';

  @override
  String get new_version_available => 'New Version Available';

  @override
  String get current_version => 'Current Version';

  @override
  String get download_size => 'Download Size';

  @override
  String get update_log => 'Update Log';

  @override
  String get no_update_log_available => 'No update log available';

  @override
  String get remind_later => 'Remind Later';

  @override
  String get update_now => 'Update Now';

  @override
  String get already_latest_version => 'Already Latest Version';

  @override
  String get check_update_failed => 'Check Update Failed';

  @override
  String get check_update_failed_message => 'Unable to check for updates. Please check your network connection.';

  @override
  String get downloading_update => 'Downloading and installing the update...';

  @override
  String get download_failed => 'Download failed. Please try again.';

  @override
  String get ok => 'OK';
}
