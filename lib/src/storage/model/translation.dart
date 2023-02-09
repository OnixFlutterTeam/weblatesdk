import 'package:hive/hive.dart';

part 'translation.g.dart';

@HiveType(typeId: 1)
class Translation extends HiveObject {
  @HiveField(0)
  final String langCode;
  @HiveField(1)
  final String translationKey;
  @HiveField(2)
  final String value;
  @HiveField(3)
  final String componentName;

  Translation({
    required this.langCode,
    required this.translationKey,
    required this.value,
    required this.componentName,
  });
}
