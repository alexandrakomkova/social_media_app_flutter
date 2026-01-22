import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/app/app_bloc_observer.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/data/repository/auth/auth_firebase_service_impl.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/data/repository/firebase_db_service_impl.dart';
import 'package:social_media_app/data/repository/follow_repository_impl.dart';
import 'package:social_media_app/data/repository/home_repository_impl.dart';
import 'package:social_media_app/data/repository/image_service_impl.dart';
import 'package:social_media_app/data/repository/post_repository_impl.dart';
import 'package:social_media_app/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/data/repository/search_repository_impl.dart';
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/follow_repository.dart';
import 'package:social_media_app/domain/repository/home_repository.dart';
import 'package:social_media_app/domain/repository/image_service.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/domain/repository/post_repository.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/domain/repository/search_repository.dart';
import 'package:social_media_app/initialization/dependencies.dart';
import 'package:social_media_app/main.dart'
    show firebaseMessagingBackgroundHandler;
import 'package:social_media_app/utils/firebase_service.dart';
import 'package:social_media_app/utils/notification_handler.dart';

import '../data/repository/notification_repository_impl.dart';

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
      'Firebase services initialization':
          (
            dependencies,
            notificationHandler,
            flutterLocalNotificationsPlugin,
          ) async {
            final _ = await _initializeFirebase(
              notificationHandler,
              flutterLocalNotificationsPlugin,
            );

            final firebaseAuth = FirebaseAuth.instance;
            dependencies.firebaseAuth = firebaseAuth;
          },
      'Database initialization': (_, _, _) async {
        final _ = await DbProvider.db.initDb();
      },
      'SharedPreferences initialization': (dependencies, _, _) async {
        final sharedPrefs = await SharedPreferences.getInstance();
        dependencies.sharedPreferences = sharedPrefs;
      },
      'DbService initialization': (dependencies, _, _) {
        final DbService dbService = FirebaseDbServiceImpl();
        dependencies.dbService = dbService;
      },
      'ImageService initialization': (dependencies, _, _) {
        final ImageService imageService = ImageServiceImpl();
        dependencies.imageService = imageService;
      },
      'AuthFirebaseService initialization': (dependencies, _, _) {
        final AuthFirebaseService authFirebaseService = AuthFirebaseServiceImpl(
          firebaseAuth: dependencies.firebaseAuth,
        );
        dependencies.authFirebaseService = authFirebaseService;
      },
      'AuthRepository initialization': (dependencies, _, _) {
        final AuthRepository authRepository = AuthRepositoryImpl(
          authFirebaseService: dependencies.authFirebaseService,
          firebaseDbService: dependencies.dbService,
        );
        dependencies.authRepository = authRepository;
      },
      'HomeRepository initialization': (dependencies, _, _) {
        final HomeRepository homeRepository = HomeRepositoryImpl(
          dbService: dependencies.dbService,
        );
        dependencies.homeRepository = homeRepository;
      },
      'NotificationRepository initialization': (dependencies, _, _) {
        final NotificationRepository notificationRepository =
            NotificationRepositoryImpl(dbService: dependencies.dbService);
        dependencies.notificationRepository = notificationRepository;
      },
      'SearchRepository initialization': (dependencies, _, _) {
        final SearchRepository searchRepository = SearchRepositoryImpl(
          dbService: dependencies.dbService,
        );
        dependencies.searchRepository = searchRepository;
      },
      'ProfileRepository initialization': (dependencies, _, _) {
        final ProfileRepository profileRepository = ProfileRepositoryImpl(
          dbService: dependencies.dbService,
        );
        dependencies.profileRepository = profileRepository;
      },
      'PostRepository initialization': (dependencies, _, _) {
        final PostRepository postRepository = PostRepositoryImpl(
          dbService: dependencies.dbService,
        );
        dependencies.postRepository = postRepository;
      },
      'FollowRepository initialization': (dependencies, _, _) {
        final FollowRepository followRepository = FollowRepositoryImpl(
          dbService: dependencies.dbService,
        );
        dependencies.followRepository = followRepository;
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
