//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <weblate_sdk/weblate_sdk_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) weblate_sdk_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WeblateSdkPlugin");
  weblate_sdk_plugin_register_with_registrar(weblate_sdk_registrar);
}
