
import 'mayr_local_notifications_platform_interface.dart';

class MayrLocalNotifications {
  Future<String?> getPlatformVersion() {
    return MayrLocalNotificationsPlatform.instance.getPlatformVersion();
  }
}
