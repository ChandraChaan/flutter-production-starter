// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'प्रोडक्शन स्टार्टर';

  @override
  String get articlesTitle => 'लेख';

  @override
  String get articleNotFound => 'लेख नहीं मिला।';

  @override
  String get emptyArticles => 'अभी कोई लेख नहीं है।';

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get errorNetwork =>
      'इंटरनेट कनेक्शन नहीं है। अपना नेटवर्क जांचें और फिर से कोशिश करें।';

  @override
  String get errorServer =>
      'हमारी ओर से कुछ गड़बड़ हो गई। कृपया फिर से कोशिश करें।';

  @override
  String get errorUnknown => 'कुछ गड़बड़ हो गई। कृपया फिर से कोशिश करें।';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get theme => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get language => 'भाषा';

  @override
  String get languageSystem => 'सिस्टम';

  @override
  String get environment => 'एनवायरनमेंट';
}
