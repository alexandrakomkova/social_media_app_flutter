import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:social_media_app/l10n/app_localizations.dart';
import 'package:social_media_app/l10n/language_provider.dart';
import 'package:social_media_app/main.dart';
import 'package:social_media_app/presentation/cubit/internet_connectivity__cubit.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';
import 'package:social_media_app/presentation/widget/checking_internet_connection.dart';
import 'package:social_media_app/presentation/widget/no_internet_connection.dart';
import 'package:social_media_app/theme/theme.dart';
import 'package:social_media_app/theme/theme_provider.dart';
import 'package:social_media_app/utils/notification_handler.dart';

final _log = Logger('App widget');
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final notificationHandler = NotificationHandler(_log, navigatorKey);

class App extends StatefulWidget {
  final Connectivity connectivity;
  const App({
    required this.connectivity,
    super.key,
  });

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
      notificationHandler.handleMessageData(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        notificationHandler.handleMessageData(message.data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(Locale('en'))
        ),
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
      child:  BlocProvider(
          create: (_) =>
        InternetConnectivityCubit(connectivity: widget.connectivity),
        child: const _AppView(),
      )
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (
          context,
          ThemeProvider themeProvider,
          Widget? child,
      ) {
        return Consumer<LanguageProvider>(
          builder: (
            context,
            LanguageProvider languageProvider,
            Widget? child,
          ) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: languageProvider.locale,
              supportedLocales: [
                Locale('en'),
                Locale('ru'),
              ],
              theme: themeProvider.isDarkMode ? SocialMediaTheme.darkTheme : SocialMediaTheme.lightTheme,
              home: const _AppScreen(),
            );
          }
        );
      }
    );
  }
}

class _AppScreen extends StatelessWidget {
  const _AppScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetConnectivityCubit, InternetConnectivityState>(
      builder: (_, internetCubitState) {
        return switch(internetCubitState.status) {
          InternetStatus.loading => CheckingInternetConnection(),
          InternetStatus.disconnected => NoInternetConnection(),
          InternetStatus.connected => StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return MainPage();
              } else {
                return SignInPage();
              }
            }),
          ),
        };
      },
    );
  }
}


