import 'package:weblate_sdk/src/storage/mapper/mapper.dart';
import 'package:weblate_sdk/src/storage/model/translation.dart';
import 'package:weblate_sdk/src/storage/model/translation_bundle.dart';
import 'package:weblate_sdk/src/util/custom_types.dart';

class _ObjectToMap implements Mapper<List<Translation>, LanguageKeys> {
  @override
  LanguageKeys map(List<Translation> from) {
    LanguageKeys translationsMap = {};
    for (var e in from) {
      translationsMap[e.translationKey] = e.value;
    }
    return translationsMap;
  }
}

class _MapToObject implements Mapper<TranslationBundle, List<Translation>> {
  @override
  List<Translation> map(TranslationBundle from) {
    final translations = List<Translation>.empty(growable: true);
    from.translations.forEach((key, value) {
      translations.add(
        Translation(
          langCode: from.langCode,
          translationKey: key,
          value: value,
          componentName: from.componentName,
        ),
      );
    });
    return translations;
  }
}

class TranslationMapper {
  final _objectToMap = _ObjectToMap();
  final _mapToObject = _MapToObject();

  LanguageKeys objectToMap(List<Translation> from) => _objectToMap.map(from);

  List<Translation> mapToObject(TranslationBundle from) =>
      _mapToObject.map(from);
}
