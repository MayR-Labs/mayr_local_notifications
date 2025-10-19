# MayR Local Notifications - API Documentation

Complete API reference for the `mayr_local_notifications` Flutter plugin.

## Table of Contents

- [Classes](#classes)
  - [MayrLocalNotifications](#mayrlocalnotifications)
- [Methods](#methods)
  - [init()](#init)
  - [send()](#send)
  - [schedule()](#schedule)
  - [cancelAll()](#cancelall)
  - [requestPermission()](#requestpermission)
  - [getPlatformVersion()](#getplatformversion)

---

## Classes

### MayrLocalNotifications

The main entry point for using local notifications in your Flutter application.

**Type:** Static class

**Example:**
```dart
import 'package:mayr_local_notifications/mayr_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MayrLocalNotifications.init();
  runApp(MyApp());
}
```

---

## Methods

### init()

Initialize the notification system. This method should be called once before using any other notification methods, typically in your `main()` function.

**Signature:**
```dart
static Future<void> init({
  String? channelId,
  String? channelName,
  String? channelDescription,
  bool requestPermissions = true,
  bool enableDebugLogs = false,
})
```

**Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `channelId` | `String?` | No | `'mayr_default_channel'` | Custom notification channel ID (Android only) |
| `channelName` | `String?` | No | `'MayR Notifications'` | Custom notification channel name (Android only) |
| `channelDescription` | `String?` | No | `'Default notification channel'` | Custom notification channel description (Android only) |
| `requestPermissions` | `bool` | No | `true` | Whether to automatically request notification permissions |
| `enableDebugLogs` | `bool` | No | `false` | Enable debug logging for troubleshooting |

**Returns:** `Future<void>`

**Throws:** May throw a `PlatformException` if initialization fails.

**Example:**
```dart
// Basic initialization with defaults
await MayrLocalNotifications.init();

// Custom initialization with debug logs
await MayrLocalNotifications.init(
  channelId: 'my_app_channel',
  channelName: 'My App Notifications',
  channelDescription: 'Notifications from My App',
  enableDebugLogs: true,
);
```

**Platform-Specific Behavior:**

- **Android**: Creates a notification channel with the specified ID and name. Requests POST_NOTIFICATIONS permission on Android 13+.
- **iOS/macOS**: Requests notification authorization with alert, sound, and badge options.

---

### send()

Send an immediate notification that appears right away.

**Automatic Permission Handling:** This method automatically requests notification permission if not already granted. You don't need to call `requestPermission()` manually.

**Signature:**
```dart
static Future<void> send({
  required String title,
  required String body,
  Map<String, dynamic>? payload,
})
```

**Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `title` | `String` | Yes | - | The notification title |
| `body` | `String` | Yes | - | The notification body text |
| `payload` | `Map<String, dynamic>?` | No | `null` | Optional custom data to attach to the notification |

**Returns:** `Future<void>`

**Throws:** 
- `Exception` if notification permission is denied by the user
- `PlatformException` if the notification fails to send for other reasons

**Example:**
```dart
// Simple notification - permission requested automatically if needed
await MayrLocalNotifications.send(
  title: 'Hello!',
  body: 'Welcome to our app!',
);

// Notification with payload
await MayrLocalNotifications.send(
  title: 'New Message',
  body: 'You have a new message from John',
  payload: {
    'type': 'message',
    'senderId': 'john123',
    'timestamp': DateTime.now().toIso8601String(),
  },
);

// With error handling
try {
  await MayrLocalNotifications.send(
    title: 'Test',
    body: 'Testing notifications',
  );
} catch (e) {
  print('Failed to send notification: $e');
  // Handle permission denial or other errors
}
```

**Platform-Specific Behavior:**

- **Android**: Uses NotificationCompat to create and display the notification immediately. Requests POST_NOTIFICATIONS permission on Android 13+ if not granted.
- **iOS/macOS**: Uses UNNotificationRequest with a minimal trigger delay (0.1 seconds). Requests authorization if not determined.

---

### schedule()

Schedule a notification to appear at a specific date and time.

**Automatic Permission Handling:** This method automatically requests notification permission if not already granted. You don't need to call `requestPermission()` manually.

**Signature:**
```dart
static Future<void> schedule({
  required String title,
  required String body,
  required DateTime at,
  Map<String, dynamic>? payload,
})
```

**Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `title` | `String` | Yes | - | The notification title |
| `body` | `String` | Yes | - | The notification body text |
| `at` | `DateTime` | Yes | - | The date and time when the notification should appear |
| `payload` | `Map<String, dynamic>?` | No | `null` | Optional custom data to attach to the notification |

**Returns:** `Future<void>`

**Throws:** 
- `Exception` if notification permission is denied by the user
- `PlatformException` if scheduling fails
- `ArgumentError` if the scheduled time is in the past

**Example:**
```dart
// Schedule for a specific time - permission requested automatically if needed
await MayrLocalNotifications.schedule(
  title: 'Meeting Reminder',
  body: 'Your meeting starts in 15 minutes',
  at: DateTime(2025, 10, 20, 14, 45), // October 20, 2025 at 2:45 PM
);

// Schedule relative to current time
await MayrLocalNotifications.schedule(
  title: 'Take a Break',
  body: 'Time for a 5-minute break!',
  at: DateTime.now().add(const Duration(hours: 1)),
  payload: {
    'type': 'reminder',
    'category': 'health',
  },
);
```

**Platform-Specific Behavior:**

- **Android**: Uses AlarmManager with `setExactAndAllowWhileIdle()` for reliable delivery.
- **iOS/macOS**: Uses UNNotificationRequest with a time interval trigger.

**Notes:**
- The scheduled time must be in the future. Past times will be rejected.
- Scheduled notifications persist across app restarts (platform-dependent).
- On Android, the app may need exact alarm permissions for precise timing.

---

### cancelAll()

Cancel all pending scheduled notifications. This removes all notifications that haven't been displayed yet.

**Signature:**
```dart
static Future<void> cancelAll()
```

**Parameters:** None

**Returns:** `Future<void>`

**Throws:** May throw a `PlatformException` if cancellation fails.

**Example:**
```dart
// Cancel all pending notifications
await MayrLocalNotifications.cancelAll();
```

**Platform-Specific Behavior:**

- **Android**: Calls `NotificationManager.cancelAll()` to remove all notifications.
- **iOS/macOS**: Calls `UNUserNotificationCenter.removeAllPendingNotificationRequests()`.

**Notes:**
- This only cancels scheduled notifications, not those already displayed.
- Already shown notifications remain in the notification center.

---

### requestPermission()

Request notification permissions from the user.

**Note:** You typically don't need to call this method directly, as `send()` and `schedule()` automatically request permission if needed. Use this method only if you want to request permission upfront (e.g., during app onboarding) or check permission status explicitly.

**Signature:**
```dart
static Future<bool> requestPermission()
```

**Parameters:** None

**Returns:** `Future<bool>` - Returns `true` if permission is granted, `false` otherwise.

**Throws:** May throw a `PlatformException` if the request fails.

**Example:**
```dart
// Optional: Request permission upfront during onboarding
final granted = await MayrLocalNotifications.requestPermission();
if (granted) {
  print('Permission granted!');
} else {
  print('Permission denied. Please enable notifications in settings.');
}

// Alternatively, just call send() or schedule() directly
// Permission will be requested automatically if needed
await MayrLocalNotifications.send(
  title: 'Test',
  body: 'You can now receive notifications!',
);

// With user feedback during onboarding
Future<void> setupNotifications() async {
  final granted = await MayrLocalNotifications.requestPermission();
  
  if (!granted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notifications Disabled'),
        content: Text('Please enable notifications in your device settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
```

**Platform-Specific Behavior:**

- **Android 13+ (API 33+)**: Shows the system permission dialog. User can grant or deny. Returns the result immediately.
- **Android < 13**: Returns `true` as permissions are granted at install time (no runtime permission needed).
- **iOS/macOS**: Shows the system authorization dialog if permission hasn't been determined yet. Returns the current or newly granted authorization status.

**Notes:**
- On iOS/macOS, once a user denies permission, calling this method again will return `false` without showing the dialog. Users must enable notifications in Settings.
- This method can be called multiple times safely. It checks the current permission status first.
- It's recommended to call this method before sending your first notification, especially on Android 13+.
- You can call this method during app initialization or just before sending a notification.

**When to use:**
- Call this method when your app first needs to send notifications
- Call it in response to a user action (e.g., "Enable Notifications" button)
- Call it after app initialization if notifications are a core feature

---

### getPlatformVersion()

Get the platform version string. This is primarily useful for debugging and testing.

**Signature:**
```dart
Future<String?> getPlatformVersion()
```

**Parameters:** None

**Returns:** `Future<String?>` - A string describing the platform and version, e.g., "Android 13" or "iOS 16.0"

**Example:**
```dart
final plugin = MayrLocalNotifications();
final version = await plugin.getPlatformVersion();
print('Running on: $version');
// Output: "Running on: Android 13" or "iOS 16.0"
```

**Notes:**
- This is an instance method, unlike the other static methods.
- Primarily used for debugging and testing purposes.

---

## Usage Patterns

### Basic Setup

```dart
import 'package:flutter/material.dart';
import 'package:mayr_local_notifications/mayr_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MayrLocalNotifications.init();
  runApp(MyApp());
}
```

### Reminder App Pattern

```dart
class ReminderService {
  static Future<void> setReminder({
    required String title,
    required String message,
    required DateTime when,
  }) async {
    await MayrLocalNotifications.schedule(
      title: title,
      body: message,
      at: when,
      payload: {
        'type': 'reminder',
        'timestamp': when.toIso8601String(),
      },
    );
  }
  
  static Future<void> clearAllReminders() async {
    await MayrLocalNotifications.cancelAll();
  }
}
```

### Notification with Error Handling

```dart
Future<void> sendNotificationSafely() async {
  try {
    await MayrLocalNotifications.send(
      title: 'Important Update',
      body: 'Your data has been synced successfully',
    );
    print('Notification sent successfully');
  } on PlatformException catch (e) {
    print('Failed to send notification: ${e.message}');
    // Handle error (e.g., show in-app message)
  }
}
```

---

## Error Handling

All methods may throw `PlatformException` in case of errors. Common error codes:

| Code | Description | Solution |
|------|-------------|----------|
| `INIT_ERROR` | Initialization failed | Check permissions and platform compatibility |
| `SEND_ERROR` | Failed to send notification | Verify notification permissions are granted |
| `SCHEDULE_ERROR` | Failed to schedule notification | Check that the scheduled time is valid |
| `CANCEL_ERROR` | Failed to cancel notifications | Rare; usually indicates a platform issue |
| `INVALID_ARGS` | Invalid arguments provided | Check that all required parameters are provided |
| `INVALID_TIME` | Scheduled time is in the past | Use a future DateTime |

**Example:**
```dart
try {
  await MayrLocalNotifications.schedule(
    title: 'Test',
    body: 'Test',
    at: DateTime.now().subtract(Duration(hours: 1)), // Past time
  );
} on PlatformException catch (e) {
  if (e.code == 'INVALID_TIME') {
    print('Cannot schedule notifications in the past');
  }
}
```

---

## Platform Requirements

### Android
- Minimum SDK: 24 (Android 7.0)
- Compile SDK: 36+
- Permissions: POST_NOTIFICATIONS (auto-requested on Android 13+)

### iOS
- Minimum version: 12.0
- Frameworks: UserNotifications
- Permissions: Auto-requested on init

### macOS
- Minimum version: 10.14
- Frameworks: UserNotifications
- Permissions: Auto-requested on init

---

## See Also

- [README.md](README.md) - Getting started guide
- [DESIGN.md](DESIGN.md) - Architecture and design decisions
- [Example App](example/) - Complete working example
