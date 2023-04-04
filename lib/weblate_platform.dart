import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'weblate_plugin_method_channel.dart';

abstract class WeblatePlatform extends PlatformInterface {
  WeblatePlatform() : super(token: _token);

  static final Object _token = Object();

  static WeblatePlatform _instance = WeblatePluginMethodChannel();

  static WeblatePlatform get instance => _instance;

  static set instance(WeblatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
