import 'package:flutter/material.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';

class WebLateLocalizationDelegate extends LocalizationsDelegate<LanguageKeys> {
  final TranslationsMap _translations;

  const WebLateLocalizationDelegate({
    required TranslationsMap translations,
  }) : _translations = translations;

  List<Locale> get supportedLocales {
    if (_translations.isEmpty) {
      return [const Locale('en', 'US')];
    }
    return _translations.keys
        .map((lang) => Locale.fromSubtags(languageCode: lang))
        .toList();
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);

  @override
  Future<LanguageKeys> load(Locale locale) =>
      Future(() => _translations[locale.languageCode] ?? {});

  @override
  bool shouldReload(WebLateLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
