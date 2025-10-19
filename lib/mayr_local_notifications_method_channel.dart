import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mayr_local_notifications_platform_interface.dart';

/// An implementation of [MayrLocalNotificationsPlatform] that uses method channels.
class MethodChannelMayrLocalNotifications extends MayrLocalNotificationsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mayr_local_notifications');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
