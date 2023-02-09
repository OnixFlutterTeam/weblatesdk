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
      final componentBox = await Hive.openBox<Translation>(kTranslationsBox);
      return componentBox.values
          .where(
            (c) => c.componentName == componentName && c.langCode == langCode,
          )
          .toList();
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
    required List<Translation> translations,
  }) async {
    try {
      final translationBox = await Hive.openBox<Translation>(kTranslationsBox);
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
  }) async {
    final languages = await getCachedLanguages();
    return languages.isNotEmpty;
  }
}
