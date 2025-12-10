import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/utils/firebase_utils.dart';
import 'package:social_media_app/utils/result.dart';

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
    //debugPrint('AuthRepositoryImpl signUp ${userModel.username}');
    final res =  await _authFirebaseService.signUp(userModel);

    switch(res) {
      case Ok<User>():
        await _dbService.createUser(res.value, userModel);
        return Result.ok(null);
      case Error<User>():
        return Result.error(res.error);
    }
  }

  @override
  Future<Result<void>> signIn(UserModel user) async {
    final userId = await _authFirebaseService.signIn(user);
    late UserEntity userEntity;

    switch(userId) {
      case Ok<String>():

        debugPrint('AuthRepositoryImpl signIn ${userId.value}');
        userEntity = UserEntity(
          id: userId.value,
          email: user.email,
          creationTimestamp: user.creationTimestamp,
        );
        await DbProvider.db.newUser(userEntity);
        return Result.ok(null);
      case Error<String>():
        debugPrint('AuthRepositoryImpl signIn error ${userId.error}');
        userEntity = UserEntity(
          email: user.email,
          creationTimestamp: user.creationTimestamp,
        );
        await DbProvider.db.newUser(userEntity);
        return Result.error(userId.error);
    }
  }

  @override
  Future<Either> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<String> signOut() async {
    final res = await _authFirebaseService.signOut();
    switch (res) {
      case Ok<String>():
        await DbProvider.db.deleteUser(FirebaseUtils.currentUserId);
        return res.value;
      case Error<String>():
        return res.error.toString();
    }

  }
}