import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/data/repository/auth/auth_firebase_service_impl.dart';
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthFirebaseService _authFirebaseService;

  AuthRepositoryImpl({
    required AuthFirebaseService authFirebaseService,
}): _authFirebaseService = authFirebaseService;

  @override
  Future<Either> signUp(UserModel user) async {
    debugPrint('AuthRepositoryImpl signUp ${user.email} ${user.password}');
    return await _authFirebaseService.signUp(user);
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
  Future<Either> signOut() async {
    return await _authFirebaseService.signOut();
  }
}