import 'package:weblate_sdk/src/storage/mapper/mapper.dart';
import 'package:weblate_sdk/src/storage/model/language.dart';

class _ObjectToMap implements Mapper<List<Language>, List<String>> {
  @override
  List<String> map(List<Language> from) {
    return from.map((e) => e.langCode).toList();
  }
}

class _MapToObject implements Mapper<List<String>, List<Language>> {
  @override
  List<Language> map(List<String> from) {
    return from
        .map(
          (e) => Language(langCode: e),
        )
        .toList();
  }
}

class LanguageMapper {
  final _objectToMap = _ObjectToMap();
  final _mapToObject = _MapToObject();

  List<String> objectToMap(List<Language> from) =>
      _objectToMap.map(from);

  List<Language> mapToObject(List<String> from) =>
      _mapToObject.map(from);
}
