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
}
