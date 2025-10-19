import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mayr_local_notifications_platform_interface.dart';

/// An implementation of [MayrLocalNotificationsPlatform] that uses method channels.
class MethodChannelMayrLocalNotifications
    extends MayrLocalNotificationsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mayr_local_notifications');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<void> init({
    String? channelId,
    String? channelName,
    String? channelDescription,
    bool requestPermissions = true,
    bool enableDebugLogs = false,
  }) async {
    await methodChannel.invokeMethod('init', {
      'channelId': channelId ?? 'mayr_default_channel',
      'channelName': channelName ?? 'MayR Notifications',
      'channelDescription':
          channelDescription ?? 'Default notification channel',
      'requestPermissions': requestPermissions,
      'enableDebugLogs': enableDebugLogs,
    });
  }

  @override
  Future<void> send({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    await methodChannel.invokeMethod('send', {
      'title': title,
      'body': body,
      'payload': payload,
    });
  }

  @override
  Future<void> schedule({
    required String title,
    required String body,
    required DateTime at,
    Map<String, dynamic>? payload,
  }) async {
    await methodChannel.invokeMethod('schedule', {
      'title': title,
      'body': body,
      'timestamp': at.millisecondsSinceEpoch,
      'payload': payload,
    });
  }

  @override
  Future<void> cancelAll() async {
    await methodChannel.invokeMethod('cancelAll');
  }

  @override
  Future<bool> requestPermission() async {
    final result = await methodChannel.invokeMethod<bool>('requestPermission');
    return result ?? false;
  }
}
