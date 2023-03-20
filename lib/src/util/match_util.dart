class MatchUtil {
  static String localizedValueFormatted(
    String value,
    List<String> format,
  ) {
    if (value.isEmpty) {
      return value;
    }

    var editedValue = value;
    for (var formatValue in format) {
      editedValue = _replaceMatch(editedValue, formatValue);
    }

    return editedValue;
  }

  static String _replaceMatch(
    String value,
    String replacement,
  ) {
    final regEx = RegExp(r'(^|){\w+}');
    final match = regEx.firstMatch(value);
    if (match == null) {
      return value;
    }
    return value.replaceRange(match.start, match.end, replacement);
  }
}
