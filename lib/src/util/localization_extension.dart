import 'package:flutter/material.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/web_late_sdk.dart';
import 'package:weblate_sdk/src/weblate_exception.dart';

extension LocalizationContextExtension on BuildContext {
  /// Main extension method to use strings from your translation;
  /// Pass [key] of your translation;
  String localizedValueOf(String key) {
    return key.localizedValueOf(this);
  }
}

extension LocalizationStringExtension on String {
  String localizedValueOf(BuildContext context) {
    if (!WebLateSdk.isInitialized) {
      throw WebLateException(
        cause: Const.notInitialized,
        message: 'Did you forgot to call WebLate.initialize() in main?',
      );
    }
    final currentLocale = Localizations.localeOf(context);
    if (!WebLateSdk.translations.containsKey(currentLocale.languageCode)) {
      throw WebLateException(
        cause: Const.localeNotFound,
        message: 'Locale for ${currentLocale.languageCode} not found',
      );
    }
    final localeTranslations =
        WebLateSdk.translations[currentLocale.languageCode] ?? {};
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
    if (defaultLanguage != null) {
      if (!WebLateSdk.translations.containsKey(defaultLanguage)) {
        throw WebLateException(
          cause: Const.localeNotFound,
          message: 'Invalid default locale. Locale $defaultLanguage not found',
        );
      }
      final defaultTranslations =
          WebLateSdk.translations[defaultLanguage] ?? {};
      if (defaultTranslations.containsKey(this)) {
        return defaultTranslations[this] ?? '';
      } else {
        return '';
      }
    } else {
      return '';
    }
  }
}
