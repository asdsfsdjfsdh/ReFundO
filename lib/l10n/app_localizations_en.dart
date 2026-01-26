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
  String get enter_password => 'Enter password';

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
  String get error_username_required => 'Username is required';

  @override
  String get error_username_length => 'Username must be 3-20 characters';

  @override
  String get error_email_required => 'Email is required';

  @override
  String get error_password_required => 'Password is required';

  @override
  String get error_password_length => 'Password must be 6-20 characters';

  @override
  String get error_code_required => 'Verification code is required';

  @override
  String get error_code_format => 'Invalid verification code format';

  @override
  String get error_account_repetition_username => 'Username already exists';

  @override
  String get error_account_repetition_email => 'Email already in use';

  @override
  String get error_code_send_too_frequently => 'Verification code sent too frequently, please try again later';

  @override
  String get error_server_signup_failed => 'Registration failed, please try again';

  @override
  String error_login_ip_locked(Object minutes) => 'IP is locked, please try again after $minutes minutes';

  @override
  String error_login_account_locked(Object minutes) => 'Account is locked, please try again after $minutes minutes';
}
