import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/home_repository.dart';
import 'package:social_media_app/domain/repository/image_service.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/domain/repository/post_repository.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/domain/repository/search_repository.dart';
import 'package:social_media_app/initialization/dependencies.dart';
import 'package:social_media_app/l10n/app_localizations.dart';
import 'package:social_media_app/l10n/language_provider.dart';
import 'package:social_media_app/presentation/cubit/internet_connectivity_cubit.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';
import 'package:social_media_app/presentation/widget/checking_internet_connection.dart';
import 'package:social_media_app/presentation/widget/no_internet_connection.dart';
import 'package:social_media_app/theme/theme.dart';
import 'package:social_media_app/theme/theme_provider.dart';

class App extends StatefulWidget {
  final Connectivity connectivity;
  final GlobalKey<NavigatorState> navigatorKey;

  const App({
    required this.connectivity,
    required this.navigatorKey,
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Dependencies dependencies = Dependencies.of(context);

    return MultiRepositoryProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ThemeProvider(sharedPreferences: dependencies.sharedPreferences),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(
            locale: Locale('en'),
            sharedPreferences: dependencies.sharedPreferences,
          ),
        ),
        RepositoryProvider<AuthFirebaseService>(
          create: (_) => dependencies.authFirebaseService,
        ),
        RepositoryProvider<DbService>(create: (_) => dependencies.dbService),
        RepositoryProvider<AuthRepository>(
          create: (_) => dependencies.authRepository,
        ),
        RepositoryProvider<HomeRepository>(
          create: (_) => dependencies.homeRepository,
        ),
        RepositoryProvider<NotificationRepository>(
          create: (_) => dependencies.notificationRepository,
        ),
        RepositoryProvider<SearchRepository>(
          create: (_) => dependencies.searchRepository,
        ),
        RepositoryProvider<ImageService>(
          create: (_) => dependencies.imageService,
        ),
        RepositoryProvider<ProfileRepository>(
          create: (_) => dependencies.profileRepository,
        ),
        RepositoryProvider<PostRepository>(
          create: (_) => dependencies.postRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) =>
            InternetConnectivityCubit(connectivity: widget.connectivity),
        child: _AppView(navigatorKey: widget.navigatorKey),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const _AppView({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder:
          (
            BuildContext context,
            ThemeProvider themeProvider,
            LanguageProvider languageProvider,
            Widget? child,
          ) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: languageProvider.locale,
              supportedLocales: [Locale('en'), Locale('ru')],
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              home: const _AppScreen(),
            );
          },
    );
  }
}

class _AppScreen extends StatelessWidget {
  const _AppScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetConnectivityCubit, InternetConnectivityState>(
      builder: (_, internetCubitState) {
        return switch (internetCubitState.status) {
          InternetStatus.loading => CheckingInternetConnection(),
          InternetStatus.disconnected => NoInternetConnection(),
          InternetStatus.connected => StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) return MainPage();

              return SignInPage();
            },
          ),
        };
      },
    );
  }
}
