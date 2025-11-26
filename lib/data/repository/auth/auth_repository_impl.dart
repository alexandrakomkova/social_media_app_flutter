import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/firebase_db_service.dart';
import 'package:social_media_app/utils/result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseService _authFirebaseService;
  final FirebaseDbService _firebaseDbService;

  AuthRepositoryImpl({
    required AuthFirebaseService authFirebaseService,
    required FirebaseDbService firebaseDbService,
}): _authFirebaseService = authFirebaseService,
        _firebaseDbService = firebaseDbService;

  @override
  Future<void> signUp(UserModel userModel) async {
    debugPrint('AuthRepositoryImpl signUp ${userModel.email} ${userModel.password}');
    final res =  await _authFirebaseService.signUp(userModel);

    if(res is Ok<User>) {
      await _firebaseDbService.createUser(res.value, userModel);
    }
  }

  @override
  Future<Either> signIn(UserModel user) async {
    debugPrint('AuthRepositoryImpl signIn ${user.email} ${user.password}');
    return await _authFirebaseService.signIn(user);
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
        return res.value;
      case Error<String>():
        return res.error.toString();
    }
  }

  @override
  Future<UserEntity?> getUserInfo(String? id) async {
    debugPrint('id: $id userId: ${FirebaseAuth.instance.currentUser?.uid}');
    final res = await _firebaseDbService.getUserById(id ?? FirebaseAuth.instance.currentUser?.uid);

    switch (res) {
      case Ok<UserEntity>():
        debugPrint('--- ${res.value.email}');
        return res.value;
      case Error<UserEntity>():
        debugPrint('--- exception');
        return null;
    }
  }
}