import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_media_app/firebase_options.dart';

class FirebaseService {
  static final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  //static String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  static Future<void> initialize({
    required FlutterLocalNotificationsPlugin localNotifications,
    required Future<void> Function(RemoteMessage) onBackgroundMessage,
    required InitializationSettings initializationSettings,
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
  }) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.requestPermission();
    await localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }
}