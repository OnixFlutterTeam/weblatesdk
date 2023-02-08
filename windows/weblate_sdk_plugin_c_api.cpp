#include "include/weblate_sdk/weblate_sdk_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "weblate_sdk_plugin.h"

void WeblateSdkPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  weblate_sdk::WeblateSdkPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
