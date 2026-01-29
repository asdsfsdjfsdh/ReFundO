import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('zh')
  ];

  /// Bottom navigation bar home page naming.
  ///
  /// In en, this message translates to:
  /// **'home'**
  String get bottom_home_page;

  /// Bottom navigation bar setting page naming.
  ///
  /// In en, this message translates to:
  /// **'setting'**
  String get bottom_setting_page;

  /// Initial state prompt for the startup page.
  ///
  /// In en, this message translates to:
  /// **'Initializing，please wait patiently...'**
  String get start_initialization_starting;

  /// Initializing, Fetching data.
  ///
  /// In en, this message translates to:
  /// **'Fetching data...'**
  String get start_initialization_loadingData;

  /// Initialization completed.
  ///
  /// In en, this message translates to:
  /// **'Initialization completed.'**
  String get start_initialization_complete;

  /// Initialization in progress with unknown status
  ///
  /// In en, this message translates to:
  /// **'Initialization in progress with unknown status...'**
  String get start_initialization_unknown;

  /// No description provided for @account_settings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get account_settings;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @modify_login_email.
  ///
  /// In en, this message translates to:
  /// **'Modify Login Email'**
  String get modify_login_email;

  /// No description provided for @login_password.
  ///
  /// In en, this message translates to:
  /// **'Login Password'**
  String get login_password;

  /// No description provided for @modify_account_password.
  ///
  /// In en, this message translates to:
  /// **'Modify Account Password'**
  String get modify_account_password;

  /// No description provided for @bank_card_number.
  ///
  /// In en, this message translates to:
  /// **'Bank Card Number'**
  String get bank_card_number;

  /// No description provided for @bank_card_tail_number.
  ///
  /// In en, this message translates to:
  /// **'Tail Number 6789'**
  String get bank_card_tail_number;

  /// No description provided for @manage_payment_info.
  ///
  /// In en, this message translates to:
  /// **'Manage Payment Information'**
  String get manage_payment_info;

  /// No description provided for @app_settings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get app_settings;

  /// No description provided for @language_settings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get language_settings;

  /// No description provided for @select_app_language.
  ///
  /// In en, this message translates to:
  /// **'Select App Language'**
  String get select_app_language;

  /// No description provided for @logout_account.
  ///
  /// In en, this message translates to:
  /// **'Logout Account'**
  String get logout_account;

  /// No description provided for @login_account.
  ///
  /// In en, this message translates to:
  /// **'Login Account'**
  String get login_account;

  /// No description provided for @exit_current_account.
  ///
  /// In en, this message translates to:
  /// **'Exit Current Account'**
  String get exit_current_account;

  /// No description provided for @login_your_account.
  ///
  /// In en, this message translates to:
  /// **'Login Your Account'**
  String get login_your_account;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @view_app_privacy_terms.
  ///
  /// In en, this message translates to:
  /// **'View App Privacy Terms'**
  String get view_app_privacy_terms;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_app;

  /// No description provided for @version_info_and_help.
  ///
  /// In en, this message translates to:
  /// **'Version Information and Help'**
  String get version_info_and_help;

  /// No description provided for @please_login_to_view_account_info.
  ///
  /// In en, this message translates to:
  /// **'Please login to view account information'**
  String get please_login_to_view_account_info;

  /// No description provided for @please_login_first.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get please_login_first;

  /// No description provided for @privacy_policy_page_under_development.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy page under development'**
  String get privacy_policy_page_under_development;

  /// No description provided for @about_page_under_development.
  ///
  /// In en, this message translates to:
  /// **'About page under development'**
  String get about_page_under_development;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @language_switched_to.
  ///
  /// In en, this message translates to:
  /// **'Language switched to'**
  String get language_switched_to;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Refundo'**
  String get app_name;

  /// No description provided for @app_slogan.
  ///
  /// In en, this message translates to:
  /// **'Intelligent Refund Management System'**
  String get app_slogan;

  /// No description provided for @starting_initialization.
  ///
  /// In en, this message translates to:
  /// **'Starting initialization...'**
  String get starting_initialization;

  /// No description provided for @loading_user_data.
  ///
  /// In en, this message translates to:
  /// **'Loading user data...'**
  String get loading_user_data;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknown_error;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready...'**
  String get ready;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refunds;

  /// No description provided for @manage_orders.
  ///
  /// In en, this message translates to:
  /// **'Manage Orders'**
  String get manage_orders;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @select_at_least_one_order.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one order'**
  String get select_at_least_one_order;

  /// No description provided for @refund_success_waiting_approval.
  ///
  /// In en, this message translates to:
  /// **'Refund successful, please wait for approval'**
  String get refund_success_waiting_approval;

  /// No description provided for @server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get server_error;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount;

  /// No description provided for @today_orders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Orders'**
  String get today_orders;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @camera_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Required'**
  String get camera_permission_required;

  /// No description provided for @camera_permission_description.
  ///
  /// In en, this message translates to:
  /// **'Scanning function requires access to your camera. Please enable camera permission for the app in system settings.'**
  String get camera_permission_description;

  /// No description provided for @go_to_settings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get go_to_settings;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @select_all.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get select_all;

  /// No description provided for @selected_count.
  ///
  /// In en, this message translates to:
  /// **'Selected {selectedCount}/{total}'**
  String selected_count(Object selectedCount, Object total);

  /// No description provided for @select_orders_to_refund.
  ///
  /// In en, this message translates to:
  /// **'Select orders to refund'**
  String get select_orders_to_refund;

  /// No description provided for @no_orders.
  ///
  /// In en, this message translates to:
  /// **'No Orders'**
  String get no_orders;

  /// No description provided for @order_list_empty.
  ///
  /// In en, this message translates to:
  /// **'Order list is empty'**
  String get order_list_empty;

  /// No description provided for @order_number.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get order_number;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @refundable.
  ///
  /// In en, this message translates to:
  /// **'Refundable'**
  String get refundable;

  /// No description provided for @no_withdrawal_records.
  ///
  /// In en, this message translates to:
  /// **'No Withdrawal Records'**
  String get no_withdrawal_records;

  /// No description provided for @withdrawal_records_will_appear_here.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal records will appear here'**
  String get withdrawal_records_will_appear_here;

  /// No description provided for @withdrawal_application.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Application'**
  String get withdrawal_application;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @withdrawal_details.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Details'**
  String get withdrawal_details;

  /// No description provided for @withdrawal_amount.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Amount'**
  String get withdrawal_amount;

  /// No description provided for @application_time.
  ///
  /// In en, this message translates to:
  /// **'Application Time'**
  String get application_time;

  /// No description provided for @processing_status.
  ///
  /// In en, this message translates to:
  /// **'Processing Status'**
  String get processing_status;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @bank_card.
  ///
  /// In en, this message translates to:
  /// **'Bank Card'**
  String get bank_card;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @uid_label.
  ///
  /// In en, this message translates to:
  /// **'UID'**
  String get uid_label;

  /// No description provided for @not_logged_in.
  ///
  /// In en, this message translates to:
  /// **'Not Logged In'**
  String get not_logged_in;

  /// No description provided for @please_login_to_view_profile.
  ///
  /// In en, this message translates to:
  /// **'Please login to view profile'**
  String get please_login_to_view_profile;

  /// No description provided for @card_change_title.
  ///
  /// In en, this message translates to:
  /// **'Change Bank Card'**
  String get card_change_title;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enter_email;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enter_password;

  /// No description provided for @enter_new_card_number.
  ///
  /// In en, this message translates to:
  /// **'Enter new bank card number'**
  String get enter_new_card_number;

  /// No description provided for @please_enter_complete_info.
  ///
  /// In en, this message translates to:
  /// **'Please enter complete information'**
  String get please_enter_complete_info;

  /// No description provided for @verification_success.
  ///
  /// In en, this message translates to:
  /// **'Verification successful'**
  String get verification_success;

  /// No description provided for @email_or_password_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Email or password incorrect'**
  String get email_or_password_incorrect;

  /// No description provided for @verification_failed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verification_failed;

  /// No description provided for @please_enter_card_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter card number'**
  String get please_enter_card_number;

  /// No description provided for @modification_success.
  ///
  /// In en, this message translates to:
  /// **'Modification successful'**
  String get modification_success;

  /// No description provided for @modification_failed.
  ///
  /// In en, this message translates to:
  /// **'Modification failed'**
  String get modification_failed;

  /// No description provided for @email_change_title.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get email_change_title;

  /// No description provided for @enter_old_email.
  ///
  /// In en, this message translates to:
  /// **'Enter old email'**
  String get enter_old_email;

  /// No description provided for @enter_new_email.
  ///
  /// In en, this message translates to:
  /// **'Enter new email'**
  String get enter_new_email;

  /// No description provided for @please_enter_new_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter new email'**
  String get please_enter_new_email;

  /// No description provided for @invalid_email_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalid_email_format;

  /// No description provided for @user_registration.
  ///
  /// In en, this message translates to:
  /// **'User Registration'**
  String get user_registration;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @verification_code.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verification_code;

  /// No description provided for @get_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Get Code'**
  String get get_verification_code;

  /// No description provided for @countdown_seconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String countdown_seconds(Object seconds);

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_account;

  /// No description provided for @login_now.
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get login_now;

  /// No description provided for @please_enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get please_enter_username;

  /// No description provided for @please_enter_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get please_enter_valid_email;

  /// No description provided for @please_enter_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get please_enter_verification_code;

  /// No description provided for @password_length_at_least_6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_length_at_least_6;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @verification_code_send_failed.
  ///
  /// In en, this message translates to:
  /// **'Verification code send failed, please try again'**
  String get verification_code_send_failed;

  /// No description provided for @user_login.
  ///
  /// In en, this message translates to:
  /// **'User Login'**
  String get user_login;

  /// No description provided for @username_or_email.
  ///
  /// In en, this message translates to:
  /// **'Username/Email'**
  String get username_or_email;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @no_account_register_now.
  ///
  /// In en, this message translates to:
  /// **'No account? Register now'**
  String get no_account_register_now;

  /// No description provided for @please_enter_username_and_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter username and password'**
  String get please_enter_username_and_password;

  /// No description provided for @audit.
  ///
  /// In en, this message translates to:
  /// **'Audit'**
  String get audit;

  /// No description provided for @audit_page.
  ///
  /// In en, this message translates to:
  /// **'Audit Page'**
  String get audit_page;

  /// No description provided for @audit_records.
  ///
  /// In en, this message translates to:
  /// **'Audit Records'**
  String get audit_records;

  /// No description provided for @detail_info.
  ///
  /// In en, this message translates to:
  /// **'Detail Information'**
  String get detail_info;

  /// No description provided for @user_id.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get user_id;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @refund_time.
  ///
  /// In en, this message translates to:
  /// **'Refund Time'**
  String get refund_time;

  /// No description provided for @refund_method.
  ///
  /// In en, this message translates to:
  /// **'Refund Method'**
  String get refund_method;

  /// No description provided for @refund_amount.
  ///
  /// In en, this message translates to:
  /// **'Refund Amount'**
  String get refund_amount;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @no_audit_records.
  ///
  /// In en, this message translates to:
  /// **'No audit records'**
  String get no_audit_records;

  /// No description provided for @select_record_to_view.
  ///
  /// In en, this message translates to:
  /// **'Select a record to view details'**
  String get select_record_to_view;

  /// No description provided for @already_approved.
  ///
  /// In en, this message translates to:
  /// **'Already approved'**
  String get already_approved;

  /// No description provided for @already_rejected.
  ///
  /// In en, this message translates to:
  /// **'Already rejected'**
  String get already_rejected;

  /// No description provided for @approve_success.
  ///
  /// In en, this message translates to:
  /// **'Approved successfully'**
  String get approve_success;

  /// No description provided for @approve_failed.
  ///
  /// In en, this message translates to:
  /// **'Approval failed'**
  String get approve_failed;

  /// No description provided for @reject_success.
  ///
  /// In en, this message translates to:
  /// **'Rejected successfully'**
  String get reject_success;

  /// No description provided for @reject_failed.
  ///
  /// In en, this message translates to:
  /// **'Rejection failed'**
  String get reject_failed;

  /// No description provided for @filter_conditions.
  ///
  /// In en, this message translates to:
  /// **'Filter Conditions'**
  String get filter_conditions;

  /// No description provided for @time_range.
  ///
  /// In en, this message translates to:
  /// **'Time Range'**
  String get time_range;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @one_day.
  ///
  /// In en, this message translates to:
  /// **'24 Hours'**
  String get one_day;

  /// No description provided for @one_week.
  ///
  /// In en, this message translates to:
  /// **'1 Week'**
  String get one_week;

  /// No description provided for @one_month.
  ///
  /// In en, this message translates to:
  /// **'1 Month'**
  String get one_month;

  /// No description provided for @approval_status.
  ///
  /// In en, this message translates to:
  /// **'Approval Status'**
  String get approval_status;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @no_records_found.
  ///
  /// In en, this message translates to:
  /// **'No matching records found'**
  String get no_records_found;

  /// No description provided for @adjust_filters.
  ///
  /// In en, this message translates to:
  /// **'Please try adjusting your filters'**
  String get adjust_filters;

  /// No description provided for @not_manager.
  ///
  /// In en, this message translates to:
  /// **'you are not a manager'**
  String get not_manager;

  /// No description provided for @refund_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Refund Confirmation'**
  String get refund_confirmation;

  /// No description provided for @total_amount_orders.
  ///
  /// In en, this message translates to:
  /// **'Total: {totalAmount} FCFA | {selectedCount} orders'**
  String total_amount_orders(Object selectedCount, Object totalAmount);

  /// No description provided for @select_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get select_payment_method;

  /// No description provided for @phone_payment.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone_payment;

  /// No description provided for @sanke_money.
  ///
  /// In en, this message translates to:
  /// **'Sanke'**
  String get sanke_money;

  /// No description provided for @wave_payment.
  ///
  /// In en, this message translates to:
  /// **'WAVE'**
  String get wave_payment;

  /// No description provided for @enter_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enter_phone_number;

  /// No description provided for @invalid_phone_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get invalid_phone_format;

  /// No description provided for @enter_sanke_account.
  ///
  /// In en, this message translates to:
  /// **'Enter Sanke Money account'**
  String get enter_sanke_account;

  /// No description provided for @account_length_at_least_6.
  ///
  /// In en, this message translates to:
  /// **'Account length at least 6 digits'**
  String get account_length_at_least_6;

  /// No description provided for @enter_wave_account.
  ///
  /// In en, this message translates to:
  /// **'Enter WAVE account ID'**
  String get enter_wave_account;

  /// No description provided for @wave_account_start_with_wave.
  ///
  /// In en, this message translates to:
  /// **'WAVE account ID should start with WAVE'**
  String get wave_account_start_with_wave;

  /// No description provided for @confirm_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Confirm phone number'**
  String get confirm_phone_number;

  /// No description provided for @confirm_refund.
  ///
  /// In en, this message translates to:
  /// **'Confirm Refund'**
  String get confirm_refund;

  /// No description provided for @scan_the_QR.
  ///
  /// In en, this message translates to:
  /// **'Please scan the QR code'**
  String get scan_the_QR;

  /// No description provided for @order_less_than_5_months.
  ///
  /// In en, this message translates to:
  /// **'The order is less than 5 months old.'**
  String get order_less_than_5_months;

  /// No description provided for @total_amount_less_than_5000.
  ///
  /// In en, this message translates to:
  /// **'The total order amount is less than 5,000,.'**
  String get total_amount_less_than_5000;

  /// No description provided for @change_name.
  ///
  /// In en, this message translates to:
  /// **'to change your name'**
  String get change_name;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @new_name.
  ///
  /// In en, this message translates to:
  /// **'New Name'**
  String get new_name;

  /// No description provided for @please_enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get please_enter_name;

  /// No description provided for @update_success.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get update_success;

  /// No description provided for @callback_password.
  ///
  /// In en, this message translates to:
  /// **'Retrieve Password'**
  String get callback_password;

  /// No description provided for @hint_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get hint_enter_email;

  /// No description provided for @next_step.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next_step;

  /// No description provided for @hint_enter_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get hint_enter_verification_code;

  /// No description provided for @resend_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend_verification_code;

  /// No description provided for @resend_with_countdown.
  ///
  /// In en, this message translates to:
  /// **'Resend ({count})'**
  String resend_with_countdown(Object count);

  /// No description provided for @please_enter_code_first.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code first'**
  String get please_enter_code_first;

  /// No description provided for @verification_code_expired.
  ///
  /// In en, this message translates to:
  /// **'Verification code expired, please resend'**
  String get verification_code_expired;

  /// No description provided for @verification_code_correct.
  ///
  /// In en, this message translates to:
  /// **'Verification code correct'**
  String get verification_code_correct;

  /// No description provided for @verification_code_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Verification code incorrect'**
  String get verification_code_incorrect;

  /// No description provided for @invalid_request_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid request format'**
  String get invalid_request_format;

  /// No description provided for @verification_service_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Verification service temporarily unavailable, please try again later'**
  String get verification_service_unavailable;

  /// No description provided for @please_get_code_first.
  ///
  /// In en, this message translates to:
  /// **'Please get verification code first'**
  String get please_get_code_first;

  /// No description provided for @verification_code_sent.
  ///
  /// In en, this message translates to:
  /// **'Verification code has been sent to your email'**
  String get verification_code_sent;

  /// No description provided for @verification_code_sent_success.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get verification_code_sent_success;

  /// No description provided for @email_send_failed.
  ///
  /// In en, this message translates to:
  /// **'Email sending failed, please check email address or try again later'**
  String get email_send_failed;

  /// No description provided for @user_info_not_unique.
  ///
  /// In en, this message translates to:
  /// **'User information not unique, please contact customer service'**
  String get user_info_not_unique;

  /// No description provided for @no_user_found_for_email.
  ///
  /// In en, this message translates to:
  /// **'No user account found associated with this email'**
  String get no_user_found_for_email;

  /// No description provided for @email_service_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Email service temporarily unavailable, please try again later'**
  String get email_service_unavailable;

  /// No description provided for @send_failed.
  ///
  /// In en, this message translates to:
  /// **'Send failed'**
  String get send_failed;

  /// No description provided for @set_new_password.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get set_new_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @hint_enter_new_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get hint_enter_new_password;

  /// No description provided for @hint_confirm_new_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password again'**
  String get hint_confirm_new_password;

  /// No description provided for @password_set_success.
  ///
  /// In en, this message translates to:
  /// **'Password set successfully'**
  String get password_set_success;

  /// No description provided for @sync_offline_orders.
  ///
  /// In en, this message translates to:
  /// **'Sync offline orders'**
  String get sync_offline_orders;

  /// No description provided for @no_offline_orders.
  ///
  /// In en, this message translates to:
  /// **'No offline orders to sync'**
  String get no_offline_orders;

  /// No description provided for @syncing_offline_orders.
  ///
  /// In en, this message translates to:
  /// **'Syncing offline orders...'**
  String get syncing_offline_orders;

  /// No description provided for @sync_completed.
  ///
  /// In en, this message translates to:
  /// **'Sync completed'**
  String get sync_completed;

  /// No description provided for @orders_successfully.
  ///
  /// In en, this message translates to:
  /// **'orders synced successfully'**
  String get orders_successfully;

  /// No description provided for @orders_failed.
  ///
  /// In en, this message translates to:
  /// **'orders failed to sync'**
  String get orders_failed;

  /// No description provided for @sync_failed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get sync_failed;

  /// No description provided for @sync_error.
  ///
  /// In en, this message translates to:
  /// **'Sync error'**
  String get sync_error;

  // ==================== FAQ / 帮助与反馈 ====================

  /// 帮助与反馈页面标题
  ///
  /// In en, this message translates to:
  /// **'Help & Feedback'**
  String get help_and_feedback;

  /// 搜索帮助提示
  ///
  /// In en, this message translates to:
  /// **'Search help...'**
  String get search_help;

  /// 常见问题标题
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequently_asked_questions;

  /// FAQ缩写标题
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// FAQ 1: 如何申请退款？
  ///
  /// In en, this message translates to:
  /// **'How do I apply for a refund?'**
  String get faq1_question;

  /// FAQ 1 答案: 在订单页面选择您想要退款的商品，点击"退款"按钮，填写退款原因后提交申请
  ///
  /// In en, this message translates to:
  ///  **'On the order page, select the items you want to refund, click the "Refund" button, provide a reason and submit your application'**
  String get faq1_answer;

  /// FAQ 2: 退款需要多长时间？
  ///
  /// In en, this message translates to:
  ///  **'How long does the refund process take?'**
  String get faq2_question;

  /// FAQ 2 答案: 退款处理通常需要5-15个工作日，具体时间取决于银行和支付方式
  ///
  /// In en, this message translates to:
  ///  **'The refund process typically takes 5-15 business days, depending on the bank and payment method'**
  String get faq2_answer;

  /// FAQ 3: 退款申请被拒绝了怎么办？
  ///
  /// In en, this message translates to:
  ///  **'What if my refund application is rejected?'**
  String get faq3_question;

  /// FAQ 3 答案: 如果被拒绝，您可以查看拒绝原因，修改后重新提交申请，或联系客服寻求帮助
  ///
  /// In en, this message translates to:
  ///  **'If rejected, you can view the rejection reason, modify and resubmit your application, or contact customer support for assistance'**
  String get faq3_answer;

  /// FAQ 4: 如何查看退款进度？
  ///
  /// In en, this message translates to:
  ///  **'How do I check my refund status?'**
  String get faq4_question;

  /// FAQ 4 答案: 在"退款"页面可以查看所有退款申请的状态，包括"处理中"、"已批准"、"已拒绝"等
  ///
  /// In en, this message translates to:
  ///  **'On the "Refunds" page, you can view the status of all refund applications, including "Processing", "Approved", "Rejected", etc.'**
  String get faq4_answer;

  /// 视频教程标题
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get video_tutorials;

  /// 教程1: 如何扫描商品
  ///
  /// In en, this message translates to:
  ///  **'How to scan products'**
  String get tutorial1_title;

  /// 教程1描述: 扫描商品的步骤演示
  ///
  /// In en, this message translates to:
  ///  **'Step-by-step guide on scanning products'**
  String get tutorial1_desc;

  /// 教程2: 如何申请退款
  ///
  /// In en, this message translates to:
  ///  **'How to apply for refund'**
  String get tutorial2_title;

  /// 教程2描述: 退款申请的详细流程
  ///
  /// In en, this message translates to:
  ///  **'Detailed process of refund application'**
  String get tutorial2_desc;

  /// 联系我们标题
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// 邮件支持
  ///
  /// In en, this message translates to:
  ///  **'Email Support'**
  String get email_support;

  /// 邮件地址
  ///
  /// In en, this message translates to:
  ///  **'support@refundo.com'**
  String get email_support_address;

  /// 电话支持
  ///
  /// In en, this message translates to:
  ///  **'Phone Support'**
  String get phone_support;

  /// 电话号码
  ///
  /// In en, this message translates to:
  ///  **'+1234567890'**
  String get phone_support_number;

  /// WhatsApp支持
  ///
  /// In en, this message translates to:
  ///  **'WhatsApp Support'**
  String get whatsapp_support;

  /// WhatsApp可用时间
  ///
  /// In en, this message translates to:
  ///  **'Available on WhatsApp'**
  String get whatsapp_available;

  /// 发送反馈标题
  ///
  /// In en, this message translates to:
  ///  **'Send Feedback'**
  String get send_feedback;

  /// 反馈描述
  ///
  /// In en, this message translates to:
  ///  **'Please describe your problem or suggestion in detail. We will do our best to solve it for you.'**
  String get feedback_description;

  /// 输入反馈提示
  ///
  /// In en, this message translates to:
  ///  **'Enter your feedback here...'**
  String get enter_your_feedback;

  /// 提交反馈按钮
  ///
  /// In en, this message translates to:
  ///  **'Submit'**
  String get submit_feedback;

  /// 反馈提交成功提示
  ///
  /// In en, this message translates to:
  ///  **'Feedback submitted successfully'**
  String get feedback_submitted_successfully;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
