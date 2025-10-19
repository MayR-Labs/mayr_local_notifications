import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mayr_local_notifications_method_channel.dart';

abstract class MayrLocalNotificationsPlatform extends PlatformInterface {
  /// Constructs a MayrLocalNotificationsPlatform.
  MayrLocalNotificationsPlatform() : super(token: _token);

  static final Object _token = Object();

  static MayrLocalNotificationsPlatform _instance = MethodChannelMayrLocalNotifications();

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
}
