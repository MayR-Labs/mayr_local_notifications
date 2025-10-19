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

  @override
  Future<void> init({
    String? channelId,
    String? channelName,
    String? channelDescription,
    bool requestPermissions = true,
    bool enableDebugLogs = false,
  }) => Future.value();

  @override
  Future<void> send({required String title, required String body, Map<String, dynamic>? payload}) =>
      Future.value();

  @override
  Future<void> schedule({
    required String title,
    required String body,
    required DateTime at,
    Map<String, dynamic>? payload,
  }) => Future.value();

  @override
  Future<void> cancelAll() => Future.value();

  @override
  Future<bool> requestPermission() => Future.value(true);
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

  test('init', () async {
    MockMayrLocalNotificationsPlatform fakePlatform = MockMayrLocalNotificationsPlatform();
    MayrLocalNotificationsPlatform.instance = fakePlatform;

    // Should complete without error
    await MayrLocalNotifications.init();
  });

  test('send notification', () async {
    MockMayrLocalNotificationsPlatform fakePlatform = MockMayrLocalNotificationsPlatform();
    MayrLocalNotificationsPlatform.instance = fakePlatform;

    // Should complete without error
    await MayrLocalNotifications.send(title: 'Test', body: 'Test body');
  });

  test('schedule notification', () async {
    MockMayrLocalNotificationsPlatform fakePlatform = MockMayrLocalNotificationsPlatform();
    MayrLocalNotificationsPlatform.instance = fakePlatform;

    // Should complete without error
    await MayrLocalNotifications.schedule(
      title: 'Test',
      body: 'Test body',
      at: DateTime.now().add(const Duration(hours: 1)),
    );
  });

  test('cancelAll', () async {
    MockMayrLocalNotificationsPlatform fakePlatform = MockMayrLocalNotificationsPlatform();
    MayrLocalNotificationsPlatform.instance = fakePlatform;

    // Should complete without error
    await MayrLocalNotifications.cancelAll();
  });

  test('requestPermission', () async {
    MockMayrLocalNotificationsPlatform fakePlatform = MockMayrLocalNotificationsPlatform();
    MayrLocalNotificationsPlatform.instance = fakePlatform;

    // Should return true
    final granted = await MayrLocalNotifications.requestPermission();
    expect(granted, true);
  });
}
