import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/storage/hive_storage.dart';
import 'package:weblate_sdk/src/storage/mapper/translation_mapper.dart';
import 'package:weblate_sdk/src/storage/model/language.dart';
import 'package:weblate_sdk/src/storage/model/translation.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';

class HiveStorageImpl extends HiveStorage {
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
        '${Const.success}: Got cached translations [${cachedLanguages.map((e) => e.langCode).join(', ')}] for $componentName',
      );
    }
    return translationsMap;
  }

  @override
  Future<void> cacheLanguages({
    required List<Language> languages,
  }) async {
    try {
      final languageBox = await Hive.openBox<Language>(kLanguagesBox);
      await languageBox.clear();
      await languageBox.addAll(languages);
    } catch (e) {
      if (kDebugMode) {
        print('${Const.storageIOError}: ${e.toString()}');
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
      final translationBox = await Hive.openBox<Translation>(
          '$kTranslationsBox$componentName$langCode');
      await translationBox.clear();
      await translationBox.addAll(translations);
    } catch (e) {
      if (kDebugMode) {
        print('${Const.storageIOError}: ${e.toString()}');
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
      final languageBox = await Hive.openBox<Language>(kLanguagesBox);
      return languageBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('${Const.storageIOError}: ${e.toString()}');
      }
      return List.empty();
    }
  }

  Future<List<Translation>> _getCachedTranslations({
    required String componentName,
    required String langCode,
  }) async {
    try {
      final componentBox = await Hive.openBox<Translation>(
          '$kTranslationsBox$componentName${langCode.toLowerCase()}');
      return componentBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('${Const.storageIOError}: ${e.toString()}');
      }
      return List.empty();
    }
  }
}
