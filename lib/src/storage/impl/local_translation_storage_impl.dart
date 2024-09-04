import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/storage/local_translation_storage.dart';
import 'package:weblate_sdk/src/storage/mapper/translation_mapper.dart';
import 'package:weblate_sdk/src/storage/model/language.dart';
import 'package:weblate_sdk/src/storage/model/translation.dart';
import 'package:weblate_sdk/src/util/base_preferences.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';

class LocalTranslationStorageImpl extends LocalTranslationStorage {
  final BasePreferences _preferences;

  LocalTranslationStorageImpl(this._preferences);

  final _translationMapper = TranslationMapper();

  @override
  Future<TranslationsMap> getCachedTranslations({
    required String componentName,
  }) async {
    final cachedLanguages = await _getCachedLanguages();
    TranslationsMap translationsMap = {};
    for (var lang in cachedLanguages) {
      final cachedTranslations = await _getCachedTranslations(
        componentName: componentName,
        langCode: lang.langCode,
      );
      translationsMap[lang.langCode] =
          _translationMapper.objectToMap(cachedTranslations);
    }
    if (kDebugMode) {
      print(
        '${Consts.success}: Got cached translations [${cachedLanguages.map((e) => e.langCode).join(', ')}] for $componentName',
      );
    }
    return translationsMap;
  }

  @override
  Future<void> cacheLanguages({
    required List<Language> languages,
  }) async {
    try {
      final encoded = jsonEncode(languages.map((e) => e.toJson()).toList());
      await _preferences.put(kLanguagesBox, encoded);
    } catch (e) {
      if (kDebugMode) {
        print('${Consts.storageIOError}.CacheLanguages: ${e.toString()}');
      }
    }
  }

  @override
  Future<void> cacheTranslations({
    required String componentName,
    required String langCode,
    required List<Translation> translations,
  }) async {
    try {
      final key = '$kTranslationsBox$componentName$langCode';
      await _preferences.removePrefByKey(key);
      final encoded = jsonEncode(translations.map((e) => e.toJson()).toList());
      await _preferences.put(key, encoded);
    } catch (e) {
      if (kDebugMode) {
        print('${Consts.storageIOError}.CacheTranslation: ${e.toString()}');
      }
    }
  }

  @override
  Future<bool> hasCachedTranslations({
    required String componentName,
    required String defaultLanguage,
  }) async {
    final languages = await _getCachedLanguages();
    if (languages.isEmpty) {
      return false;
    }
    final defaultTranslations = await _getCachedTranslations(
      componentName: componentName,
      langCode: defaultLanguage,
    );
    return defaultTranslations.isNotEmpty;
  }

  Future<List<Language>> _getCachedLanguages() async {
    try {
      final encoded = await _preferences.get(kLanguagesBox, '[]');
      final decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded.map((e) => Language.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('${Consts.storageIOError}.GetCachedLanguages: ${e.toString()}');
      }
      return List.empty();
    }
  }

  Future<List<Translation>> _getCachedTranslations({
    required String componentName,
    required String langCode,
  }) async {
    try {
      final encoded = await _preferences.get(
          '$kTranslationsBox$componentName${langCode.toLowerCase()}', '[]');
      final decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded.map((e) => Translation.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(
          '${Consts.storageIOError}.GetCachedTranslations: ${e.toString()}',
        );
      }
      return List.empty();
    }
  }
}
