import 'package:flutter/material.dart';
import 'package:weblate_sdk/src/util/localization_string_extension.dart';
import 'package:weblate_sdk/src/util/match_util.dart';

extension LocalizationContextExtension on BuildContext {
  /// Main extension method to use strings from your translation;
  /// Pass [key] of your translation;
  /// Pass [format] to format you translation. Items to format should be declared as {item1}, {someItem2}.;
  /// For example: 'Welcome {firstName} {lastName}!'
  /// context.localizedValueOf('welcomeMessage', format: ['Alex', 'Test']);
  String localizedValueOf(
    String key, {
    List<String>? format,
  }) {
    final value = key.localizedValueOf(this);
    if (format == null || format.isEmpty) {
      return value;
    }
    return MatchUtil.localizedValueFormatted(
      value,
      format,
    );
  }
}
