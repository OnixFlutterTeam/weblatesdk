import 'package:flutter/material.dart';
import 'package:weblate_sdk/src/storage/model/language.dart';
import 'package:weblate_sdk/src/storage/model/translation.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';

abstract class LocalTranslationStorage {
  @protected
  final kLanguagesBox = 'kLanguagesBox';
  @protected
  final kTranslationsBox = 'kTranslationsBox';

  Future<bool> hasCachedTranslations({
    required String componentName,
    required String defaultLanguage,
  });

  Future<TranslationsMap> getCachedTranslations({
    required String componentName,
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
