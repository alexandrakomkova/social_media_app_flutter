import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/data/model/user_model.dart';

abstract class FirebaseDbService {
  Future<void> createUser(User user, UserModel userModel);
}