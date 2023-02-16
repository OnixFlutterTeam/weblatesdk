import 'package:flutter/material.dart';
import 'package:weblate_sdk/src/util/localization_string_extension.dart';

extension LocalizationContextExtension on BuildContext {
  /// Main extension method to use strings from your translation;
  /// Pass [key] of your translation;
  String localizedValueOf(String key) {
    return key.localizedValueOf(this);
  }
}
