import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/app/app.dart';
import 'package:social_media_app/app/app_error.dart';
import 'package:social_media_app/initialization/initialization.dart'
    as initialization;
import 'package:social_media_app/utils/notification_handler.dart';

final _log = Logger('Main');
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
        '${record.level.name}: ${record.time}: ${record.loggerName} ${record.message}',
      );
    }
  });

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final notificationHandler = NotificationHandler(_log, navigatorKey);

  initialization.$initializeApp(
    onSuccess: (dependencies) async => runApp(
      dependencies.inject(
        child: App(connectivity: Connectivity(), navigatorKey: navigatorKey),
      ),
    ),
    onError: (error) async => runApp(AppError(error: error)),
    notificationHandler: notificationHandler,
    flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
  );
}
