import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:weblate_sdk/src/client/request/persisted_request.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/storage/mapper/translation_mapper.dart';
import 'package:weblate_sdk/src/storage/model/translation_bundle.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';
import 'package:weblate_sdk/src/util/string_extension.dart';

class TranslationsRequest extends PersistedRequest<String, LanguageKeys> {
  final _translationMapper = TranslationMapper();

  TranslationsRequest({
    required super.dio,
    required super.storage,
    required super.projectName,
    required super.componentName,
  });

  @override
  String get apiEndpoint => '/api/translations/$projectName/$componentName/';

  @override
  Future<LanguageKeys> call(String param) async {
    final languageKeys = await getRemote(param: param);
    await persist(
      languageKeys,
      param: param,
    );
    return languageKeys;
  }

  @override
  Future<LanguageKeys> getRemote({
    String? param,
  }) async {
    try {
      final response = await dio.get(
        '$apiEndpoint$param/file/',
      );
      final decodedTranslations = response.data as Map;
      LanguageKeys stringsMap = {};
      decodedTranslations.forEach((key, value) {
        if (value is String) {
          stringsMap[key] = value;
        }
      });
      /* LanguageKeys stringsMap = decodedTranslations.map(
        (key, value) => MapEntry(key, value as String),
      );*/
      return stringsMap;
    } on DioError catch (dioError) {
      if (kDebugMode) {
        if (dioError.response?.statusCode == 404) {
          print(
            '${Const.apiError}: $componentName component does not have translations for $param. $param translation will ignored.',
          );
        } else {
          final dioMessage = parseDioErrorMessage(dioError);
          print('${Const.apiError}: $dioMessage');
        }
      }
      return {};
    } catch (e) {
      if (kDebugMode) {
        print('${Const.notInitialized}: ${e.toString()}');
      }
      return {};
    }
  }

  @override
  Future<void> persist(
    LanguageKeys data, {
    String? param,
  }) async {
    final translationsObject = _translationMapper.mapToObject(
      TranslationBundle(
        langCode: param?.cleanLangCode() ?? '',
        componentName: componentName,
        translations: data,
      ),
    );
    await storage.cacheTranslations(
      translations: translationsObject,
      langCode: param?.cleanLangCode() ?? '',
      componentName: componentName,
    );
  }
}
