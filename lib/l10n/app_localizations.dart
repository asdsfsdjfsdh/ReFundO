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

  /// No description provided for @error_username_required.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get error_username_required;

  /// No description provided for @error_username_length.
  ///
  /// In en, this message translates to:
  /// **'Username must be 3-20 characters'**
  String get error_username_length;

  /// No description provided for @error_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get error_email_required;

  /// No description provided for @error_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get error_password_required;

  /// No description provided for @error_password_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be 6-20 characters'**
  String get error_password_length;

  /// No description provided for @error_code_required.
  ///
  /// In en, this message translates to:
  /// **'Verification code is required'**
  String get error_code_required;

  /// No description provided for @error_code_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code format'**
  String get error_code_format;

  /// No description provided for @error_account_repetition_username.
  ///
  /// In en, this message translates to:
  /// **'Username already exists'**
  String get error_account_repetition_username;

  /// No description provided for @error_account_repetition_email.
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get error_account_repetition_email;

  /// No description provided for @error_code_send_too_frequently.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent too frequently, please try again later'**
  String get error_code_send_too_frequently;

  /// No description provided for @error_server_signup_failed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed, please try again'**
  String get error_server_signup_failed;

  /// No description provided for @error_login_ip_locked.
  ///
  /// In en, this message translates to:
  /// **'IP is locked, please try again after {minutes} minutes'**
  String error_login_ip_locked(Object minutes);

  /// No description provided for @error_login_account_locked.
  ///
  /// In en, this message translates to:
  /// **'Account is locked, please try again after {minutes} minutes'**
  String error_login_account_locked(Object minutes);

  /// No description provided for @login_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get login_success;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get register_success;

  /// No description provided for @get_user_info_success.
  ///
  /// In en, this message translates to:
  /// **'User info retrieved successfully'**
  String get get_user_info_success;

  /// No description provided for @update_username_success.
  ///
  /// In en, this message translates to:
  /// **'Username updated successfully'**
  String get update_username_success;

  /// No description provided for @update_password_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get update_password_success;

  /// No description provided for @update_email_success.
  ///
  /// In en, this message translates to:
  /// **'Email updated successfully'**
  String get update_email_success;

  /// No description provided for @update_phone_success.
  ///
  /// In en, this message translates to:
  /// **'Phone number updated successfully'**
  String get update_phone_success;

  /// No description provided for @send_email_success.
  ///
  /// In en, this message translates to:
  /// **'Email sent successfully'**
  String get send_email_success;

  /// No description provided for @create_order_success.
  ///
  /// In en, this message translates to:
  /// **'Order created successfully'**
  String get create_order_success;

  /// No description provided for @get_orders_success.
  ///
  /// In en, this message translates to:
  /// **'Order list retrieved successfully'**
  String get get_orders_success;

  /// No description provided for @create_refund_success.
  ///
  /// In en, this message translates to:
  /// **'Refund request submitted successfully'**
  String get create_refund_success;

  /// No description provided for @get_refunds_success.
  ///
  /// In en, this message translates to:
  /// **'Refund list retrieved successfully'**
  String get get_refunds_success;

  /// No description provided for @scan_product_success.
  ///
  /// In en, this message translates to:
  /// **'Product scanned successfully'**
  String get scan_product_success;

  /// No description provided for @get_product_success.
  ///
  /// In en, this message translates to:
  /// **'Product info retrieved successfully'**
  String get get_product_success;

  /// No description provided for @network_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout, please check network connection'**
  String get network_timeout;

  /// No description provided for @network_error.
  ///
  /// In en, this message translates to:
  /// **'Network connection failed'**
  String get network_error;

  /// No description provided for @server_error_404.
  ///
  /// In en, this message translates to:
  /// **'Requested resource not found'**
  String get server_error_404;

  /// No description provided for @server_error_500.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get server_error_500;

  /// No description provided for @feedback_title.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback_title;

  /// No description provided for @feedback_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We value every feedback you provide'**
  String get feedback_subtitle;

  /// No description provided for @feedback_tab_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get feedback_tab_submit;

  /// No description provided for @feedback_tab_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get feedback_tab_history;

  /// No description provided for @feedback_type_label.
  ///
  /// In en, this message translates to:
  /// **'Feedback Type'**
  String get feedback_type_label;

  /// No description provided for @feedback_content_label.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get feedback_content_label;

  /// No description provided for @feedback_content_hint.
  ///
  /// In en, this message translates to:
  /// **'Please describe your issue, suggestion or complaint in detail...'**
  String get feedback_content_hint;

  /// No description provided for @feedback_content_min_chars.
  ///
  /// In en, this message translates to:
  /// **'At least 10 characters'**
  String get feedback_content_min_chars;

  /// No description provided for @feedback_contact_label.
  ///
  /// In en, this message translates to:
  /// **'Contact (Optional)'**
  String get feedback_contact_label;

  /// No description provided for @feedback_contact_hint.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get feedback_contact_hint;

  /// No description provided for @feedback_upload_label.
  ///
  /// In en, this message translates to:
  /// **'Screenshot (Optional)'**
  String get feedback_upload_label;

  /// No description provided for @feedback_upload_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload screenshot'**
  String get feedback_upload_hint;

  /// No description provided for @feedback_upload_format_hint.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG format, max 5MB'**
  String get feedback_upload_format_hint;

  /// No description provided for @feedback_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get feedback_submit;

  /// No description provided for @feedback_submit_success.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully, thank you!'**
  String get feedback_submit_success;

  /// No description provided for @feedback_submit_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit feedback, please try again'**
  String get feedback_submit_failed;

  /// No description provided for @feedback_no_records.
  ///
  /// In en, this message translates to:
  /// **'No feedback records'**
  String get feedback_no_records;

  /// No description provided for @feedback_withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get feedback_withdraw;

  /// No description provided for @feedback_withdraw_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Withdraw'**
  String get feedback_withdraw_confirm_title;

  /// No description provided for @feedback_withdraw_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to withdraw this feedback?'**
  String get feedback_withdraw_confirm_message;

  /// No description provided for @feedback_withdraw_success.
  ///
  /// In en, this message translates to:
  /// **'Feedback withdrawn'**
  String get feedback_withdraw_success;

  /// No description provided for @feedback_withdraw_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to withdraw'**
  String get feedback_withdraw_failed;

  /// No description provided for @feedback_detail_title.
  ///
  /// In en, this message translates to:
  /// **'Feedback Details'**
  String get feedback_detail_title;

  /// No description provided for @feedback_status_label.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get feedback_status_label;

  /// No description provided for @feedback_time_label.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get feedback_time_label;

  /// No description provided for @feedback_attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get feedback_attachment;

  /// No description provided for @error_feedback_content_length.
  ///
  /// In en, this message translates to:
  /// **'Content must be 10-1000 characters'**
  String get error_feedback_content_length;

  /// No description provided for @error_feedback_file_too_large.
  ///
  /// In en, this message translates to:
  /// **'File size cannot exceed 5MB'**
  String get error_feedback_file_too_large;

  /// No description provided for @error_feedback_file_format.
  ///
  /// In en, this message translates to:
  /// **'Only JPG and PNG formats are supported'**
  String get error_feedback_file_format;

  /// No description provided for @error_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed, please try again'**
  String get error_upload_failed;

  /// No description provided for @get_feedbacks_success.
  ///
  /// In en, this message translates to:
  /// **'Feedback list retrieved successfully'**
  String get get_feedbacks_success;

  /// No description provided for @get_feedbacks_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve feedback list'**
  String get get_feedbacks_failed;

  /// No description provided for @faq_title.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get faq_title;

  /// No description provided for @faq_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search questions...'**
  String get faq_search_hint;

  /// No description provided for @faq_categories.
  ///
  /// In en, this message translates to:
  /// **'Quick Categories'**
  String get faq_categories;

  /// No description provided for @faq_popular.
  ///
  /// In en, this message translates to:
  /// **'Popular Questions'**
  String get faq_popular;

  /// No description provided for @faq_view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get faq_view_all;

  /// No description provided for @faq_no_results.
  ///
  /// In en, this message translates to:
  /// **'No matching questions found'**
  String get faq_no_results;

  /// No description provided for @faq_contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get faq_contact_support;

  /// No description provided for @faq_category_refund.
  ///
  /// In en, this message translates to:
  /// **'Refund Process'**
  String get faq_category_refund;

  /// No description provided for @faq_category_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get faq_category_account;

  /// No description provided for @faq_category_scan.
  ///
  /// In en, this message translates to:
  /// **'Product Scan'**
  String get faq_category_scan;

  /// No description provided for @faq_category_refund_desc.
  ///
  /// In en, this message translates to:
  /// **'Apply for refund'**
  String get faq_category_refund_desc;

  /// No description provided for @faq_category_account_desc.
  ///
  /// In en, this message translates to:
  /// **'Login & Register'**
  String get faq_category_account_desc;

  /// No description provided for @faq_category_scan_desc.
  ///
  /// In en, this message translates to:
  /// **'Scan to query'**
  String get faq_category_scan_desc;

  /// No description provided for @get_faqs_success.
  ///
  /// In en, this message translates to:
  /// **'FAQ list retrieved successfully'**
  String get get_faqs_success;

  /// No description provided for @get_faqs_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve FAQ list'**
  String get get_faqs_failed;

  /// No description provided for @get_faq_success.
  ///
  /// In en, this message translates to:
  /// **'FAQ details retrieved successfully'**
  String get get_faq_success;

  /// No description provided for @get_faq_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve FAQ details'**
  String get get_faq_failed;

  /// No description provided for @get_categories_success.
  ///
  /// In en, this message translates to:
  /// **'Category list retrieved successfully'**
  String get get_categories_success;

  /// No description provided for @get_categories_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve category list'**
  String get get_categories_failed;

  /// No description provided for @get_category_success.
  ///
  /// In en, this message translates to:
  /// **'Category details retrieved successfully'**
  String get get_category_success;

  /// No description provided for @get_category_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve category details'**
  String get get_category_failed;

  /// No description provided for @faq_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get faq_close;

  /// No description provided for @faq_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get faq_all;

  /// No description provided for @faq_pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get faq_pinned;

  /// No description provided for @faq_contact_support_hint.
  ///
  /// In en, this message translates to:
  /// **'If you need more help, please contact us'**
  String get faq_contact_support_hint;
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
