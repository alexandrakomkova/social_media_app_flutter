import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show BuildContext, Widget, Key;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/home_repository.dart';
import 'package:social_media_app/domain/repository/image_service.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/domain/repository/post_repository.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/domain/repository/search_repository.dart';
import 'package:social_media_app/initialization/inherited_dependencies.dart';

class Dependencies {
  Dependencies();

  factory Dependencies.of(BuildContext context) =>
      InheritedDependencies.of(context);

  Widget inject({required Widget child, Key? key}) =>
      InheritedDependencies(dependencies: this, key: key, child: child);

  late final SharedPreferences sharedPreferences;
  late final DbService dbService;

  late final FirebaseAuth firebaseAuth;
  late final AuthFirebaseService authFirebaseService;

  late final ImageService imageService;

  late final AuthRepository authRepository;
  late final HomeRepository homeRepository;
  late final NotificationRepository notificationRepository;
  late final SearchRepository searchRepository;
  late final ProfileRepository profileRepository;
  late final PostRepository postRepository;
}
