import 'package:flutter/material.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/util/weblate_exception.dart';
import 'package:weblate_sdk/src/web_late_sdk.dart';

extension LocalizationStringExtension on String {
  String localizedValueOf(BuildContext context) {
    if (!WebLateSdk.isSDKInitialized) {
      throw WebLateException(
        cause: Const.notInitialized,
        message: 'Did you forgot to call WebLate.initialize() in main?',
      );
    }
    final currentLocale = Localizations.localeOf(context).languageCode;
    if (!WebLateSdk.translations.containsKey(currentLocale)) {
      return _getDefaultLocaleTranslation();
    }

    final localeTranslations = WebLateSdk.translations[currentLocale] ?? {};
    if (localeTranslations.containsKey(this)) {
      final translationString = localeTranslations[this] ?? '';
      if (translationString.isNotEmpty) {
        return translationString;
      } else {
        return _getDefaultLocaleTranslation();
      }
    } else {
      return _getDefaultLocaleTranslation();
    }
  }

  String _getDefaultLocaleTranslation() {
    final defaultLanguage = WebLateSdk.defaultLanguage;
    if (!WebLateSdk.translations.containsKey(defaultLanguage)) {
      return _getFallbackTranslation();
    }
    final defaultTranslations = WebLateSdk.translations[defaultLanguage] ?? {};
    if (defaultTranslations.containsKey(this)) {
      return defaultTranslations[this] ?? '';
    } else {
      return '';
    }
  }

  String _getFallbackTranslation() {
    final fallbackTranslations = WebLateSdk.fallbackTranslations ?? {};
    if (fallbackTranslations.containsKey(this)) {
      return fallbackTranslations[this] ?? '';
    } else {
      return this;
    }
  }
}
