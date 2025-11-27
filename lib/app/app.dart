import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/auth/auth_firebase_service_impl.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/data/repository/firebase_db_service_impl.dart';
import 'package:social_media_app/data/repository/image_service_impl.dart';
import 'package:social_media_app/data/repository/search_repository_impl.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';

class App extends StatelessWidget {
  const App({super.key});

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
          (searchContext) => SearchRepositoryImpl(
              dbService: searchContext.read<FirebaseDbServiceImpl>(),
          )
        ),
        RepositoryProvider(create:
            (_) => ImageServiceImpl()
        ),
      ],
      child: _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.light,
      // darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      //home: MainPage(),
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

