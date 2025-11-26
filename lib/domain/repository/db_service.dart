import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/utils/result.dart';

abstract class DbService {
  Future<void> createUser(User user, UserModel userModel);
  Future<Result<UserEntity>> getUserById(String? id);
  Future<Result<List<UserEntity>>> searchUserByUsername(String username);
}