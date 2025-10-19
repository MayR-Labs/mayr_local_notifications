# 🕊️ Mayr Notifications

A **unified notification layer** for Flutter that simplifies setup and usage of local notifications across **Android**, **iOS**, and **macOS**.
Built with love by **MayR Labs**, inspired by Laravel’s elegance and simplicity.

---

## ✨ Features

* 📱 One-line setup — no native boilerplate
* 🔔 Unified API for Android, iOS, and macOS
* 🕒 Simple scheduling and instant notifications
* 🚀 Built atop `flutter_local_notifications` for reliability
* 🧩 Extensible design for future support of FCM or custom channels

---

## ⚙️ Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  mayr_notifications: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 🪄 Quick Start

Import and initialise:

```dart
import 'package:mayr_notifications/mayr_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MayrNotifications.init(appName: 'MyApp');
  runApp(const MyApp());
}
```

Show a notification:

```dart
await MayrNotifications.show('Hello', 'Welcome to MayR Labs!');
```

Schedule one:

```dart
await MayrNotifications.schedule(
  'Reminder',
  'Don’t forget your meeting at 3 PM.',
  DateTime.now().add(const Duration(hours: 2)),
);
```

---

## 🧱 Configuration

Mayr Notifications automatically handles most of the native setup.
If you encounter permission issues on iOS or macOS, ensure you’ve added:

```xml
<key>NSUserNotificationUsageDescription</key>
<string>This app uses notifications to keep you informed.</string>
```

to your `Info.plist`.

---

## 🛠 Advanced Usage (Coming soon)

* Grouped notifications
* Media controls
* Custom layouts
* Background actions
* Remote push integration

---

## 💡 Philosophy

> Notifications should be powerful but painless.
> Mayr Notifications abstracts the complexity — you focus on the experience.

---

## 🧪 Example

See the `/example` folder for a full implementation.

---
