import 'package:hive/hive.dart';

part 'language.g.dart';

@HiveType(typeId: 0)
class Language extends HiveObject {
  @HiveField(0)
  final String langCode;

  Language({
    required this.langCode,
  });
}
