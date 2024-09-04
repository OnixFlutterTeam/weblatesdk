import 'package:json_annotation/json_annotation.dart';

part 'translation.g.dart';

@JsonSerializable()
class Translation {
  final String langCode;
  final String translationKey;
  final String value;
  final String componentName;

  const Translation({
    required this.langCode,
    required this.translationKey,
    required this.value,
    required this.componentName,
  });

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}
