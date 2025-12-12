import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/data/repository/auth/auth_firebase_service_impl.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/data/repository/firebase_db_service_impl.dart';
import 'package:social_media_app/data/repository/home_repository_impl.dart';
import 'package:social_media_app/data/repository/image_service_impl.dart';
import 'package:social_media_app/data/repository/notification_repository_impl.dart';
import 'package:social_media_app/data/repository/post_repository_impl.dart';
import 'package:social_media_app/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/data/repository/search_repository_impl.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/main.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';
import 'package:social_media_app/presentation/pages/post/post_page.dart';
import 'package:social_media_app/presentation/pages/profile/profile_page.dart';
import 'package:social_media_app/theme/theme.dart';
import 'package:social_media_app/theme/theme_provider.dart';

final _log = Logger('App widget');
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

  _log.info('User granted permission: ${settings.authorizationStatus}');
}

void handleMessageData(Map<String, dynamic> data) {
  final type = data['type'];
  if (type == 'follow' || type == 'unfollow' && data['userId'] != null) {
    final userId = data['userId'];
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => ProfilePage(userId: userId)),
    );
    _log.info('$userId');
  } else if (type == 'comment' || type == 'like' && data['postEntity'] != null) {
    final postData = data['postEntity'];
    _log.info('${postData.toString()}');
    final userData = jsonDecode(postData['userEntity']);

    final postEntity = PostEntity(
      imageUrl: postData['imageUrl'],
      description: postData['description'],
      creationTimestamp: int.parse(postData['creationTimestamp']),
      userEntity: UserEntity(
        bio: userData['bio'],
        id: userData['id'],
        email: userData['email'],
        photoUrl: userData['photoUrl'],
        username: userData['username'],
        creationTimestamp:  int.parse(userData['creationTime'])
      )
    );
    _log.info('${postData['description']} ${userData['id']}');
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => PostPage(postEntity: postEntity,)),
    );
  }
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    requestPermission();

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
      // _log.info('User tapped on notification: ${message.notification?.body}');
      handleMessageData(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleMessageData(message.data);
      }
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
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(),
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
    return Consumer<ThemeProvider>(
      builder: (context, ThemeProvider themeProvider, Widget? child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkMode ? SocialMediaTheme.darkTheme : SocialMediaTheme.lightTheme,
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
    );
  }
}

