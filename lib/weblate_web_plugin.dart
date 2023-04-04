// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'weblate_platform.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class WeblateWebPlugin extends WeblatePlatform {
  WeblateWebPlugin();

  static void registerWith(Registrar registrar) {
    WeblatePlatform.instance = WeblateWebPlugin();
  }
}
