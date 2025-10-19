import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayr_local_notifications/mayr_local_notifications_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMayrLocalNotifications platform = MethodChannelMayrLocalNotifications();
  const MethodChannel channel = MethodChannel('mayr_local_notifications');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getPlatformVersion':
            return '42';
          case 'init':
          case 'send':
          case 'schedule':
          case 'cancelAll':
            return null;
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    );
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('init', () async {
    // Should complete without error
    await platform.init();
  });

  test('send', () async {
    // Should complete without error
    await platform.send(title: 'Test', body: 'Test body');
  });

  test('schedule', () async {
    // Should complete without error
    await platform.schedule(
      title: 'Test',
      body: 'Test body',
      at: DateTime.now().add(const Duration(hours: 1)),
    );
  });

  test('cancelAll', () async {
    // Should complete without error
    await platform.cancelAll();
  });
}
