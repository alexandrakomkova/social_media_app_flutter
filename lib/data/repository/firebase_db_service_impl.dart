
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/utils/firebase_utils.dart';
import 'package:social_media_app/utils/image_loader.dart';
import 'package:social_media_app/utils/result.dart';

class FirebaseDbServiceImpl implements DbService {
  final firestore = FirebaseFirestore.instance;
  late final _usersRef = firestore.collection('users');
  late final _postsRef = firestore.collection('posts');

  @override
  Future<void> createUser(User user, UserModel userModel) async {
    //debugPrint('FirebaseDbServiceImpl createUser ${userModel.username}');

    await _usersRef.doc(user.uid).set({
      'id': user.uid,
      'username': userModel.username,
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

      // return Result.ok(UserEntity(
      //   id: userEntity!.id,
      //   username: userEntity.username,
      //   email: userEntity.email,
      //   bio: userEntity.bio,
      //   creationTimestamp: userEntity.creationTimestamp,
      //   photoUrl: userEntity.photoUrl,
      // ));
      return Result.ok(userEntity ?? UserEntity());
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<UserEntity>>> searchUserByUsername(String username) async {
    List<UserEntity> foundUsers = [];

    try {
      await _usersRef.where('username', isGreaterThanOrEqualTo: username)
          .where("username", isLessThanOrEqualTo: "$username\uf7ff")
          .get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            // print('${docSnapshot.id} => ${docSnapshot.data()}');
            var data = docSnapshot.data();

            foundUsers.add(UserEntity(
              id: data['id'],
              username: data['username'],
              email: data['email'],
              bio: data['bio'],
              creationTimestamp: data['creationTimestamp'],
              photoUrl: data['photoUrl'],
            ));
          }
        }
      );
      return Result.ok(foundUsers);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> createPost(File image, String description) async {
    try {
      final int creationTimestamp = DateTime.now().millisecondsSinceEpoch;
      final String imageUrl = await ImageLoader.getImageUrl(image, creationTimestamp.toString());
      if(imageUrl.isEmpty) { return Result.error(Exception()); }

      await _postsRef.doc(creationTimestamp.toString()).set({
        'creationTimestamp': creationTimestamp,
        'description': description,
        'imageUrl': imageUrl,
        "userId": FirebaseUtils.currentUser,
      });

      debugPrint('loaded ${imageUrl}');

      return Result.ok('');
    } on Exception catch(e) {
      debugPrint('--- FirebaseDbServiceImpl createPost ${e.toString()}');
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<PostEntity>>> getUserPosts(String? id) async {
    List<PostEntity> posts = [];
    try {
      await _postsRef.where('userId', isEqualTo: id)
          .get().then(
              (querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              print('${docSnapshot.id} => ${docSnapshot.data()}');
              var data = docSnapshot.data();

              posts.add(PostEntity(
                userId: data['userId'],
                imageUrl: data['imageUrl'],
                description: data['description'],
                creationTimestamp: data['creationTimestamp']
              ));
            }
          }
      );

      return Result.ok(posts);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }
}