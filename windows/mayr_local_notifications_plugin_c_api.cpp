#include "include/mayr_local_notifications/mayr_local_notifications_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "mayr_local_notifications_plugin.h"

void MayrLocalNotificationsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  mayr_local_notifications::MayrLocalNotificationsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
