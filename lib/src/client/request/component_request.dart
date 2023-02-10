import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weblate_sdk/src/client/request/persisted_request.dart';
import 'package:weblate_sdk/src/const.dart';
import 'package:weblate_sdk/src/storage/mapper/language_mapper.dart';

class ComponentRequest extends PersistedRequest<void, List<String>> {
  final _languageMapper = LanguageMapper();

  ComponentRequest({
    required super.dio,
    required super.storage,
    required super.projectName,
    required super.componentName,
  });

  @override
  String get apiEndpoint =>
      '/api/components/$projectName/$componentName/translations/';

  @override
  Future<List<String>> call(void param) async {
    final data = await getRemote();
    await persist(data);
    return data;
  }

  @override
  Future<List<String>> getRemote({
    String? param,
  }) async {
    try {
      final response = await dio.get(apiEndpoint);
      final componentLanguageResponse = response.data as Map;
      final componentLanguages = componentLanguageResponse['results'] as List;
      final decodedAsList = componentLanguages
          .map((e) => e['language']['code'] as String)
          .toList();
      if (kDebugMode) {
        print(
            '${Const.packageName}: Got [${decodedAsList.join(', ')}] languages for $componentName component.');
      }
      return decodedAsList;
    } on DioError catch (e) {
      if (kDebugMode) {
        final dioMessage = parseDioErrorMessage(e);
        print('${Const.apiError}: $dioMessage');
      }
      return List.empty();
    } catch (e, _) {
      return List.empty();
    }
  }

  @override
  Future<void> persist(
    List<String> data, {
    String? param,
  }) async {
    final languageObject = _languageMapper.mapToObject(
      data,
    );
    await storage.cacheLanguages(languages: languageObject);
  }
}
