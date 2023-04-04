import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'weblate_platform.dart';

/// An implementation of [DemoPluginPlatform] that uses method channels.
class WeblatePluginMethodChannel extends WeblatePlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('weblate_sdk');

}
