import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await _fcm.requestPermission();

    // Get the FCM token
    String? token = await _fcm.getToken();
    debugPrint("🔐 FCM Token: $token");

    // TODO: Send this token to backend to register authority device

    // Initialize local notification plugin (for displaying notification)
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _localNotificationsPlugin.initialize(initSettings);

    // Foreground message handling
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'High Importance Notifications',
              importance: Importance.high,
              priority: Priority.high,
              showWhen: true,
            ),
          ),
        );
      }
    });

    // Handle app opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("📲 App opened via notification");
      // Handle navigation or logic here
    });
  }
}
