import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:social_media_app/app/app.dart';
import 'package:social_media_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('--- fcmToken $fcmToken');

  await FirebaseMessaging.instance.requestPermission();

  await dotenv.load(fileName: ".env");

  runApp(const App());
}
