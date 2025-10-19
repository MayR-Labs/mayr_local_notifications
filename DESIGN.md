# 🧠 Design Document: `mayr_local_notifications`

## 🔍 Overview

**Purpose:**
A **simplified local notification plugin** for Flutter that eliminates the complex setup required by `flutter_local_notifications`.

It offers a **plug-and-play** experience — no native edits, no boilerplate, no channel configuration — just initialise once and send notifications from anywhere.

---

## 🎯 Mission Statement

> “The simplest way to show local notifications in Flutter — no native setup, no ceremony, just notifications.”

---

## 🧱 Architecture Overview

`mayr_local_notifications` will be a **Flutter plugin** (not a Dart-only package).
It provides a **unified Dart API** that interacts with **native platform code** via **MethodChannels**.

```
+-----------------------------+
| Flutter App                |
|  - Uses MayrLocalNotifications API
+-------------↑---------------+
              |
              | MethodChannel
              ↓
+-------------+---------------+
| mayr_local_notifications   |
|  - Dart Facade              |
|  - Platform Adapters        |
|  - Native Implementations   |
+-------------+---------------+
              ↓
    (Android / iOS / macOS APIs)
```

---

## ⚙️ Core Objectives

1. **Zero configuration** — just `MayrLocalNotifications.init()` in `main.dart`.
2. **Universal API** across Android, iOS, and macOS.
3. **Automatic permission handling** (ask on init).
4. **Preconfigured notification channels** for Android.
5. **Simple one-line calls for send/schedule/cancel.**
6. **Optional debug logs** and developer-friendly error messages.

---

## 🧩 Components Breakdown

### 1. Public Dart API (Facade Layer)

Entry point for developers — dead simple.

```dart
class MayrLocalNotifications {
  static Future<void> init({
    String? channelId,
    String? channelName,
    bool requestPermissions = true,
    bool enableDebugLogs = false,
  });

  static Future<void> send({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  });

  static Future<void> schedule({
    required String title,
    required String body,
    required DateTime at,
    Map<String, dynamic>? payload,
  });

  static Future<void> cancelAll();
}
```

### Example Use

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MayrLocalNotifications.init();
  runApp(MyApp());
}

// anywhere in app
MayrLocalNotifications.send(
  title: "Drink Water 💧",
  body: "Stay hydrated, champ!",
);
```

---

### 2. MethodChannel Communication (Bridge Layer)

Dart side communicates with native side:

```dart
const MethodChannel _channel = MethodChannel('mayr_local_notifications');

static Future<void> init({ ... }) async {
  await _channel.invokeMethod('init', {...});
}

static Future<void> send({ ... }) async {
  await _channel.invokeMethod('send', {...});
}
```

This gives Dart complete control while delegating actual notification handling to the native layers.

---

### 3. Native Implementations (Platform Layer)

#### **Android – Kotlin**

File: `MayrLocalNotificationsPlugin.kt`

```kotlin
class MayrLocalNotificationsPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var manager: NotificationManagerCompat

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        manager = NotificationManagerCompat.from(context)
        binding.channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                createDefaultChannel()
                result.success(null)
            }
            "send" -> {
                val title = call.argument<String>("title")
                val body = call.argument<String>("body")
                sendNotification(title, body)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
}
```

* Automatically creates a default channel: `mayr_default_channel`.
* Uses `NotificationCompat.Builder` to send notifications.
* Handles permissions automatically (Android 13+).

#### **iOS / macOS – Swift**

File: `MayrLocalNotificationsPlugin.swift`

```swift
public class MayrLocalNotificationsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mayr_local_notifications", binaryMessenger: registrar.messenger())
        let instance = MayrLocalNotificationsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
            result(nil)
        case "send":
            if let args = call.arguments as? [String: Any],
               let title = args["title"] as? String,
               let body = args["body"] as? String {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
```

* Automatically requests permissions.
* Uses the `UserNotifications` framework.
* No manual setup required by developer.

---

### 4. Internal Helpers (Dart Side)

#### a. `Logger`

For debugging:

```dart
void log(String message) {
  if (debug) print('[MayrLocalNotifications] $message');
}
```

#### b. `PermissionHandler`

Auto-checks platform permissions before sending notifications.

#### c. `Config`

Handles optional settings (like overriding default channel name or icon).

---

## 🧠 Technical Considerations

| Concern                                   | Solution                                                                    |
| ----------------------------------------- | --------------------------------------------------------------------------- |
| **Android 13+ permission model**          | Handle via Kotlin permission request wrapper on `init()`                    |
| **iOS permission prompt**                 | Automatically request during init()                                         |
| **Scheduling with timezone**              | Optionally include `timezone` dependency for accurate triggers              |
| **App killed / background notifications** | Default to system handling, but future roadmap can add background receivers |
| **Custom icons / sounds**                 | Optional config parameters in `init()`                                      |

---

## 🧱 Folder Structure

```
mayr_local_notifications/
 ├── lib/
 │    ├── mayr_local_notifications.dart   // public API
 │    └── src/
 │         ├── core/
 │         │    ├── service.dart
 │         │    ├── logger.dart
 │         │    ├── permission_handler.dart
 │         │    └── config.dart
 │         └── models/
 │              └── payload.dart
 ├── android/
 │    └── src/main/kotlin/com/mayrlabs/mayr_local_notifications/MayrLocalNotificationsPlugin.kt
 ├── ios/
 │    └── Classes/MayrLocalNotificationsPlugin.swift
 ├── macos/
 │    └── Classes/MayrLocalNotificationsPlugin.swift
 ├── pubspec.yaml
 └── README.md
```

---

## 🚀 Developer Experience Goal

After installing:

```yaml
dependencies:
  mayr_local_notifications: ^1.0.0
```

Developers only do:

```dart
void main() async {
  await MayrLocalNotifications.init();
  MayrLocalNotifications.send(title: "Hello", body: "Welcome to Mayr Labs!");
}
```

No channel setup.
No platform permission code.
No manual `AndroidManifest.xml` editing.
No boilerplate.

---

## 🧭 Roadmap

| Phase      | Features                                                          |
| ---------- | ----------------------------------------------------------------- |
| **v1.0.0** | Basic notifications (send, schedule, cancelAll), automatic setup  |
| **v1.1.0** | Tap callbacks, payload support                                    |
| **v1.2.0** | Notification history storage                                      |
| **v2.0.0** | Unified API for local + push notifications (Firebase integration) |

---

## 🧩 Summary

| Aspect              | Description                                            |
| ------------------- | ------------------------------------------------------ |
| **Type**            | Flutter Plugin                                         |
| **Purpose**         | Simplify local notifications setup and usage           |
| **Key Strength**    | No manual platform setup required                      |
| **Core Tech**       | Dart + MethodChannel (Kotlin/Swift)                    |
| **Depends on**      | Flutter SDK only                                       |
| **Complexity**      | Medium — mostly native integration, minimal Dart logic |
| **Target Audience** | Flutter devs who want “just works” local notifications |

---

In essence, you’re not just building another plugin — you’re removing the *barrier to entry* that’s kept most devs from touching `flutter_local_notifications`.

Would you like me to now write the **README draft** for the package (the one you’ll publish on pub.dev and GitHub)? It’ll make it look professional and ready for launch.
