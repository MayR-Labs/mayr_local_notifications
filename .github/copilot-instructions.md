# Copilot Instructions for mayr_local_notifications

This repository contains a Flutter plugin for simplified local notifications.

## 🏗️ Project Structure

This is a **Flutter Plugin** project with the following structure:

```
mayr_local_notifications/
├── lib/                          # Dart code
│   ├── mayr_local_notifications.dart              # Public API
│   ├── mayr_local_notifications_platform_interface.dart
│   └── mayr_local_notifications_method_channel.dart
├── android/                      # Android native code (Kotlin)
│   └── src/main/kotlin/com/mayrlabs/mayr_local_notifications/
│       ├── MayrLocalNotificationsPlugin.kt
│       └── NotificationReceiver.kt
├── ios/                          # iOS native code (Swift)
│   └── Classes/MayrLocalNotificationsPlugin.swift
├── macos/                        # macOS native code (Swift)
│   └── Classes/MayrLocalNotificationsPlugin.swift
├── example/                      # Example Flutter app
└── test/                         # Unit tests
```

## 📋 Development Guidelines

### Building and Testing

**Setup:**
```bash
# Get dependencies
flutter pub get

# Run tests
flutter test

# Run analyzer
flutter analyze

# Format code
flutter format .
```

**Testing the Example App:**
```bash
cd example
flutter run
```

### Code Style

- **Dart**: Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- **Kotlin**: Follow Android Kotlin conventions
- **Swift**: Follow Swift API Design Guidelines
- Use `flutter format` to format Dart code
- All public APIs must have documentation comments

### API Design Principles

This plugin follows these core principles:

1. **Zero Configuration**: Users should be able to use the plugin with minimal setup
2. **Cross-Platform**: The same API should work on Android, iOS, and macOS
3. **Simple API**: Prefer simple method calls over complex configuration objects
4. **Sensible Defaults**: Everything should "just work" out of the box

### Key Architectural Decisions

1. **Platform Channels**: Uses MethodChannel for Flutter ↔ Native communication
2. **Platform Interface**: Follows Flutter's plugin architecture with a platform interface pattern
3. **Automatic Setup**: Native code automatically handles permissions and channel creation

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Test Coverage

- All public API methods should have unit tests
- Platform channel implementations should have tests
- Native code should be tested through integration tests

## 📦 Publishing

Before publishing:

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Run `flutter pub publish --dry-run`
4. Verify all tests pass: `flutter test`
5. Verify analyzer is clean: `flutter analyze`
6. Verify formatting: `flutter format --set-exit-if-changed .`

## 🔧 Common Tasks

### Adding a New Method

1. Add method signature to `MayrLocalNotificationsPlatform` interface
2. Implement in `MethodChannelMayrLocalNotifications`
3. Add static method to `MayrLocalNotifications` public API
4. Implement in Android (`MayrLocalNotificationsPlugin.kt`)
5. Implement in iOS (`MayrLocalNotificationsPlugin.swift`)
6. Implement in macOS (`MayrLocalNotificationsPlugin.swift`)
7. Add tests
8. Update documentation

### Debugging

Enable debug logs:
```dart
await MayrLocalNotifications.init(enableDebugLogs: true);
```

### Platform-Specific Notes

**Android:**
- Minimum SDK: 24 (Android 7.0)
- Target SDK: Latest stable
- Uses NotificationCompat for backward compatibility
- AlarmManager for scheduled notifications

**iOS:**
- Minimum version: 12.0
- Uses UserNotifications framework
- Permissions requested automatically

**macOS:**
- Minimum version: 10.14
- Uses UserNotifications framework
- Similar implementation to iOS

## 📚 Resources

- [Flutter Plugin Development](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)
- [Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Android Notifications](https://developer.android.com/develop/ui/views/notifications)
- [iOS UserNotifications](https://developer.apple.com/documentation/usernotifications)

## 🎯 Project Goals

See [DESIGN.md](DESIGN.md) for the complete design philosophy and architecture.

Key goals:
- Simplicity over features
- Zero configuration for 80% use cases
- Cross-platform API parity
- Excellent documentation and examples
