import 'package:flutter/material.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';
import 'package:weblate_sdk/src/web_late_localization_delegate.dart';
import 'package:weblate_sdk/src/weblate_client.dart';

class WebLateSdk {
  static late WebLateClient _client;
  static late WebLateLocalizationDelegate _delegate;
  static bool _isInitialized = false;
  static TranslationsMap _translations = {};
  static late String? _defaultLanguage;

  /// Initialize library. Call this function in [main] function of your app;
  /// [accessKey] - you can find it in your WebLate profile in Api Access section;
  /// [host] - host of your WebLate. Host should be without https://. for example: weblate.company.link;
  /// [projectName] - name of your WebLate project;
  /// [componentName] - name of your WebLate project component to use;
  /// For example you can use different components for different platforms
  /// so specify in [componentName] what component app should use depending on platform;
  /// [defaultLanguage] (Optional) - default app language. If translation not found for current language
  /// then translation for [defaultLanguage] will be used instead;
  /// If [defaultLanguage] is not set empty string will be returned;
  static Future<void> initialize({
    required String accessKey,
    required String host,
    required String projectName,
    required String componentName,
    String? defaultLanguage,
  }) async {
    if (_isInitialized) {
      return;
    }
    _defaultLanguage = defaultLanguage;
    _client = WebLateClient(
      accessKey: accessKey,
      host: host,
      projectName: projectName,
      componentName: componentName,
    );
    _translations = await _client.initialize();
    _delegate = WebLateLocalizationDelegate(translations: _translations);
    _isInitialized = true;
  }

  /// List of supported locales based on WebLate languages list
  static List<Locale> get supportedLocales => _delegate.supportedLocales;

  /// Localization delegate. Add this to [localizationsDelegates] of your [MaterialApp]
  static LocalizationsDelegate get delegate => _delegate;

  /// Map of all available translations
  static TranslationsMap get translations => _translations;

  /// Is initialization completed or not
  static bool get isInitialized => _isInitialized;

  /// Get default language. By default means completed
  static String? get defaultLanguage => _defaultLanguage;
}
