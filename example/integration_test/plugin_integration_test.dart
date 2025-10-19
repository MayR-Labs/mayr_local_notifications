// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mayr_local_notifications/mayr_local_notifications.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Initialize plugin test', (WidgetTester tester) async {
    // Test initialization
    await MayrLocalNotifications.init();
    // If we get here without error, init succeeded
    expect(true, true);
  });

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final MayrLocalNotifications plugin = MayrLocalNotifications();
    final String? version = await plugin.getPlatformVersion();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(version?.isNotEmpty, true);
  });

  testWidgets('Send notification test', (WidgetTester tester) async {
    await MayrLocalNotifications.init();
    
    // Test sending notification - should not throw
    await MayrLocalNotifications.send(
      title: 'Integration Test',
      body: 'This is a test notification',
    );
    
    expect(true, true);
  });

  testWidgets('Schedule notification test', (WidgetTester tester) async {
    await MayrLocalNotifications.init();
    
    // Test scheduling notification - should not throw
    await MayrLocalNotifications.schedule(
      title: 'Scheduled Test',
      body: 'This is a scheduled test notification',
      at: DateTime.now().add(const Duration(seconds: 10)),
    );
    
    expect(true, true);
  });

  testWidgets('Cancel all notifications test', (WidgetTester tester) async {
    await MayrLocalNotifications.init();
    
    // Test canceling notifications - should not throw
    await MayrLocalNotifications.cancelAll();
    
    expect(true, true);
  });
}
