import 'package:flutter/material.dart';

typedef LanguageKeys = Map<String, String>;
typedef TranslationsMap = Map<String, LanguageKeys>;
typedef WebLateWidgetBuilder = Widget Function(
  BuildContext context,
  List<Locale> supportedLocales,
  Iterable<LocalizationsDelegate<dynamic>>? delegates,
);
