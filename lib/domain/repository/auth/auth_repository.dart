import 'package:dartz/dartz.dart';
import 'package:social_media_app/data/model/user_model.dart';

abstract class AuthRepository {
  Future<Either> signIn(UserModel user);
  Future<void> signUp(UserModel user);
  Future<String> signOut();

  Future<Either> signInWithGoogle();
}