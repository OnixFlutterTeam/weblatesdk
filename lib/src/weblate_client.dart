import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';

class WebLateClient {
  final String _accessKey;
  final String _host;
  final String _projectName;
  final String _componentName;

  WebLateClient({
    required String accessKey,
    required String host,
    required String projectName,
    required String componentName,
  })  : _accessKey = accessKey,
        _host = host,
        _projectName = projectName,
        _componentName = componentName;

  Future<TranslationsMap> initialize() async {
    final client = http.Client();
    try {
      final url = _composeLanguageUrl();
      var response = await client.get(
        Uri.https(
          _host,
          url,
        ),
        headers: {'Authorization': 'Token $_accessKey'},
      );
      var decodedLanguages = jsonDecode(utf8.decode(response.bodyBytes));
      try {
        final decodedAsList = decodedLanguages as List;
        if (decodedAsList.isEmpty) {
          if (kDebugMode) {
            print(
                '${Const.notInitialized}: No any translation languages found for $_projectName');
          }
          return {};
        }
        TranslationsMap translationsMap = {};
        for (var lang in decodedAsList) {
          final langCode = lang['code'] as String;
          final translations = await _getTranslations(langCode);
          translationsMap[langCode] = translations;
        }
        return translationsMap;
      } catch (e) {
        final decodedAsError = decodedLanguages as Map;
        if (kDebugMode) {
          print('${Const.notInitialized}: ${decodedAsError['detail']}');
        }
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print('${Const.notInitialized}: init ${e.toString()}');
      }
      return {};
    } finally {
      client.close();
    }
  }

  Future<LanguageKeys> _getTranslations(String lang) async {
    final client = http.Client();
    try {
      final url = _composeTranslationUrl(lang);
      var response = await client.get(
        Uri.https(
          _host,
          url,
        ),
        headers: {'Authorization': 'Token $_accessKey'},
      );
      final decodedTranslations =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      LanguageKeys stringsMap = decodedTranslations.map(
        (key, value) => MapEntry(key, value as String),
      );
      return stringsMap;
    } catch (e) {
      if (kDebugMode) {
        print('${Const.notInitialized}: ${e.toString()}');
      }
    } finally {
      client.close();
    }
    return {};
  }

  String _composeLanguageUrl() => 'api/projects/$_projectName/languages/';

  String _composeTranslationUrl(String language) =>
      'api/translations/$_projectName/$_componentName/$language/file/';
}
