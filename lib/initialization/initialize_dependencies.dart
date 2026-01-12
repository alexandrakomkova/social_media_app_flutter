import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/app/app_bloc_observer.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/initialization/dependencies.dart';
import 'package:social_media_app/main.dart'
    show firebaseMessagingBackgroundHandler;
import 'package:social_media_app/utils/firebase_service.dart';
import 'package:social_media_app/utils/notification_handler.dart';

final _log = Logger('initializeDependencies');

Future<Dependencies> $initializeDependencies({
  required NotificationHandler notificationHandler,
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
}) async {
  final Dependencies dependencies = Dependencies();
  final int totalSteps = _initializationSteps.length;
  var currentStep = 0;

  for (final step in _initializationSteps.entries) {
    try {
      currentStep++;

      final message =
          '${step.key} | ${currentStep.toString().padLeft(2, '0')}/${totalSteps.toString().padLeft(2, '0')}';
      _log.info(message);

      await step.value(
        dependencies,
        notificationHandler,
        flutterLocalNotificationsPlugin,
      );
    } on Object catch (e) {
      _log.warning('initialization failed at step ${step.key} : $e');
    }
  }

  return dependencies;
}

typedef _InitializationStep =
    FutureOr<void> Function(
      Dependencies dependencies,
      NotificationHandler notificationHandler,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    );

final Map<String, _InitializationStep> _initializationSteps =
    <String, _InitializationStep>{
      'Observer state management': (_, _, _) =>
          Bloc.observer = const AppBlocObserver(),
      'Dotenv initialization': (dependencies, _, _) async {
        final _ = await dotenv.load(fileName: ".env");
      },
      'Firebase services initialization':
          (_, notificationHandler, flutterLocalNotificationsPlugin) async =>
              _initializeFirebase(
                notificationHandler,
                flutterLocalNotificationsPlugin,
              ),
      'Database initialization': (_, _, _) async {
        final _ = await DbProvider.db.initDb();
      },
      'SharedPreferences initialization': (dependencies, _, _) async {
        final sharedPrefs = await SharedPreferences.getInstance();
        dependencies.sharedPreferences = sharedPrefs;
      },
    };

Future<void> _initializeFirebase(
  NotificationHandler notificationHandler,
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: darwinInitializationSettings,
  );

  final _ = await FirebaseService.initialize(
    localNotifications: flutterLocalNotificationsPlugin,
    onBackgroundMessage: firebaseMessagingBackgroundHandler,
    initializationSettings: initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        final data = jsonDecode(response.payload!);
        notificationHandler.handleMessageData(data);
      }
    },
  );

  _requestPermission();
  _firebaseMessagingSetup(
    notificationHandler: notificationHandler,
    flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
  );
}

void _requestPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(alert: true, badge: true, sound: true);

  _log.info('User granted permission: ${settings.authorizationStatus}');
}

void _firebaseMessagingSetup({
  required NotificationHandler notificationHandler,
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
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
