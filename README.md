# 🕊️ MayR Local Notifications

A **unified notification layer** for Flutter that simplifies setup and usage of local notifications across **Android**, **iOS**, and **macOS**.
Built with ❤️ by **MayR Labs**.

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

### 1. Platform Setup (Android only)

**For Android apps**, you need to add a few entries to your `AndroidManifest.xml`. Add this to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add these permissions before <application> -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
    
    <application ...>
        <!-- Add this receiver inside <application> for scheduled notifications -->
        <receiver 
            android:name="com.mayrlabs.mayr_local_notifications.NotificationReceiver"
            android:exported="false" />
        
        <!-- Your activities and other components -->
    </application>
</manifest>
```

**Permissions are handled automatically!** 

When you call `send()` or `schedule()`, the plugin will automatically request permission if needed. You don't need to manually call `requestPermission()` unless you want to request permission upfront.

### 2. Initialize in your main.dart

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

### 3. Send an immediate notification

Show a notification right away. Permission is requested automatically if needed:

```dart
await MayrLocalNotifications.send(
  title: 'Hello! 👋',
  body: 'Welcome to MayR Local Notifications!',
);
```

### 4. Schedule a notification

Schedule a notification for later. Permission is requested automatically if needed:

```dart
await MayrLocalNotifications.schedule(
  title: 'Reminder 🕒',
  body: 'Don't forget your meeting at 3 PM.',
  at: DateTime.now().add(const Duration(hours: 2)),
);
```

### 5. Cancel all notifications

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

**Automatic Permission Handling:** This method automatically requests notification permission if not already granted.

**Parameters:**
- `title` (String, required): The notification title
- `body` (String, required): The notification body text
- `payload` (Map<String, dynamic>, optional): Custom data to attach to the notification

**Throws:** Exception if permission is denied by the user.

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

**Automatic Permission Handling:** This method automatically requests notification permission if not already granted.

**Parameters:**
- `title` (String, required): The notification title
- `body` (String, required): The notification body text
- `at` (DateTime, required): When to show the notification
- `payload` (Map<String, dynamic>, optional): Custom data to attach to the notification

**Throws:** Exception if permission is denied by the user.

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

### MayrLocalNotifications.requestPermission()

Request notification permissions from the user.

**Note:** You typically don't need to call this method directly, as `send()` and `schedule()` automatically request permission if needed. Use this method if you want to request permission upfront (e.g., during onboarding).

Returns `true` if permission is granted, `false` otherwise.

**Platform Behavior:**
- **Android 13+ (API 33+)**: Shows the system permission dialog
- **Android < 13**: Returns `true` (permissions granted at install time)
- **iOS/macOS**: Requests notification authorization or returns current status

**Example:**
```dart
// Optional: Request permission upfront during onboarding
final granted = await MayrLocalNotifications.requestPermission();
if (granted) {
  print('Permission granted!');
} else {
  print('Permission denied');
  // Show user a message to enable notifications in settings
}

// Or just send directly - permission is requested automatically!
await MayrLocalNotifications.send(
  title: 'Test',
  body: 'Notifications work!',
);
```

---

## 🛠 Platform-Specific Setup

### Android

**Required Setup:**

Add the following to your app's `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add these permissions inside the <manifest> tag, before <application> -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
    
    <application ...>
        <!-- Add this receiver inside the <application> tag for scheduled notifications -->
        <receiver 
            android:name="com.mayrlabs.mayr_local_notifications.NotificationReceiver"
            android:exported="false" />
        
        <!-- Your other app components (activities, etc.) -->
    </application>
</manifest>
```

**Permissions Explained:**
- `POST_NOTIFICATIONS`: Required for Android 13+ (API 33+) to show notifications
- `SCHEDULE_EXACT_ALARM` & `USE_EXACT_ALARM`: Required for precise scheduling of notifications

**Note:** The plugin automatically creates a default notification channel and requests runtime permissions on Android 13+.

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

**Common causes and solutions:**

1. **Missing AndroidManifest.xml setup** (Most common!)
   - Ensure you added the `<receiver>` tag to your `android/app/src/main/AndroidManifest.xml`
   - Ensure you added the permission tags (`POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`)
   - See the [Platform-Specific Setup](#-platform-specific-setup) section above

2. **Permission not granted (Android 13+)**
   - The app must request `POST_NOTIFICATIONS` permission at runtime
   - Use the `permission_handler` package to request permissions
   - Check if permission is granted: Go to Settings > Apps > Your App > Notifications
   
   ```dart
   import 'package:permission_handler/permission_handler.dart';
   
   Future<void> checkAndRequestPermission() async {
     final status = await Permission.notification.status;
     if (!status.isGranted) {
       await Permission.notification.request();
     }
   }
   ```

3. **Do Not Disturb mode**
   - Check that Do Not Disturb is not enabled on the device
   - Check notification settings for your app in device Settings

4. **Enable debug logs** to see what's happening:
   ```dart
   await MayrLocalNotifications.init(enableDebugLogs: true);
   ```
   Then check Android Studio's Logcat for `[MayrLocalNotifications]` messages

5. **Test with immediate notifications first**
   - If immediate notifications don't work, scheduled notifications won't work either
   - Fix immediate notifications before testing scheduled ones

### Notifications not appearing on iOS/macOS

1. **Permission not granted**
   - Check Settings > Your App > Notifications
   - Ensure notifications are enabled for your app

2. **App in foreground**
   - iOS/macOS won't show notification banners when the app is in the foreground
   - Test by sending app to background or locking device

3. **Enable debug logs** to troubleshoot:
   ```dart
   await MayrLocalNotifications.init(enableDebugLogs: true);
   ```

### Scheduled notifications not working

1. **Ensure the BroadcastReceiver is registered** (Android only)
   - Check that you added the `<receiver>` tag in AndroidManifest.xml
   - The receiver must be inside the `<application>` tag

2. **Check exact alarm permissions** (Android 12+)
   - Some devices require special permissions for exact alarms
   - Add `SCHEDULE_EXACT_ALARM` permission to AndroidManifest.xml

3. **Battery optimization**
   - Some devices may kill background processes
   - Check device battery optimization settings for your app

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
