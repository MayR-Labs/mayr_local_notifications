# 🕊️ MayR Local Notifications

A **unified notification layer** for Flutter that simplifies setup and usage of local notifications across **Android**, **iOS**, and **macOS**.
Built with love by **MayR Labs**, inspired by Laravel's elegance and simplicity.

---

## ✨ Features

* 📱 One-line setup — no native boilerplate required
* 🔔 Unified API for Android, iOS, and macOS
* 🕒 Simple scheduling and instant notifications
* 🚀 Automatic permission handling
* 🎯 Zero configuration needed - just init and go!
* 🧩 Lightweight and minimal dependencies

---

## ⚙️ Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  mayr_local_notifications: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 🪄 Quick Start

### 1. Initialize in your main.dart

Import and initialize the plugin before running your app:

```dart
import 'package:flutter/material.dart';
import 'package:mayr_local_notifications/mayr_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize with default settings
  await MayrLocalNotifications.init();
  
  runApp(const MyApp());
}
```

### 2. Send an immediate notification

Show a notification right away:

```dart
await MayrLocalNotifications.send(
  title: 'Hello! 👋',
  body: 'Welcome to MayR Local Notifications!',
);
```

### 3. Schedule a notification

Schedule a notification for later:

```dart
await MayrLocalNotifications.schedule(
  title: 'Reminder 🕒',
  body: 'Don't forget your meeting at 3 PM.',
  at: DateTime.now().add(const Duration(hours: 2)),
);
```

### 4. Cancel all notifications

Remove all pending scheduled notifications:

```dart
await MayrLocalNotifications.cancelAll();
```

---

## 📚 API Reference

### MayrLocalNotifications.init()

Initialize the notification system. Call this once in your `main()` function.

**Parameters:**
- `channelId` (String, optional): Custom channel ID for Android. Default: `'mayr_default_channel'`
- `channelName` (String, optional): Custom channel name for Android. Default: `'MayR Notifications'`
- `channelDescription` (String, optional): Custom channel description for Android. Default: `'Default notification channel'`
- `requestPermissions` (bool, optional): Whether to automatically request notification permissions. Default: `true`
- `enableDebugLogs` (bool, optional): Enable debug logging. Default: `false`

**Example:**
```dart
await MayrLocalNotifications.init(
  channelId: 'my_custom_channel',
  channelName: 'My App Notifications',
  enableDebugLogs: true,
);
```

---

### MayrLocalNotifications.send()

Send an immediate notification.

**Parameters:**
- `title` (String, required): The notification title
- `body` (String, required): The notification body text
- `payload` (Map<String, dynamic>, optional): Custom data to attach to the notification

**Example:**
```dart
await MayrLocalNotifications.send(
  title: 'New Message',
  body: 'You have received a new message!',
  payload: {'userId': '123', 'type': 'message'},
);
```

---

### MayrLocalNotifications.schedule()

Schedule a notification for a specific time.

**Parameters:**
- `title` (String, required): The notification title
- `body` (String, required): The notification body text
- `at` (DateTime, required): When to show the notification
- `payload` (Map<String, dynamic>, optional): Custom data to attach to the notification

**Example:**
```dart
await MayrLocalNotifications.schedule(
  title: 'Morning Reminder',
  body: 'Time to start your day!',
  at: DateTime(2025, 10, 20, 8, 0), // October 20, 2025 at 8:00 AM
);
```

---

### MayrLocalNotifications.cancelAll()

Cancel all pending scheduled notifications.

**Example:**
```dart
await MayrLocalNotifications.cancelAll();
```

---

## 🛠 Platform-Specific Setup

### Android

**Permissions:**

The plugin automatically handles notification permissions. However, for Android 13+ (API level 33+), your app should request the `POST_NOTIFICATIONS` permission. The plugin will handle this automatically when you call `init()` with `requestPermissions: true` (which is the default).

No changes to `AndroidManifest.xml` are required for basic functionality. The plugin automatically creates a default notification channel.

**Custom Icon (Optional):**

To use a custom notification icon, add a drawable resource named `ic_notification.png` to your Android `res/drawable` folders. Otherwise, the plugin will use your app's launcher icon.

---

### iOS

**Permissions:**

The plugin automatically requests notification permissions during initialization. Ensure your app's `Info.plist` includes a usage description (this is optional but recommended):

```xml
<key>NSUserNotificationUsageDescription</key>
<string>This app uses notifications to keep you informed.</string>
```

No other setup is required!

---

### macOS

**Permissions:**

Similar to iOS, the plugin automatically requests notification permissions. Ensure your macOS app has the necessary entitlements. The plugin handles everything else automatically.

---

## 🧪 Example App

Check out the `/example` folder for a complete working demo that showcases:
- Immediate notifications
- Scheduled notifications
- Canceling notifications
- Status feedback

To run the example:

```bash
cd example
flutter run
```

---

## 💡 Philosophy

> Notifications should be powerful but painless.
> MayR Local Notifications abstracts the complexity — you focus on the experience.

This plugin is designed with these principles:
- **Zero Configuration**: No manual setup of channels, icons, or permissions
- **Cross-Platform**: One API works everywhere
- **Developer-Friendly**: Clear API with helpful documentation
- **Minimal Dependencies**: Only what's necessary

---

## 🎯 Use Cases

Perfect for:
- Reminder apps
- Productivity tools
- Health and fitness trackers
- Educational apps with scheduled lessons
- Any app that needs simple local notifications

---

## 🐛 Troubleshooting

### Notifications not appearing on Android

1. Ensure your app has notification permissions (automatically requested on Android 13+)
2. Check that Do Not Disturb is not enabled on the device
3. Enable debug logs to see what's happening:
   ```dart
   await MayrLocalNotifications.init(enableDebugLogs: true);
   ```

### Notifications not appearing on iOS/macOS

1. Ensure notification permissions are granted (check in Settings)
2. Make sure the app is in the background or device is locked when testing
3. Enable debug logs to troubleshoot:
   ```dart
   await MayrLocalNotifications.init(enableDebugLogs: true);
   ```

---

## 🚀 Roadmap

| Version | Features |
|---------|----------|
| **v1.0.0** | ✅ Basic notifications (send, schedule, cancelAll) |
| **v1.1.0** | 📋 Tap callbacks and payload handling |
| **v1.2.0** | 📊 Notification history |
| **v2.0.0** | 🔥 Push notifications integration |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 💬 Support

If you encounter any issues or have questions:
1. Check the [example app](example/)
2. Enable debug logs and check the console output
3. Open an issue on [GitHub](https://github.com/MayR-Labs/mayr_local_notifications/issues)

---

Built with ❤️ by **MayR Labs**
