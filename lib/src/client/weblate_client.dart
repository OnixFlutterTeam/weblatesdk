import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weblate_sdk/src/client/request/component_request.dart';
import 'package:weblate_sdk/src/client/interceptor/authorization_interceptor.dart';
import 'package:weblate_sdk/src/client/request/persisted_request.dart';
import 'package:weblate_sdk/src/client/request/translations_request.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/storage/hive_storage.dart';
import 'package:weblate_sdk/src/storage/preferences_storage.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';
import 'package:weblate_sdk/src/util/string_extension.dart';

class WebLateClient {
  final String _token;
  final String _host;
  final String _projectName;
  final String _componentName;
  final String _defaultLanguage;
  final bool? _disableCache;
  final Duration? _cacheLive;
  final HiveStorage _storage;
  final PreferencesStorage _preferences;
  late PersistedRequest<void, List<String>> _componentRequest;
  late PersistedRequest<String, LanguageKeys> _translationsRequest;
  late final Connectivity _connectivity = Connectivity();

  WebLateClient({
    required String token,
    required String host,
    required String projectName,
    required String componentName,
    required String defaultLanguage,
    required HiveStorage storage,
    required PreferencesStorage preferences,
    bool? disableCache,
    Duration? cacheLive,
  })  : _token = token,
        _host = host,
        _projectName = projectName,
        _componentName = componentName,
        _defaultLanguage = defaultLanguage,
        _storage = storage,
        _preferences = preferences,
        _disableCache = disableCache,
        _cacheLive = cacheLive {
    final client = Dio(
      BaseOptions(
        baseUrl: _host,
        connectTimeout: Const.defaultConnectTimeout,
        receiveTimeout: Const.defaultReceiveTimeout,
        headers: Const.defaultCommonHeaders,
      ),
    );
    client.interceptors.add(
      AuthorizationInterceptor(
        token: _token,
      ),
    );
    _componentRequest = ComponentRequest(
      dio: client,
      storage: _storage,
      projectName: _projectName,
      componentName: _componentName,
    );
    _translationsRequest = TranslationsRequest(
      dio: client,
      storage: _storage,
      projectName: _projectName,
      componentName: _componentName,
    );
  }

  Future<bool> canInitialize() => _hasConnection();

  Future<TranslationsMap> initialize() async {
    final disableCache = _disableCache ?? kDebugMode;
    if (disableCache) {
      return _getRemoteTranslations();
    }

    var hasConnection = false;
    if (kIsWeb) {
      hasConnection = true;
    } else {
      hasConnection = await _hasConnection();
    }

    final cacheTimeStamp = await _preferences.getCacheTimestamp();
    final hasCachedTranslations = await _storage.hasCachedTranslations(
      componentName: _componentName,
      defaultLanguage: _defaultLanguage,
    );

    if (hasConnection) {
      final isCacheExpired =
          ((DateTime.now().millisecondsSinceEpoch - cacheTimeStamp) >=
              _cacheLiveTimeMillis());
      if (hasCachedTranslations && !isCacheExpired) {
        return _storage.getCachedTranslations(componentName: _componentName);
      } else {
        return _getRemoteTranslations();
      }
    } else {
      if (hasCachedTranslations) {
        return _storage.getCachedTranslations(componentName: _componentName);
      } else {
        return {};
      }
    }
  }

  Future<TranslationsMap> _getRemoteTranslations() async {
    final languageCodes = await _componentRequest(null);
    TranslationsMap translationsMap = {};
    for (var langCode in languageCodes) {
      final translations = await _translationsRequest(langCode);
      translationsMap[langCode.cleanLangCode()] = translations;
    }
    await _preferences
        .saveCacheTimestamp(DateTime.now().millisecondsSinceEpoch);
    if (kDebugMode) {
      print(
        '${Const.success}: Got remote translations [${languageCodes.join(', ')}] for $_componentName',
      );
    }
    return translationsMap;
  }

  Future<bool> _hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
        return false;
      default:
        return true;
    }
  }

  int _cacheLiveTimeMillis() =>
      _cacheLive?.inMilliseconds ?? const Duration(hours: 2).inMilliseconds;
}
