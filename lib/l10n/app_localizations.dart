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
  /// **'Enter Password'**
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
  /// **'Sync Offline Orders'**
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
  /// **'orders successfully'**
  String get orders_successfully;

  /// No description provided for @orders_failed.
  ///
  /// In en, this message translates to:
  /// **'orders failed'**
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

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @total_orders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get total_orders;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @in_review.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get in_review;

  /// No description provided for @submit_for_approval.
  ///
  /// In en, this message translates to:
  /// **'Submit for Approval ({count})'**
  String submit_for_approval(Object count);

  /// No description provided for @deselect_all.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselect_all;

  /// No description provided for @scan_to_add.
  ///
  /// In en, this message translates to:
  /// **'Scan to Add'**
  String get scan_to_add;

  /// No description provided for @selected_orders_count.
  ///
  /// In en, this message translates to:
  /// **'{count} orders selected'**
  String selected_orders_count(Object count);

  /// No description provided for @estimated_refund.
  ///
  /// In en, this message translates to:
  /// **'Estimated Refund: {amount} FCFA'**
  String estimated_refund(Object amount);

  /// No description provided for @order_number_with_hash.
  ///
  /// In en, this message translates to:
  /// **'Order #{number}'**
  String order_number_with_hash(Object number);

  /// No description provided for @refund_amount_with_currency.
  ///
  /// In en, this message translates to:
  /// **'Refund: {amount} FCFA'**
  String refund_amount_with_currency(Object amount);

  /// No description provided for @order_amount_with_currency.
  ///
  /// In en, this message translates to:
  /// **'Order: {amount} FCFA'**
  String order_amount_with_currency(Object amount);

  /// No description provided for @order_details.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get order_details;

  /// No description provided for @refund_details.
  ///
  /// In en, this message translates to:
  /// **'Refund Details'**
  String get refund_details;

  /// No description provided for @product_id.
  ///
  /// In en, this message translates to:
  /// **'Product ID'**
  String get product_id;

  /// No description provided for @order_id_label.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get order_id_label;

  /// No description provided for @creation_time.
  ///
  /// In en, this message translates to:
  /// **'Creation Time'**
  String get creation_time;

  /// No description provided for @order_status_label.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get order_status_label;

  /// No description provided for @refund_account.
  ///
  /// In en, this message translates to:
  /// **'Refund Account'**
  String get refund_account;

  /// No description provided for @approval_status_label.
  ///
  /// In en, this message translates to:
  /// **'Approval Status'**
  String get approval_status_label;

  /// No description provided for @refundable_status.
  ///
  /// In en, this message translates to:
  /// **'Refundable'**
  String get refundable_status;

  /// No description provided for @needs_multi_select.
  ///
  /// In en, this message translates to:
  /// **'Needs Multi-Select'**
  String get needs_multi_select;

  /// No description provided for @not_refundable.
  ///
  /// In en, this message translates to:
  /// **'Not Refundable'**
  String get not_refundable;

  /// No description provided for @already_refunded.
  ///
  /// In en, this message translates to:
  /// **'Already Refunded'**
  String get already_refunded;

  /// No description provided for @wait_months.
  ///
  /// In en, this message translates to:
  /// **'Wait {months} months'**
  String wait_months(Object months);

  /// No description provided for @insufficient_amount_need_more.
  ///
  /// In en, this message translates to:
  /// **'Insufficient Amount, Need More'**
  String get insufficient_amount_need_more;

  /// No description provided for @got_it.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get got_it;

  /// No description provided for @insufficient_refund_amount_error.
  ///
  /// In en, this message translates to:
  /// **'The order refund amount is less than 5000 FCFA, please select multiple orders for cumulative refund'**
  String get insufficient_refund_amount_error;

  /// No description provided for @cumulative_amount_insufficient.
  ///
  /// In en, this message translates to:
  /// **'Cumulative refund amount is less than 5000 FCFA, at least {amount} FCFA more needed. Please select more orders.'**
  String cumulative_amount_insufficient(Object amount);

  /// No description provided for @contains_non_refundable_orders.
  ///
  /// In en, this message translates to:
  /// **'Selected orders contain non-refundable orders, please check your selection'**
  String get contains_non_refundable_orders;

  /// No description provided for @submitting_refund_application.
  ///
  /// In en, this message translates to:
  /// **'Submitting refund application...'**
  String get submitting_refund_application;

  /// No description provided for @refund_application_submitted.
  ///
  /// In en, this message translates to:
  /// **'Refund application submitted successfully!'**
  String get refund_application_submitted;

  /// No description provided for @network_error_check_connection.
  ///
  /// In en, this message translates to:
  /// **'Network error, please check your connection'**
  String get network_error_check_connection;

  /// No description provided for @order_needs_5_months.
  ///
  /// In en, this message translates to:
  /// **'Order must be 5 months old to apply for refund'**
  String get order_needs_5_months;

  /// No description provided for @refund_amount_less_than_5000.
  ///
  /// In en, this message translates to:
  /// **'Order refund amount is less than 5000, does not meet refund conditions'**
  String get refund_amount_less_than_5000;

  /// No description provided for @please_select_orders_first.
  ///
  /// In en, this message translates to:
  /// **'Please select orders to refund first'**
  String get please_select_orders_first;

  /// No description provided for @refund_failed_with_code.
  ///
  /// In en, this message translates to:
  /// **'Refund application failed, error code: {code}'**
  String refund_failed_with_code(Object code);

  /// No description provided for @select_refund_method.
  ///
  /// In en, this message translates to:
  /// **'Select Refund Method'**
  String get select_refund_method;

  /// No description provided for @order_count_label.
  ///
  /// In en, this message translates to:
  /// **'Order Count: {count}'**
  String order_count_label(Object count);

  /// No description provided for @total_refund_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Total Refund: {amount} FCFA'**
  String total_refund_amount_label(Object amount);

  /// No description provided for @refund_method_label.
  ///
  /// In en, this message translates to:
  /// **'Refund Method:'**
  String get refund_method_label;

  /// No description provided for @refund_account_optional.
  ///
  /// In en, this message translates to:
  /// **'Refund Account (Optional)'**
  String get refund_account_optional;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @direct_submit_approval.
  ///
  /// In en, this message translates to:
  /// **'Submit for Approval'**
  String get direct_submit_approval;

  /// No description provided for @orange_money.
  ///
  /// In en, this message translates to:
  /// **'Orange Money'**
  String get orange_money;

  /// No description provided for @wave.
  ///
  /// In en, this message translates to:
  /// **'Wave'**
  String get wave;

  /// No description provided for @phone_number_label.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number_label;

  /// No description provided for @data_statistics.
  ///
  /// In en, this message translates to:
  /// **'Data Statistics'**
  String get data_statistics;

  /// No description provided for @order_heatmap.
  ///
  /// In en, this message translates to:
  /// **'Order Heatmap'**
  String get order_heatmap;

  /// No description provided for @detailed_statistics.
  ///
  /// In en, this message translates to:
  /// **'Detailed Statistics'**
  String get detailed_statistics;

  /// No description provided for @average_order_amount.
  ///
  /// In en, this message translates to:
  /// **'Average Order Amount'**
  String get average_order_amount;

  /// No description provided for @max_order_amount.
  ///
  /// In en, this message translates to:
  /// **'Max Order Amount'**
  String get max_order_amount;

  /// No description provided for @total_orders_count.
  ///
  /// In en, this message translates to:
  /// **'Total Orders Count'**
  String get total_orders_count;

  /// No description provided for @weekday_mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekday_mon;

  /// No description provided for @weekday_tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekday_tue;

  /// No description provided for @weekday_wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekday_wed;

  /// No description provided for @weekday_thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekday_thu;

  /// No description provided for @weekday_fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekday_fri;

  /// No description provided for @weekday_sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekday_sat;

  /// No description provided for @weekday_sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekday_sun;

  /// No description provided for @heatmap_few.
  ///
  /// In en, this message translates to:
  /// **'Few'**
  String get heatmap_few;

  /// No description provided for @heatmap_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get heatmap_medium;

  /// No description provided for @heatmap_many.
  ///
  /// In en, this message translates to:
  /// **'Many'**
  String get heatmap_many;

  /// No description provided for @heatmap_many_many.
  ///
  /// In en, this message translates to:
  /// **'Very Many'**
  String get heatmap_many_many;

  /// No description provided for @guest_user.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guest_user;

  /// No description provided for @version_info.
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({build})'**
  String version_info(Object build, Object version);

  /// No description provided for @main_features.
  ///
  /// In en, this message translates to:
  /// **'Main Features'**
  String get main_features;

  /// No description provided for @open_source_license.
  ///
  /// In en, this message translates to:
  /// **'Open Source License'**
  String get open_source_license;

  /// No description provided for @view_third_party_licenses.
  ///
  /// In en, this message translates to:
  /// **'View Third-Party Licenses'**
  String get view_third_party_licenses;

  /// No description provided for @quick_links.
  ///
  /// In en, this message translates to:
  /// **'Quick Links'**
  String get quick_links;

  /// No description provided for @feature_scan_orders.
  ///
  /// In en, this message translates to:
  /// **'Scan to Add Orders'**
  String get feature_scan_orders;

  /// No description provided for @feature_manage_orders.
  ///
  /// In en, this message translates to:
  /// **'Order Management & Filtering'**
  String get feature_manage_orders;

  /// No description provided for @feature_smart_refund.
  ///
  /// In en, this message translates to:
  /// **'Smart Refund System'**
  String get feature_smart_refund;

  /// No description provided for @feature_data_statistics.
  ///
  /// In en, this message translates to:
  /// **'Data Statistics & Analysis'**
  String get feature_data_statistics;

  /// No description provided for @last_updated_date.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {date}'**
  String last_updated_date(Object date);

  /// No description provided for @invalid_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code'**
  String get invalid_qr_code;

  /// No description provided for @illegal_qr_content.
  ///
  /// In en, this message translates to:
  /// **'Illegal QR Content'**
  String get illegal_qr_content;

  /// No description provided for @qr_content_not_json.
  ///
  /// In en, this message translates to:
  /// **'QR content is not valid JSON format'**
  String get qr_content_not_json;

  /// No description provided for @statistical_analysis.
  ///
  /// In en, this message translates to:
  /// **'Statistical Analysis'**
  String get statistical_analysis;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get this_week;

  /// No description provided for @this_month.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get this_month;

  /// No description provided for @this_quarter.
  ///
  /// In en, this message translates to:
  /// **'This Quarter'**
  String get this_quarter;

  /// No description provided for @this_year.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get this_year;

  /// No description provided for @orders_count.
  ///
  /// In en, this message translates to:
  /// **'orders'**
  String get orders_count;

  /// No description provided for @fcfa.
  ///
  /// In en, this message translates to:
  /// **'FCFA'**
  String get fcfa;

  /// No description provided for @order_statistics.
  ///
  /// In en, this message translates to:
  /// **'Order Statistics'**
  String get order_statistics;

  /// No description provided for @refund_statistics.
  ///
  /// In en, this message translates to:
  /// **'Refund Statistics'**
  String get refund_statistics;

  /// No description provided for @smart_refund_management_system.
  ///
  /// In en, this message translates to:
  /// **'Smart Refund Management System'**
  String get smart_refund_management_system;

  /// No description provided for @refundo_app_name.
  ///
  /// In en, this message translates to:
  /// **'RefundO'**
  String get refundo_app_name;

  /// No description provided for @all_rights_reserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved'**
  String get all_rights_reserved;

  /// No description provided for @scan_history.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scan_history;

  /// No description provided for @view_scan_history.
  ///
  /// In en, this message translates to:
  /// **'View Scan History'**
  String get view_scan_history;

  /// No description provided for @help_and_feedback.
  ///
  /// In en, this message translates to:
  /// **'Help & Feedback'**
  String get help_and_feedback;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clear_all;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @product_details.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @refund_percent.
  ///
  /// In en, this message translates to:
  /// **'Refund Percent'**
  String get refund_percent;

  /// No description provided for @rescan.
  ///
  /// In en, this message translates to:
  /// **'Rescan'**
  String get rescan;

  /// No description provided for @delete_history_item.
  ///
  /// In en, this message translates to:
  /// **'Delete History Item'**
  String get delete_history_item;

  /// No description provided for @confirm_delete_scan_history.
  ///
  /// In en, this message translates to:
  /// **'Confirm delete this scan history?'**
  String get confirm_delete_scan_history;

  /// No description provided for @clear_all_history.
  ///
  /// In en, this message translates to:
  /// **'Clear All History'**
  String get clear_all_history;

  /// No description provided for @confirm_clear_all_history.
  ///
  /// In en, this message translates to:
  /// **'Confirm clear all scan history?'**
  String get confirm_clear_all_history;

  /// No description provided for @deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted Successfully'**
  String get deleted_successfully;

  /// No description provided for @history_cleared.
  ///
  /// In en, this message translates to:
  /// **'History Cleared'**
  String get history_cleared;

  /// No description provided for @no_scan_history.
  ///
  /// In en, this message translates to:
  /// **'No Scan History'**
  String get no_scan_history;

  /// No description provided for @scan_products_to_see_history.
  ///
  /// In en, this message translates to:
  /// **'Scan products to see history here'**
  String get scan_products_to_see_history;

  /// No description provided for @rescan_function_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Rescan function coming soon'**
  String get rescan_function_coming_soon;

  /// No description provided for @privacy_policy_title.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy_title;

  /// No description provided for @info_collection.
  ///
  /// In en, this message translates to:
  /// **'Information Collection'**
  String get info_collection;

  /// No description provided for @info_collection_1.
  ///
  /// In en, this message translates to:
  /// **'We collect the following types of information:'**
  String get info_collection_1;

  /// No description provided for @info_collection_2.
  ///
  /// In en, this message translates to:
  /// **'• Personal Information: Including name, email address, phone number and bank card information'**
  String get info_collection_2;

  /// No description provided for @info_collection_3.
  ///
  /// In en, this message translates to:
  /// **'• Order Information: Including purchase records, refund applications and transaction history'**
  String get info_collection_3;

  /// No description provided for @info_collection_4.
  ///
  /// In en, this message translates to:
  /// **'• Usage Data: Including app usage and preferences'**
  String get info_collection_4;

  /// No description provided for @info_collection_5.
  ///
  /// In en, this message translates to:
  /// **'• Device Information: Including device model, operating system version and unique identifier'**
  String get info_collection_5;

  /// No description provided for @info_usage.
  ///
  /// In en, this message translates to:
  /// **'Information Usage'**
  String get info_usage;

  /// No description provided for @info_usage_1.
  ///
  /// In en, this message translates to:
  /// **'We use the collected information for:'**
  String get info_usage_1;

  /// No description provided for @info_usage_2.
  ///
  /// In en, this message translates to:
  /// **'• Processing your orders and refund applications'**
  String get info_usage_2;

  /// No description provided for @info_usage_3.
  ///
  /// In en, this message translates to:
  /// **'• Improving our services and features'**
  String get info_usage_3;

  /// No description provided for @info_usage_4.
  ///
  /// In en, this message translates to:
  /// **'• Communicating with you, including customer support'**
  String get info_usage_4;

  /// No description provided for @info_usage_5.
  ///
  /// In en, this message translates to:
  /// **'• Analyzing app usage to optimize user experience'**
  String get info_usage_5;

  /// No description provided for @info_usage_6.
  ///
  /// In en, this message translates to:
  /// **'• Preventing fraud and ensuring security'**
  String get info_usage_6;

  /// No description provided for @info_sharing.
  ///
  /// In en, this message translates to:
  /// **'Information Sharing'**
  String get info_sharing;

  /// No description provided for @info_sharing_1.
  ///
  /// In en, this message translates to:
  /// **'We do not sell, rent or trade your personal information. We only share information in the following cases:'**
  String get info_sharing_1;

  /// No description provided for @info_sharing_2.
  ///
  /// In en, this message translates to:
  /// **'• With your explicit consent'**
  String get info_sharing_2;

  /// No description provided for @info_sharing_3.
  ///
  /// In en, this message translates to:
  /// **'• Necessary for processing transactions and services'**
  String get info_sharing_3;

  /// No description provided for @info_sharing_4.
  ///
  /// In en, this message translates to:
  /// **'• To comply with legal requirements or court orders'**
  String get info_sharing_4;

  /// No description provided for @info_sharing_5.
  ///
  /// In en, this message translates to:
  /// **'• To protect our rights, property or safety'**
  String get info_sharing_5;

  /// No description provided for @info_sharing_6.
  ///
  /// In en, this message translates to:
  /// **'• With trusted service providers (under confidentiality agreements)'**
  String get info_sharing_6;

  /// No description provided for @data_security.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get data_security;

  /// No description provided for @data_security_1.
  ///
  /// In en, this message translates to:
  /// **'We take the following measures to protect your information:'**
  String get data_security_1;

  /// No description provided for @data_security_2.
  ///
  /// In en, this message translates to:
  /// **'• Using SSL/TLS encryption to transmit data'**
  String get data_security_2;

  /// No description provided for @data_security_3.
  ///
  /// In en, this message translates to:
  /// **'• Secure storage of your password (encrypted hash)'**
  String get data_security_3;

  /// No description provided for @data_security_4.
  ///
  /// In en, this message translates to:
  /// **'• Regular security audits and vulnerability scanning'**
  String get data_security_4;

  /// No description provided for @data_security_5.
  ///
  /// In en, this message translates to:
  /// **'• Restricting employee access to personal information'**
  String get data_security_5;

  /// No description provided for @data_security_6.
  ///
  /// In en, this message translates to:
  /// **'• Requiring service providers to comply with strict security standards'**
  String get data_security_6;

  /// No description provided for @your_rights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get your_rights;

  /// No description provided for @your_rights_1.
  ///
  /// In en, this message translates to:
  /// **'You have the following rights regarding your personal information:'**
  String get your_rights_1;

  /// No description provided for @your_rights_2.
  ///
  /// In en, this message translates to:
  /// **'• Access Right: View information we hold about you'**
  String get your_rights_2;

  /// No description provided for @your_rights_3.
  ///
  /// In en, this message translates to:
  /// **'• Correction Right: Update or correct inaccurate information'**
  String get your_rights_3;

  /// No description provided for @your_rights_4.
  ///
  /// In en, this message translates to:
  /// **'• Deletion Right: Request deletion of your personal information'**
  String get your_rights_4;

  /// No description provided for @your_rights_5.
  ///
  /// In en, this message translates to:
  /// **'• Objection Right: Object to certain data processing activities'**
  String get your_rights_5;

  /// No description provided for @your_rights_6.
  ///
  /// In en, this message translates to:
  /// **'• Withdraw Consent: Withdraw previously given consent'**
  String get your_rights_6;

  /// No description provided for @your_rights_7.
  ///
  /// In en, this message translates to:
  /// **'• Data Portability: Receive your data in a structured format'**
  String get your_rights_7;

  /// No description provided for @cookie_policy.
  ///
  /// In en, this message translates to:
  /// **'Cookie Policy'**
  String get cookie_policy;

  /// No description provided for @cookie_policy_1.
  ///
  /// In en, this message translates to:
  /// **'We use cookies and similar technologies to:'**
  String get cookie_policy_1;

  /// No description provided for @cookie_policy_2.
  ///
  /// In en, this message translates to:
  /// **'• Remember your login credentials'**
  String get cookie_policy_2;

  /// No description provided for @cookie_policy_3.
  ///
  /// In en, this message translates to:
  /// **'• Remember your preferences'**
  String get cookie_policy_3;

  /// No description provided for @cookie_policy_4.
  ///
  /// In en, this message translates to:
  /// **'• Analyze app performance'**
  String get cookie_policy_4;

  /// No description provided for @cookie_policy_5.
  ///
  /// In en, this message translates to:
  /// **'• Provide personalized content'**
  String get cookie_policy_5;

  /// No description provided for @cookie_policy_6.
  ///
  /// In en, this message translates to:
  /// **'You can manage cookie preferences through your device settings'**
  String get cookie_policy_6;

  /// No description provided for @child_privacy.
  ///
  /// In en, this message translates to:
  /// **'Child Privacy'**
  String get child_privacy;

  /// No description provided for @child_privacy_1.
  ///
  /// In en, this message translates to:
  /// **'Our services are not directed at children under 13.'**
  String get child_privacy_1;

  /// No description provided for @child_privacy_2.
  ///
  /// In en, this message translates to:
  /// **'If we discover we have collected personal information from children under 13,'**
  String get child_privacy_2;

  /// No description provided for @child_privacy_3.
  ///
  /// In en, this message translates to:
  /// **'we will take steps to delete that information.'**
  String get child_privacy_3;

  /// No description provided for @policy_changes.
  ///
  /// In en, this message translates to:
  /// **'Policy Changes'**
  String get policy_changes;

  /// No description provided for @policy_changes_1.
  ///
  /// In en, this message translates to:
  /// **'We may update this privacy policy from time to time.'**
  String get policy_changes_1;

  /// No description provided for @policy_changes_2.
  ///
  /// In en, this message translates to:
  /// **'After changes, we will notify you within the app.'**
  String get policy_changes_2;

  /// No description provided for @policy_changes_3.
  ///
  /// In en, this message translates to:
  /// **'Continued use of our services indicates acceptance of the updated policy.'**
  String get policy_changes_3;

  /// No description provided for @policy_changes_4.
  ///
  /// In en, this message translates to:
  /// **'We recommend checking this page regularly for the latest information.'**
  String get policy_changes_4;

  /// No description provided for @contact_us_section.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us_section;

  /// No description provided for @contact_us_1.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or concerns about this privacy policy, please contact us:'**
  String get contact_us_1;

  /// No description provided for @contact_us_2.
  ///
  /// In en, this message translates to:
  /// **'• Email: support@refundo.com'**
  String get contact_us_2;

  /// No description provided for @contact_us_3.
  ///
  /// In en, this message translates to:
  /// **'• In-App Feedback: Settings > Help & Feedback'**
  String get contact_us_3;

  /// No description provided for @contact_us_4.
  ///
  /// In en, this message translates to:
  /// **'• We will respond within 30 days'**
  String get contact_us_4;

  /// No description provided for @view_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'View Privacy Policy'**
  String get view_privacy_policy;

  /// No description provided for @get_help_and_feedback.
  ///
  /// In en, this message translates to:
  /// **'Get Help and Feedback'**
  String get get_help_and_feedback;

  /// No description provided for @not_set.
  ///
  /// In en, this message translates to:
  /// **'Not Set'**
  String get not_set;

  /// No description provided for @search_help.
  ///
  /// In en, this message translates to:
  /// **'Search help topics...'**
  String get search_help;

  /// No description provided for @frequently_asked_questions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequently_asked_questions;

  /// No description provided for @faq1_question.
  ///
  /// In en, this message translates to:
  /// **'How do I scan an order?'**
  String get faq1_question;

  /// No description provided for @faq1_answer.
  ///
  /// In en, this message translates to:
  /// **'Tap the scan button on the orders page and point your camera at the QR code on your receipt.'**
  String get faq1_answer;

  /// No description provided for @faq2_question.
  ///
  /// In en, this message translates to:
  /// **'What are the refund requirements?'**
  String get faq2_question;

  /// No description provided for @faq2_answer.
  ///
  /// In en, this message translates to:
  /// **'Orders must be at least 5 months old and have a minimum refund amount of 5000 FCFA.'**
  String get faq2_answer;

  /// No description provided for @faq3_question.
  ///
  /// In en, this message translates to:
  /// **'How long does refund processing take?'**
  String get faq3_question;

  /// No description provided for @faq3_answer.
  ///
  /// In en, this message translates to:
  /// **'Refund applications are typically processed within 3-5 business days.'**
  String get faq3_answer;

  /// No description provided for @faq4_question.
  ///
  /// In en, this message translates to:
  /// **'Can I track my refund status?'**
  String get faq4_question;

  /// No description provided for @faq4_answer.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can track your refund status in the Refunds section of the app.'**
  String get faq4_answer;

  /// No description provided for @video_tutorials.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get video_tutorials;

  /// No description provided for @tutorial1_title.
  ///
  /// In en, this message translates to:
  /// **'Getting Started with RefundO'**
  String get tutorial1_title;

  /// No description provided for @tutorial1_desc.
  ///
  /// In en, this message translates to:
  /// **'Learn the basics of scanning orders and requesting refunds'**
  String get tutorial1_desc;

  /// No description provided for @tutorial2_title.
  ///
  /// In en, this message translates to:
  /// **'Advanced Features Guide'**
  String get tutorial2_title;

  /// No description provided for @tutorial2_desc.
  ///
  /// In en, this message translates to:
  /// **'Explore advanced features like batch refunds and statistics'**
  String get tutorial2_desc;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @email_support.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get email_support;

  /// No description provided for @email_support_address.
  ///
  /// In en, this message translates to:
  /// **'support@refundo.com'**
  String get email_support_address;

  /// No description provided for @phone_support.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get phone_support;

  /// No description provided for @phone_support_number.
  ///
  /// In en, this message translates to:
  /// **'+237 XXX XXX XXX'**
  String get phone_support_number;

  /// No description provided for @whatsapp_support.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Support'**
  String get whatsapp_support;

  /// No description provided for @whatsapp_available.
  ///
  /// In en, this message translates to:
  /// **'Available Mon-Fri 9:00-17:00'**
  String get whatsapp_available;

  /// No description provided for @send_feedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get send_feedback;

  /// No description provided for @feedback_description.
  ///
  /// In en, this message translates to:
  /// **'We value your feedback! Please let us know how we can improve our services.'**
  String get feedback_description;

  /// No description provided for @enter_your_feedback.
  ///
  /// In en, this message translates to:
  /// **'Enter your feedback here...'**
  String get enter_your_feedback;

  /// No description provided for @submit_feedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submit_feedback;

  /// No description provided for @feedback_submitted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your feedback has been submitted successfully.'**
  String get feedback_submitted_successfully;

  /// No description provided for @verify_identity.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Identity'**
  String get verify_identity;

  /// No description provided for @new_email.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get new_email;

  /// No description provided for @confirm_new_email.
  ///
  /// In en, this message translates to:
  /// **'Confirm Email'**
  String get confirm_new_email;

  /// No description provided for @enter_old_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Old Password'**
  String get enter_old_password;

  /// No description provided for @please_enter_new_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get please_enter_new_password;

  /// No description provided for @please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get please_enter_password;

  /// No description provided for @enter_password_to_verify.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password to verify your identity'**
  String get enter_password_to_verify;

  /// No description provided for @enter_old_password_tip.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password to confirm the change'**
  String get enter_old_password_tip;

  /// No description provided for @email_format_tip.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address (e.g., example@domain.com)'**
  String get email_format_tip;

  /// No description provided for @emails_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'The email addresses do not match'**
  String get emails_do_not_match;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @no_orders_yet.
  ///
  /// In en, this message translates to:
  /// **'No Orders Yet'**
  String get no_orders_yet;

  /// No description provided for @scan_products_to_add_orders.
  ///
  /// In en, this message translates to:
  /// **'Scan products to add orders'**
  String get scan_products_to_add_orders;

  /// No description provided for @scan_now.
  ///
  /// In en, this message translates to:
  /// **'Scan Now'**
  String get scan_now;

  /// No description provided for @no_refunds_yet.
  ///
  /// In en, this message translates to:
  /// **'No Refunds Yet'**
  String get no_refunds_yet;

  /// No description provided for @submit_refund_requests_here.
  ///
  /// In en, this message translates to:
  /// **'Submit refund requests here'**
  String get submit_refund_requests_here;

  /// No description provided for @date_range.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get date_range;

  /// No description provided for @sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sort_by;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @transaction_failed.
  ///
  /// In en, this message translates to:
  /// **'Transaction Failed'**
  String get transaction_failed;

  /// No description provided for @transaction_receipt.
  ///
  /// In en, this message translates to:
  /// **'Transaction Receipt'**
  String get transaction_receipt;

  /// No description provided for @few_label.
  ///
  /// In en, this message translates to:
  /// **'Few'**
  String get few_label;

  /// No description provided for @withdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get withdrawn;

  /// No description provided for @pending_withdrawal.
  ///
  /// In en, this message translates to:
  /// **'Pending Withdrawal'**
  String get pending_withdrawal;

  /// No description provided for @click_to_view_full_image.
  ///
  /// In en, this message translates to:
  /// **'Tap to view full image'**
  String get click_to_view_full_image;

  /// No description provided for @image_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get image_load_failed;

  /// No description provided for @no_orders_yet_detail.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code to add your first order'**
  String get no_orders_yet_detail;

  /// No description provided for @no_refunds_yet_detail.
  ///
  /// In en, this message translates to:
  /// **'Your refund applications will appear here'**
  String get no_refunds_yet_detail;

  /// No description provided for @no_search_results.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_search_results;

  /// No description provided for @no_search_results_detail.
  ///
  /// In en, this message translates to:
  /// **'No content found matching \"{query}\"'**
  String no_search_results_detail(Object query);

  /// No description provided for @clear_search.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clear_search;

  /// No description provided for @network_connection_failed.
  ///
  /// In en, this message translates to:
  /// **'Network Connection Failed'**
  String get network_connection_failed;

  /// No description provided for @check_network_settings.
  ///
  /// In en, this message translates to:
  /// **'Please check your network settings and try again'**
  String get check_network_settings;

  /// No description provided for @server_error_title.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get server_error_title;

  /// No description provided for @server_error_detail.
  ///
  /// In en, this message translates to:
  /// **'Server temporarily unavailable, please try again later'**
  String get server_error_detail;

  /// No description provided for @no_more_data.
  ///
  /// In en, this message translates to:
  /// **'No more data'**
  String get no_more_data;

  /// No description provided for @total_orders_label.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get total_orders_label;

  /// No description provided for @orders_count_label.
  ///
  /// In en, this message translates to:
  /// **'orders'**
  String get orders_count_label;

  /// No description provided for @total_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount_label;

  /// No description provided for @order_statistics_section.
  ///
  /// In en, this message translates to:
  /// **'Order Statistics'**
  String get order_statistics_section;

  /// No description provided for @todays_orders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Orders'**
  String get todays_orders;

  /// No description provided for @refund_statistics_section.
  ///
  /// In en, this message translates to:
  /// **'Refund Statistics'**
  String get refund_statistics_section;

  /// No description provided for @pending_label.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending_label;

  /// No description provided for @completed_label.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed_label;
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
