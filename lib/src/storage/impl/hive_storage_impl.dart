import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/storage/hive_storage.dart';
import 'package:weblate_sdk/src/storage/model/language.dart';
import 'package:weblate_sdk/src/storage/model/translation.dart';

class HiveStorageImpl extends HiveStorage {
  @override
  Future<List<Language>> getCachedLanguages() async {
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

  @override
  Future<List<Translation>> getCachedTranslations({
    required String componentName,
    required String langCode,
  }) async {
    try {
      final componentBox = await Hive.openBox<Translation>(
          '$kTranslationsBox$componentName$langCode');
      return componentBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('${Const.storageIOError}: ${e.toString()}');
      }
      return List.empty();
    }
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
    final languages = await getCachedLanguages();
    if (languages.isEmpty) {
      return false;
    }
    final defaultTranslations = await getCachedTranslations(
      componentName: componentName,
      langCode: defaultLanguage,
    );
    return defaultTranslations.isNotEmpty;
  }
}
