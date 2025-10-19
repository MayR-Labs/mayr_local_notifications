import 'package:flutter_test/flutter_test.dart';
import 'package:mayr_local_notifications/mayr_local_notifications.dart';
import 'package:mayr_local_notifications/mayr_local_notifications_platform_interface.dart';
import 'package:mayr_local_notifications/mayr_local_notifications_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMayrLocalNotificationsPlatform
    with MockPlatformInterfaceMixin
    implements MayrLocalNotificationsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MayrLocalNotificationsPlatform initialPlatform = MayrLocalNotificationsPlatform.instance;

  test('$MethodChannelMayrLocalNotifications is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMayrLocalNotifications>());
  });

  test('getPlatformVersion', () async {
    MayrLocalNotifications mayrLocalNotificationsPlugin = MayrLocalNotifications();
    MockMayrLocalNotificationsPlatform fakePlatform = MockMayrLocalNotificationsPlatform();
    MayrLocalNotificationsPlatform.instance = fakePlatform;

    expect(await mayrLocalNotificationsPlugin.getPlatformVersion(), '42');
  });
}
