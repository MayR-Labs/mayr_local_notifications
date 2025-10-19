#ifndef FLUTTER_PLUGIN_MAYR_LOCAL_NOTIFICATIONS_PLUGIN_H_
#define FLUTTER_PLUGIN_MAYR_LOCAL_NOTIFICATIONS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace mayr_local_notifications {

class MayrLocalNotificationsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MayrLocalNotificationsPlugin();

  virtual ~MayrLocalNotificationsPlugin();

  // Disallow copy and assign.
  MayrLocalNotificationsPlugin(const MayrLocalNotificationsPlugin&) = delete;
  MayrLocalNotificationsPlugin& operator=(const MayrLocalNotificationsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace mayr_local_notifications

#endif  // FLUTTER_PLUGIN_MAYR_LOCAL_NOTIFICATIONS_PLUGIN_H_
