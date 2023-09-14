import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/storage/impl/hive_storage_impl.dart';
import 'package:weblate_sdk/src/storage/impl/preferences_storage_impl.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';
import 'package:weblate_sdk/src/web_late_localization_delegate.dart';
import 'package:weblate_sdk/src/client/weblate_client.dart';
import 'package:flutter/services.dart' show rootBundle;

class WebLateSdk {
  WebLateSdk._();

  static late WebLateClient _client;
  static late WebLateLocalizationDelegate _delegate;
  static bool _isInitialized = false;
  static TranslationsMap _translations = {};
  static late String _defaultLanguage;
  static LanguageKeys? _fallbackTranslations;

  @visibleForTesting
  static set setTestIsInitialized(bool value) {
    _isInitialized = value;
  }
  @visibleForTesting
  static set setTestDefaultLanguage(String value) {
    _defaultLanguage = value;
  }
  @visibleForTesting
  static Future<void> setFallbackTranslations(String fallbackJson) async {
    _fallbackTranslations = await _initializeFallbackJson(fallbackJson);
  }

  /// Initialize library. Call this function in [main] function of your app;
  /// [token] - you can find it in your WebLate project in Api Access section;
  /// [host] - host of your WebLate. Host should be without https://. for example: weblate.company.link;
  /// [projectName] - name of your WebLate project;
  /// [componentName] - name of your WebLate project component to use;
  /// For example you can use different components for different platforms
  /// so specify in [componentName] what component app should use depending on platform;
  /// [defaultLanguage] (Optional) - default app language. If translation not found for current language
  /// then translation for [defaultLanguage] will be used instead;
  /// If [defaultLanguage] is not set empty string will be returned;
  /// [disableCache] - disable or enable caching. By default cache
  /// disabled on debug and enabled on release;
  /// [cacheLive] - cache live time. By default 2 hours;
  /// [fallbackJson] - set local JSON translations file for case when you
  /// do not have internet connection and cached translations;
  static Future<bool> initialize({
    required String token,
    required String host,
    required String projectName,
    required String componentName,
    required String defaultLanguage,
    bool? disableCache,
    Duration? cacheLive,
    String? fallbackJson,
  }) async {
    if (_isInitialized) {
      return _isInitialized;
    }
    _defaultLanguage = defaultLanguage;
    if (fallbackJson != null) {
      _fallbackTranslations = await _initializeFallbackJson(
        fallbackJson,
      );
    }

    final storage = HiveStorageImpl();
    await storage.initialize();
    final preferences = PreferencesStorageImpl();
    _client = WebLateClient(
      token: token,
      host: host,
      projectName: projectName,
      componentName: componentName,
      defaultLanguage: defaultLanguage,
      storage: storage,
      preferences: preferences,
      disableCache: disableCache,
      cacheLive: cacheLive,
    );

    _translations = await _client.initialize();
    _delegate = WebLateLocalizationDelegate(translations: _translations);
    _isInitialized = true;
    return _isInitialized;
  }

  static Future<LanguageKeys> _initializeFallbackJson(
    String fallbackJson,
  ) async {
    try {
      final fallbackFileContent = await rootBundle.loadString(fallbackJson);
      final jsonData =
          await json.decode(fallbackFileContent) as Map<String, dynamic>;
      return jsonData.map(
        (key, value) => MapEntry(key, value as String),
      );
    } catch (e, _) {
      if (kDebugMode) {
        print(
          '${Const.storageIOError}: Could fallback not read file $fallbackJson. Fallback translations will not be used.\n$e',
        );
      }
    }
    return {};
  }

  /// Check is library can be initialized;
  /// On first app run app requires internet connection to cache translations strings;
  Future<bool> canInitialize() => _client.canInitialize();

  /// List of supported locales based on WebLate languages list;
  static List<Locale> get supportedLocales => _delegate.supportedLocales;

  /// Localization delegate. Add this to [localizationsDelegates] of your [MaterialApp];
  static LocalizationsDelegate get delegate => _delegate;

  /// Map of all available translations;
  static TranslationsMap get translations => _translations;

  /// Is initialization completed or not;
  static bool get isFullyInitialized =>
      isSDKInitialized && isTranslationsFetchSuccess;

  /// Is initialization completed or not;
  static bool get isSDKInitialized => _isInitialized;

  /// Is translations fetched successfully or not;
  static bool get isTranslationsFetchSuccess => translations.isNotEmpty;

  /// Get default language. By default means completed;
  static String get defaultLanguage => _defaultLanguage;

  /// Get local fallback translations;
  static LanguageKeys? get fallbackTranslations => _fallbackTranslations;
}
