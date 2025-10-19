//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <mayr_local_notifications/mayr_local_notifications_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) mayr_local_notifications_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MayrLocalNotificationsPlugin");
  mayr_local_notifications_plugin_register_with_registrar(mayr_local_notifications_registrar);
}
