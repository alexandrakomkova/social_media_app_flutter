import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/utils/result.dart';

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Result<String>> signIn(UserModel user) async {
    try {
      final res = await _firebaseAuth.signInWithEmailAndPassword(
          email: user.email,
          password: user.password,
      );

      return res.user == null ? Result.error(Exception()) : Result.ok(res.user!.uid);
    } on FirebaseAuthException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<User>> signUp(UserModel user) async {
    try {
      final res = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      if(res.user != null) {
        return Result.ok(res.user!);
      } else {
        return Result.error(Exception('Cannot create user'));
      }
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<String>> signOut() async {
    try {
      await _firebaseAuth.signOut();

      return Result.ok('You successfully logout');
    } on FirebaseAuthException catch(e) {
      return Result.error(e);
    }
  }
}