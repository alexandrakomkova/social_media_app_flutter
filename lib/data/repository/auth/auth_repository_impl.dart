import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/utils/firebase_service.dart';
import 'package:social_media_app/utils/result.dart';

final _log = Logger('AuthRepositoryImpl');
class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseService _authFirebaseService;
  final DbService _dbService;

  AuthRepositoryImpl({
    required AuthFirebaseService authFirebaseService,
    required DbService firebaseDbService,
}): _authFirebaseService = authFirebaseService,
        _dbService = firebaseDbService;

  @override
  Future<Result<void>> signUp(UserModel userModel) async {
    final res =  await _authFirebaseService.signUp(userModel);

    switch(res) {
      case Ok<User>():
        await _dbService.createUser(user: res.value, userModel: userModel);
        return Result.ok(null);
      case Error<User>():
        _log.warning('signUp error: ${res.error}');
        return Result.error(res.error);
    }
  }

  @override
  Future<Result<void>> signIn(UserModel user) async {
    final userId = await _authFirebaseService.signIn(user);
    late UserEntity userEntity;

    switch(userId) {
      case Ok<String>():
        userEntity = UserEntity(
          id: userId.value,
          email: user.email,
          creationTimestamp: user.creationTimestamp,
        );
        await DbProvider.db.newUser(userEntity);
        _log.info('signIn success userId: ${userId.value}');
        return Result.ok(null);
      case Error<String>():
        _log.warning('signUp error: ${userId.error}');
        return Result.error(userId.error);
    }
  }

  @override
  Future<Result<void>> signInWithGoogle() async {
    final userCredential = await _authFirebaseService.signInWithGoogle();

    switch(userCredential) {
      case Ok<UserCredential>():
        _log.info('signInWithGoogle success userId: ${userCredential.value.user?.uid}');
        final user = userCredential.value.user!;

        if(userCredential.value.additionalUserInfo!.isNewUser) {
          await _dbService.createUser(
              user: user,
              userModel: UserModel(
                email: user.email ?? '',
                username: user.displayName ?? '',
                password: '',
                creationTimestamp: user.metadata.creationTime?.millisecondsSinceEpoch,
              )
          );
        }

        final userEntity = UserEntity(
          id: user.uid,
          username: user.displayName ?? '',
          email: user.email ?? '',
          creationTimestamp: user.metadata.creationTime?.millisecondsSinceEpoch,
        );
        await DbProvider.db.newUser(userEntity);

        return Result.ok(null);
      case Error<UserCredential>():
        _log.warning('signInWithGoogle error: ${userCredential.error}');
        return Result.error(userCredential.error);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    final res = await _authFirebaseService.signOut();
    switch (res) {
      case Ok<void>():
        await DbProvider.db.deleteUser(FirebaseService.currentUserId);
        _log.info('signOut success');
        return Result.ok(null);
      case Error<void>():
        _log.warning('signOut error: ${res.error}');
        return Result.error(res.error);
    }
  }
}