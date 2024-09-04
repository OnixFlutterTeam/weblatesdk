// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Translation _$TranslationFromJson(Map<String, dynamic> json) => Translation(
      langCode: json['langCode'] as String,
      translationKey: json['translationKey'] as String,
      value: json['value'] as String,
      componentName: json['componentName'] as String,
    );

Map<String, dynamic> _$TranslationToJson(Translation instance) =>
    <String, dynamic>{
      'langCode': instance.langCode,
      'translationKey': instance.translationKey,
      'value': instance.value,
      'componentName': instance.componentName,
    };
