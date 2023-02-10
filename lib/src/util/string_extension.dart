extension StringExtension on String {
  String cleanLangCode() {
    if (contains('@')) {
      final parts = split('@');
      return parts.first.replaceAll('@', '');
    } else {
      return this;
    }
  }
}

extension StringExtensionNullable on String? {
  String? cleanLangCode() {
    final input = this;
    if (input == null) {
      return null;
    }
    if (input.contains('@')) {
      final parts = input.split('@');
      return parts.first.replaceAll('@', '');
    } else {
      return input;
    }
  }
}
