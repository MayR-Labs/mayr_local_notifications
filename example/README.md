# MayR Local Notifications - Example App

This example demonstrates how to use the `mayr_local_notifications` plugin.

## Features Demonstrated

This example app showcases:

1. **Initialization**: How to initialize the plugin in your `main()` function
2. **Immediate Notifications**: Send notifications that appear right away
3. **Scheduled Notifications**: Schedule notifications to appear at a specific time (10 seconds in the future)
4. **Cancel Notifications**: Cancel all pending scheduled notifications
5. **Status Feedback**: Visual feedback for all operations

## Getting Started

### Running the Example

```bash
flutter run
```

### Code Overview

The example app demonstrates all core features:

```dart
// Initialize in main()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MayrLocalNotifications.init(enableDebugLogs: true);
  runApp(const MyApp());
}

// Send immediate notification
await MayrLocalNotifications.send(
  title: 'Hello! 👋',
  body: 'This is an immediate notification!',
);

// Schedule notification
await MayrLocalNotifications.schedule(
  title: 'Scheduled Reminder 🕒',
  body: 'This was scheduled 10 seconds ago!',
  at: DateTime.now().add(const Duration(seconds: 10)),
);

// Cancel all notifications
await MayrLocalNotifications.cancelAll();
```

## Testing Tips

### Android
- Ensure notification permissions are granted
- Check that Do Not Disturb is disabled
- Immediate notifications appear right away
- Scheduled notifications respect the delay

### iOS
- Grant notification permissions when prompted
- Lock the device or send app to background to see notifications
- Check notification center for pending notifications

### macOS
- Grant notification permissions when prompted
- Notifications appear in the notification center
- You can check scheduled notifications in System Settings

## Learn More

For more information, see the [main plugin README](../README.md).
