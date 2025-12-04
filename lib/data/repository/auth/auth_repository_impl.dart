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
  Future<void> signUp(UserModel userModel) async {
    //debugPrint('AuthRepositoryImpl signUp ${userModel.username}');
    final res =  await _authFirebaseService.signUp(userModel);

    if(res is Ok<User>) {
      //debugPrint('AuthRepositoryImpl signUp res is Ok');
      await _dbService.createUser(res.value, userModel);
    }
  }

  @override
  Future<void> signIn(UserModel user) async {
    //debugPrint('AuthRepositoryImpl signIn ${user.email} ${user.password}');
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
      case Error<String>():
        debugPrint('AuthRepositoryImpl signIn error ${userId.error}');
        userEntity = UserEntity(
          email: user.email,
          creationTimestamp: user.creationTimestamp,
        );
    }
    await DbProvider.db.newUser(userEntity);

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
        await DbProvider.db.deleteUser(FirebaseUtils.currentUser);
        return res.value;
      case Error<String>():
        return res.error.toString();
    }

  }
}