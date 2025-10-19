import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mayr_local_notifications_method_channel.dart';

abstract class MayrLocalNotificationsPlatform extends PlatformInterface {
  /// Constructs a MayrLocalNotificationsPlatform.
  MayrLocalNotificationsPlatform() : super(token: _token);

  static final Object _token = Object();

  static MayrLocalNotificationsPlatform _instance =
      MethodChannelMayrLocalNotifications();

  /// The default instance of [MayrLocalNotificationsPlatform] to use.
  ///
  /// Defaults to [MethodChannelMayrLocalNotifications].
  static MayrLocalNotificationsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MayrLocalNotificationsPlatform] when
  /// they register themselves.
  static set instance(MayrLocalNotificationsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Initialize the notification system
  Future<void> init({
    String? channelId,
    String? channelName,
    String? channelDescription,
    bool requestPermissions = true,
    bool enableDebugLogs = false,
  }) {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// Send an immediate notification
  Future<void> send({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) {
    throw UnimplementedError('send() has not been implemented.');
  }

  /// Schedule a notification for a specific time
  Future<void> schedule({
    required String title,
    required String body,
    required DateTime at,
    Map<String, dynamic>? payload,
  }) {
    throw UnimplementedError('schedule() has not been implemented.');
  }

  /// Cancel all pending notifications
  Future<void> cancelAll() {
    throw UnimplementedError('cancelAll() has not been implemented.');
  }

  /// Request notification permissions
  Future<bool> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }
}
