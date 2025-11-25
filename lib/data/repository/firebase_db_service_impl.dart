import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/firebase_db_service.dart';
import 'package:social_media_app/utils/result.dart';

class FirebaseDbServiceImpl implements FirebaseDbService {
  final firestore = FirebaseFirestore.instance;
  late final _usersRef = firestore.collection('users');

  @override
  Future<void> createUser(User user, UserModel userModel) async {
    await _usersRef.doc(user.uid).set({
      'id': user.uid,
      'username': '',
      'email': userModel.email,
      'creationTime': userModel.creationTimestamp,
      'bio': '',
      'photoUrl': '',
    });
  }

  @override
  Future<Result<UserEntity>> getUserById(String? id) async {
    try {
      var userRef = await _usersRef.doc(id).withConverter(
          fromFirestore: UserEntity.fromFirestore,
          toFirestore: (UserEntity userEntity, _) => userEntity.toFirestore(),
      );
      final docSnap = await userRef.get();
      final userEntity = docSnap.data();

      debugPrint('--- FirebaseDbService getUserById email${userEntity?.email}');

      return Result.ok(UserEntity(
        id: userEntity?.id,
        username: userEntity?.username,
        email: userEntity?.email,
        bio: userEntity?.bio,
        creationTimestamp: userEntity?.creationTimestamp,
        photoUrl: userEntity?.photoUrl,
      ));
    } on Exception catch(e) {
      debugPrint('--- FirebaseDbService getUserById exception ${e.toString()}');
      return Result.error(e);
    }
    
    // try {
    //   var user = await _usersRef.doc(id).get();
    //   debugPrint('--- FirebaseDbService getUserById exists ${user.data().toString()}');
    //   final bodyJson = jsonDecode(user.data().toString()) as Map<String, dynamic>;
    //
    //   //final bodyJson = jsonDecode('{ id: gXVdDyH8h2M8feurV6jf0hOvUTr1, email: a@mail.com }') as Map<String, dynamic>;
    //   var userModel = UserModel.fromJson(bodyJson);
    //
    //   debugPrint('--- FirebaseDbService getUserById email${userModel.email}');
    //
    //   return Result.ok(UserEntity(
    //       email: userModel.email,
    //   ));
    // } on Exception catch(e) {
    //   debugPrint('--- FirebaseDbService getUserById exception ${e.toString()}');
    //   return Result.error(e);
    // }
  }

}