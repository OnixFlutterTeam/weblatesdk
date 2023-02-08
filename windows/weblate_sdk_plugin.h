#ifndef FLUTTER_PLUGIN_WEBLATE_SDK_PLUGIN_H_
#define FLUTTER_PLUGIN_WEBLATE_SDK_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace weblate_sdk {

class WeblateSdkPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WeblateSdkPlugin();

  virtual ~WeblateSdkPlugin();

  // Disallow copy and assign.
  WeblateSdkPlugin(const WeblateSdkPlugin&) = delete;
  WeblateSdkPlugin& operator=(const WeblateSdkPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace weblate_sdk

#endif  // FLUTTER_PLUGIN_WEBLATE_SDK_PLUGIN_H_
