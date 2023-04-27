import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'weblate_platform.dart';

class WebLatePluginMethodChannel extends WebLatePlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('weblate_sdk');

}
