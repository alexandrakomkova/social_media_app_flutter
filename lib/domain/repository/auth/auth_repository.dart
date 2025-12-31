import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/utils/result.dart';

abstract class AuthRepository {
  Future<Result<void>> signIn(UserModel user);

  Future<Result<void>> signUp(UserModel user);

  Future<Result<void>> signOut();

  Future<Result<void>> signInWithGoogle();
}
