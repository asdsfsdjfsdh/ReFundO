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
