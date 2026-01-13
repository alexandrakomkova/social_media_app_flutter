import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/utils/result.dart';

final _log = Logger('AuthFirebaseServiceImpl');

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final FirebaseAuth _firebaseAuth;

  AuthFirebaseServiceImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<Result<String>> signIn(UserModel user) async {
    try {
      final res = await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      return res.user == null
          ? Result.error(Exception())
          : Result.ok(res.user!.uid);
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
      if (res.user != null) {
        return Result.ok(res.user!);
      } else {
        return Result.error(Exception('Cannot create user'));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UserCredential?>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _log.info('googleUser is null');
        return Result.ok(null);
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      if (userCredential.user == null) {
        _log.warning('Cannot register user with google');
        return Result.error(Exception('Cannot register user with google'));
      }

      _log.info('signInWithGoogle success: ${userCredential.credential}');

      return Result.ok(userCredential);
    } on FirebaseAuthException catch (e) {
      _log.warning(e.toString());
      return Result.error(e);
    } on Exception catch (e) {
      _log.warning(e.toString());
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();

      return Result.ok(null);
    } on FirebaseAuthException catch (e) {
      return Result.error(e);
    }
  }
}
