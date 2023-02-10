import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weblate_sdk/src/storage/model/language.dart';
import 'package:weblate_sdk/src/storage/model/translation.dart';

abstract class HiveStorage {
  @protected
  final kLanguagesBox = 'kLanguagesBox';
  @protected
  final kTranslationsBox = 'kTranslationsBox';

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(LanguageAdapter())
      ..registerAdapter(TranslationAdapter());
  }

  Future<bool> hasCachedTranslations({
    required String componentName,
    required String defaultLanguage,
  });

  Future<List<Language>> getCachedLanguages();

  Future<List<Translation>> getCachedTranslations({
    required String componentName,
    required String langCode,
  });

  Future<void> cacheLanguages({
    required List<Language> languages,
  });

  Future<void> cacheTranslations({
    required String componentName,
    required String langCode,
    required List<Translation> translations,
  });
}
