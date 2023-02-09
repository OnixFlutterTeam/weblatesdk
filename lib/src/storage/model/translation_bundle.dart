import 'package:weblate_sdk/src/util/custom_types.dart';

class TranslationBundle {
  final String langCode;
  final String componentName;
  final LanguageKeys translations;

  TranslationBundle({
    required this.langCode,
    required this.componentName,
    required this.translations,
  });
}
