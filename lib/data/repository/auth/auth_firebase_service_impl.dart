import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/repository/auth/auth_firebase_service.dart';
import 'package:social_media_app/utils/result.dart';


class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Either> signIn(UserModel user) async {
    try {
      debugPrint('---------${user.email} ${user.password}');
      await _firebaseAuth.signInWithEmailAndPassword(
          email: user.email,
          password: user.password,
      );

      debugPrint('AuthFirebaseServiceImpl signIn success');
      return Right('You signed in successfully');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if(e.code == 'invalid-email') {
        message = 'Not user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user';
      } else { message = e.code; }
      debugPrint('AuthFirebaseServiceImpl signIn fail: $message');
      return Left(message);
    }
  }

  // @override
  // Future<Either<User, String>> signUp(UserModel user) async {
  //   try {
  //     debugPrint('---------${user.email} ${user.password}');
  //
  //     final res = await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: user.email,
  //         password: user.password,
  //     );
  //     debugPrint('AuthFirebaseServiceImpl signUp success');
  //     return Right(res.user); //Right('You signed up successfully');
  //   } on FirebaseAuthException catch(e) {
  //     String message = '';
  //
  //     if (e.code == 'weak-password') {
  //       message = 'The password provided is too weak.';
  //     } else if (e.code == 'email-already-in-use') {
  //       message = 'An account already exists with that email.';
  //     } else { message = e.code; }
  //
  //     debugPrint('AuthFirebaseServiceImpl signUp fail: $e');
  //     return Either.r
  //   }
  // }

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