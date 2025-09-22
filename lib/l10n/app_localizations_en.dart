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
}
