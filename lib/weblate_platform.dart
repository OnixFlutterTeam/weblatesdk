import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'weblate_plugin_method_channel.dart';

abstract class WebLatePlatform extends PlatformInterface {
  WebLatePlatform() : super(token: _token);

  static final Object _token = Object();

  static WebLatePlatform _instance = WebLatePluginMethodChannel();

  static WebLatePlatform get instance => _instance;

  static set instance(WebLatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
