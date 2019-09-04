import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class DefaultAppLocalizations {
  final Locale locale;

  DefaultAppLocalizations(this.locale);

  static DefaultAppLocalizations of(BuildContext context) {
    return Localizations.of<DefaultAppLocalizations>(
        context, DefaultAppLocalizations);
  }

  static Map<String, Map<String, String>> _localized = {
    'en': {
      'title': 'Home',
    },
    'zh': {
      'title': '当前1.8元/总共10.05元',
    }
  };

  String get title {
    return _localized[locale.languageCode]['title'];
  }
}

class DefaultAppLocalizationsDelegate
    extends LocalizationsDelegate<DefaultAppLocalizations> {
  DefaultAppLocalizationsDelegate();

  @override
  Future<DefaultAppLocalizations> load(Locale locale) {
    return SynchronousFuture<DefaultAppLocalizations>(
        DefaultAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  bool shouldReload(LocalizationsDelegate<DefaultAppLocalizations> old) {
    return false;
  }
}
