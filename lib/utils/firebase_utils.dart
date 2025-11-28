import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseUtils {

  static String get currentUser => FirebaseAuth.instance.currentUser!.uid;

}