import 'package:dartz/dartz.dart';
import 'package:social_media_app/data/model/user_model.dart';


abstract class AuthFirebaseService {
  Future<Either> signIn(UserModel user);
  Future<Either> signUp(UserModel user);
  Future<Either> signOut();
}