
import 'mayr_local_notifications_platform_interface.dart';

/// MayrLocalNotifications - A simplified local notification plugin for Flutter
/// 
/// Provides a plug-and-play experience for local notifications across
/// Android, iOS, and macOS with minimal setup required.
class MayrLocalNotifications {
  /// Initialize the notification system
  /// 
  /// This should be called once in your main() function before runApp().
  /// 
  /// Parameters:
  /// - [channelId]: Custom channel ID (Android only). Default: 'mayr_default_channel'
  /// - [channelName]: Custom channel name (Android only). Default: 'MayR Notifications'
  /// - [channelDescription]: Custom channel description (Android only). Default: 'Default notification channel'
  /// - [requestPermissions]: Whether to automatically request notification permissions. Default: true
  /// - [enableDebugLogs]: Enable debug logging. Default: false
  /// 
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await MayrLocalNotifications.init();
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> init({
    String? channelId,
    String? channelName,
    String? channelDescription,
    bool requestPermissions = true,
    bool enableDebugLogs = false,
  }) {
    return MayrLocalNotificationsPlatform.instance.init(
      channelId: channelId,
      channelName: channelName,
      channelDescription: channelDescription,
      requestPermissions: requestPermissions,
      enableDebugLogs: enableDebugLogs,
    );
  }

  /// Send an immediate notification
  /// 
  /// Displays a notification immediately.
  /// 
  /// Parameters:
  /// - [title]: The notification title
  /// - [body]: The notification body text
  /// - [payload]: Optional custom data to include with the notification
  /// 
  /// Example:
  /// ```dart
  /// await MayrLocalNotifications.send(
  ///   title: "Hello",
  ///   body: "Welcome to MayR Labs!",
  /// );
  /// ```
  static Future<void> send({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) {
    return MayrLocalNotificationsPlatform.instance.send(
      title: title,
      body: body,
      payload: payload,
    );
  }

  /// Schedule a notification for a specific time
  /// 
  /// Schedules a notification to be displayed at the specified DateTime.
  /// 
  /// Parameters:
  /// - [title]: The notification title
  /// - [body]: The notification body text
  /// - [at]: The DateTime when the notification should be displayed
  /// - [payload]: Optional custom data to include with the notification
  /// 
  /// Example:
  /// ```dart
  /// await MayrLocalNotifications.schedule(
  ///   title: "Reminder",
  ///   body: "Don't forget your meeting!",
  ///   at: DateTime.now().add(Duration(hours: 2)),
  /// );
  /// ```
  static Future<void> schedule({
    required String title,
    required String body,
    required DateTime at,
    Map<String, dynamic>? payload,
  }) {
    return MayrLocalNotificationsPlatform.instance.schedule(
      title: title,
      body: body,
      at: at,
      payload: payload,
    );
  }

  /// Cancel all pending notifications
  /// 
  /// Removes all scheduled notifications that haven't been displayed yet.
  /// 
  /// Example:
  /// ```dart
  /// await MayrLocalNotifications.cancelAll();
  /// ```
  static Future<void> cancelAll() {
    return MayrLocalNotificationsPlatform.instance.cancelAll();
  }

  /// Get the platform version (for debugging)
  Future<String?> getPlatformVersion() {
    return MayrLocalNotificationsPlatform.instance.getPlatformVersion();
  }
}
