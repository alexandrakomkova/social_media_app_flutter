import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/app/app.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/utils/firebase_service.dart';
import 'package:social_media_app/utils/notification_handler.dart';

final _log = Logger('Main');
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'background_channel_id',
        'Background Notifications',
        channelDescription: 'Channel for background notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  if (message.notification != null) {
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
        '${record.level.name}: ${record.time}: ${record.loggerName} ${record.message}',
      );
    }
  });

  await dotenv.load(fileName: ".env");

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: darwinInitializationSettings,
  );

  await DbProvider.db.initDB();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final notificationHandler = NotificationHandler(_log, navigatorKey);

  await FirebaseService.initialize(
    localNotifications: flutterLocalNotificationsPlugin,
    onBackgroundMessage: _firebaseMessagingBackgroundHandler,
    initializationSettings: initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        final data = jsonDecode(response.payload!);
        notificationHandler.handleMessageData(data);
      }
    },
  );

  _requestPermission();
  _firebaseMessagingSetup(notificationHandler: notificationHandler);

  runApp(App(connectivity: Connectivity(), navigatorKey: navigatorKey));
}

void _requestPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(alert: true, badge: true, sound: true);

  _log.info('User granted permission: ${settings.authorizationStatus}');
}

void _firebaseMessagingSetup({
  required NotificationHandler notificationHandler,
}) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'fireground_channel_id',
            'Foreground Notifications',
            channelDescription: 'Channel for foreground notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    notificationHandler.handleMessageData(message.data);
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      notificationHandler.handleMessageData(message.data);
    }
  });
}
