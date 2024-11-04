import 'dart:io';

import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _FlutterLocalNotificationsPluginInitializer {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<FlutterLocalNotificationsPlugin> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {},
    );

    await _requestPermissions();

    return _flutterLocalNotificationsPlugin;
  }

  Future<void> _requestPermissions() async {
    // Request permissions based on the platform
    if (Platform.isIOS) {
      await _requestIosPermissions();
    } else if (Platform.isAndroid) {
      await _requestAndroidPermissions();
    }
  }

  Future<void> _requestIosPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _requestAndroidPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }
}

final flutterLocalNotificationsPluginProvider =
    FutureProvider<FlutterLocalNotificationsPlugin>((ref) async {
  try {
    final flutterLocalNotificationsPlugin =
        await _FlutterLocalNotificationsPluginInitializer().initialize();

    return flutterLocalNotificationsPlugin;
  } catch (e) {
    throw const EntityInitializationException();
  }
});
