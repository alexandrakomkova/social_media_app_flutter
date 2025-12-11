import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_media_app/data/repository/auth/auth_firebase_service_impl.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/data/repository/firebase_db_service_impl.dart';
import 'package:social_media_app/data/repository/home_repository_impl.dart';
import 'package:social_media_app/data/repository/image_service_impl.dart';
import 'package:social_media_app/data/repository/notification_repository_impl.dart';
import 'package:social_media_app/data/repository/post_repository_impl.dart';
import 'package:social_media_app/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/data/repository/search_repository_impl.dart';
import 'package:social_media_app/main.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';
import 'package:social_media_app/utils/theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus}');
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      debugPrint('--- _AppState initState notification $message');

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
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('User tapped on notification: ${message.notification?.body}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthFirebaseServiceImpl()),
        RepositoryProvider(create: (_) => FirebaseDbServiceImpl()),
        RepositoryProvider(create:
            (authRepositoryContext) => AuthRepositoryImpl(
                authFirebaseService:  authRepositoryContext.read<AuthFirebaseServiceImpl>(),
                firebaseDbService: authRepositoryContext.read<FirebaseDbServiceImpl>(),
            )
        ),
        RepositoryProvider(create:
            (homeContext) => HomeRepositoryImpl(
                dbService: homeContext.read<FirebaseDbServiceImpl>()
            )
        ),
        RepositoryProvider(create:
            (notificationContext) => NotificationRepositoryImpl(
              dbService: notificationContext.read<FirebaseDbServiceImpl>()
            )
        ),
        RepositoryProvider(create:
          (searchContext) => SearchRepositoryImpl(
              dbService: searchContext.read<FirebaseDbServiceImpl>(),
          )
        ),
        RepositoryProvider(create:
            (_) => ImageServiceImpl()
        ),
        RepositoryProvider(create:
            (profileContext) => ProfileRepositoryImpl(
              dbService: profileContext.read<FirebaseDbServiceImpl>(),
            ),
        ),
        RepositoryProvider(create:
          (postContext) => PostRepositoryImpl(
              dbService: postContext.read<FirebaseDbServiceImpl>()
          )
        ),
      ],
      child: const _AppView(
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: SocialMediaTheme.lightTheme,
      darkTheme: SocialMediaTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return MainPage();
          } else {
            return SignInPage();
          }
        }),
      ),
    );
  }
}

