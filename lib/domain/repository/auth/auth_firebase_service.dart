import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/utils/result.dart';

abstract class AuthFirebaseService {
  Future<Result<String>> signIn(UserModel user);
  Future<Result<User>> signUp(UserModel user);
  Future<Result<String>> signOut();
}