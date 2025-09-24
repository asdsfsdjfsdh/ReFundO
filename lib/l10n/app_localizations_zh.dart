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
}
