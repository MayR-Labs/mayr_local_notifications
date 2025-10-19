import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mayr_local_notifications/mayr_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MayR Local Notifications
  await MayrLocalNotifications.init(enableDebugLogs: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _statusMessage = 'Ready to send notifications';
  final _mayrLocalNotificationsPlugin = MayrLocalNotifications();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _mayrLocalNotificationsPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _sendImmediateNotification() async {
    try {
      await MayrLocalNotifications.send(
        title: 'Hello! 👋',
        body: 'This is an immediate notification from MayR Labs!',
        payload: {'type': 'immediate', 'timestamp': DateTime.now().toString()},
      );
      setState(() {
        _statusMessage = 'Immediate notification sent! ✅';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e ❌';
      });
    }
  }

  Future<void> _scheduleNotification() async {
    try {
      final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
      await MayrLocalNotifications.schedule(
        title: 'Scheduled Reminder 🕒',
        body: 'This notification was scheduled 10 seconds ago!',
        at: scheduledTime,
        payload: {'type': 'scheduled', 'scheduledFor': scheduledTime.toString()},
      );
      setState(() {
        _statusMessage = 'Notification scheduled for 10 seconds from now! ⏰';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e ❌';
      });
    }
  }

  Future<void> _cancelAllNotifications() async {
    try {
      await MayrLocalNotifications.cancelAll();
      setState(() {
        _statusMessage = 'All pending notifications cancelled! 🚫';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e ❌';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MayR Local Notifications'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_active, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 20),
                const Text(
                  'MayR Local Notifications Demo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text('Running on: $_platformVersion', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _sendImmediateNotification,
                  icon: const Icon(Icons.send),
                  label: const Text('Send Immediate Notification'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _scheduleNotification,
                  icon: const Icon(Icons.schedule),
                  label: const Text('Schedule Notification (10s)'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _cancelAllNotifications,
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel All Notifications'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                ),
                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 20),
                const Text(
                  'Features:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  '✅ Zero configuration setup\n'
                  '✅ Immediate notifications\n'
                  '✅ Scheduled notifications\n'
                  '✅ Cancel all notifications\n'
                  '✅ Cross-platform (Android, iOS, macOS)',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
