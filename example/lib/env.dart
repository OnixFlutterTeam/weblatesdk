import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Env? _instance;

  static Env get instance => _instance ??= Env._();

  static String get token => dotenv.env['TOKEN'] ?? '';

  static String get host => dotenv.env['HOST'] ?? '';

  static String get projectName => dotenv.env['PROJECT_NAME'] ?? '';

  static String get componentName => dotenv.env['COMPONENT_NAME'] ?? '';

  Env._();

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }
}
