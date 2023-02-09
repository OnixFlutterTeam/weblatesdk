import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weblate_sdk/src/client/interceptor/authorization_interceptor.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/storage/hive_storage.dart';
import 'package:weblate_sdk/src/storage/mapper/language_mapper.dart';
import 'package:weblate_sdk/src/storage/mapper/translation_mapper.dart';
import 'package:weblate_sdk/src/storage/model/translation_bundle.dart';
import 'package:weblate_sdk/src/storage/preferences_storage.dart';

import 'package:weblate_sdk/src/util/custom_types.dart';
import 'package:weblate_sdk/src/weblate_exception.dart';

class WebLateClient {
  final _languageMapper = LanguageMapper();
  final _translationMapper = TranslationMapper();

  final String _accessKey;
  final String _host;
  final String _projectName;
  final String _componentName;
  final bool? _disableCache;
  final Duration? _cacheLive;
  final HiveStorage _storage;
  final PreferencesStorage _preferences;
  late Dio _client;

  WebLateClient({
    required String accessKey,
    required String host,
    required String projectName,
    required String componentName,
    required HiveStorage storage,
    required PreferencesStorage preferences,
    bool? disableCache,
    Duration? cacheLive,
  })  : _accessKey = accessKey,
        _host = host,
        _projectName = projectName,
        _componentName = componentName,
        _storage = storage,
        _preferences = preferences,
        _disableCache = disableCache,
        _cacheLive = cacheLive {
    _client = Dio(
      BaseOptions(
        baseUrl: _host,
        connectTimeout: Const.defaultConnectTimeout,
        receiveTimeout: Const.defaultReceiveTimeout,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers':
              'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
          'Access-Control-Allow-Methods': 'GET',
        },
      ),
    );
    _client.interceptors.add(
      AuthorizationInterceptor(
        accessKey: _accessKey,
      ),
    );
  }

  Future<bool> canInitialize() =>_hasConnection();

  Future<TranslationsMap> initialize() async {
    final disableCache = _disableCache ?? kDebugMode;
    if (disableCache) {
      return _getRemoteTranslations();
    }

    final bool hasConnection = await _hasConnection();
    final cacheTimeStamp = await _preferences.getCacheTimestamp();
    final hasCachedTranslations = await _storage.hasCachedTranslations(
      componentName: _componentName,
    );

    if (hasConnection) {
      final isCacheExpired =
          ((DateTime.now().millisecondsSinceEpoch - cacheTimeStamp) >=
              _cacheLiveTimeMillis());
      if (hasCachedTranslations && !isCacheExpired) {
        return _getCachedTranslations();
      } else {
        return _getRemoteTranslations();
      }
    } else {
      if (hasCachedTranslations) {
        return _getCachedTranslations();
      } else {
        throw WebLateException(
          cause: Const.notInitialized,
          message: 'No internet connection and cache not found.',
        );
      }
    }
  }

  Future<TranslationsMap> _getRemoteTranslations() async {
    try {
      final response = await _client.get(
        _composeLanguageUrl(),
      );
      final decodedAsList = response.data as List;
      if (decodedAsList.isEmpty) {
        if (kDebugMode) {
          print(
              '${Const.notInitialized}: No any translation languages found for $_projectName');
        }
        return {};
      }
      //cache results
      final languageObject = _languageMapper.mapToObject(
        decodedAsList.map((e) => e['code'] as String).toList(),
      );
      await _storage.cacheLanguages(languages: languageObject);
      //get translations for language
      TranslationsMap translationsMap = {};
      for (var lang in decodedAsList) {
        final langCode = lang['code'] as String;
        final translations = await _getTranslations(langCode);
        translationsMap[langCode] = translations;
        //cache results
        final translationsObject = _translationMapper.mapToObject(
          TranslationBundle(
            langCode: langCode,
            componentName: _componentName,
            translations: translations,
          ),
        );
        await _storage.cacheTranslations(translations: translationsObject);
      }
      await _preferences
          .saveCacheTimestamp(DateTime.now().millisecondsSinceEpoch);
      if (kDebugMode) {
        print(
          '${Const.success}: Found valid remote translations for [${decodedAsList.map((e) => e['code'] as String).join(',')}]',
        );
      }
      return translationsMap;
    } on DioError catch (dioError) {
      _onDioError(dioError);
      return {};
    } catch (e) {
      if (kDebugMode) {
        print('${Const.notInitialized}: ${e.toString()}');
      }
      return {};
    }
  }

  Future<TranslationsMap> _getCachedTranslations() async {
    final cachedLanguages = await _storage.getCachedLanguages();
    TranslationsMap translationsMap = {};
    for (var lang in cachedLanguages) {
      final cachedTranslations = await _storage.getCachedTranslations(
        componentName: _componentName,
        langCode: lang.langCode,
      );
      translationsMap[lang.langCode] =
          _translationMapper.objectToMap(cachedTranslations);
    }
    if (kDebugMode) {
      print(
        '${Const.success}: Found valid cached translations for [${cachedLanguages.map((e) => e.langCode).join(', ')}]',
      );
    }
    return translationsMap;
  }

  Future<LanguageKeys> _getTranslations(String lang) async {
    try {
      final response = await _client.get(
        _composeTranslationUrl(lang),
      );
      final decodedTranslations = response.data as Map;
      LanguageKeys stringsMap = decodedTranslations.map(
        (key, value) => MapEntry(key, value as String),
      );
      return stringsMap;
    } on DioError catch (dioError) {
      _onDioError(dioError);
      return {};
    } catch (e) {
      if (kDebugMode) {
        print('${Const.notInitialized}: ${e.toString()}');
      }
    }
    return {};
  }

  void _onDioError(DioError dioError) {
    if (kDebugMode) {
      if (dioError.response?.data != null) {
        print(
          '${Const.notInitialized}: ${dioError.response?.statusCode}: ${dioError.response?.data['detail']}',
        );
      } else {
        print(
          '${Const.notInitialized}: ${dioError.type}: ${dioError.message}',
        );
      }
    }
  }

  Future<bool> _hasConnection() async {
    try {
      final result = await InternetAddress.lookup(
        _host.replaceAll('https://', ''),
      );
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  int _cacheLiveTimeMillis() =>
      _cacheLive?.inMilliseconds ?? const Duration(hours: 2).inMilliseconds;

  String _composeLanguageUrl() => '/api/projects/$_projectName/languages/';

  String _composeTranslationUrl(String language) =>
      '/api/translations/$_projectName/$_componentName/$language/file/';
}
