import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/utils/firebase_utils.dart';
import 'package:social_media_app/utils/result.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DbService _dbService;

  ProfileRepositoryImpl({
    required DbService dbService,
  }): _dbService = dbService;

  @override
  Future<List<PostEntity>> getUserPosts(String? userId) async {
    final res = await _dbService.getUserPosts(userId ?? FirebaseUtils.currentUser);

    switch(res) {
      case Ok<List<PostEntity>>():
        return res.value;
      case Error<List<PostEntity>>():
        debugPrint(res.error.toString());
        return [];
    }
  }

  @override
  Future<UserEntity?> getUserInfo(String? id) async {
    //debugPrint('id: $id userId: ${FirebaseAuth.instance.currentUser?.uid}');
    final res = await _dbService.getUserById(id ?? FirebaseUtils.currentUser);

    switch (res) {
      case Ok<UserEntity>():
      debugPrint('--- ${res.value}');
        await DbProvider.db.updateUser(res.value);
        return res.value;
      case Error<UserEntity>():
      //debugPrint('--- exception');
        return null;
    }

  }

  @override
  Future<void> updateUserInfo({
    required File image,
    required String username,
    required String bio,
  }) async {
    debugPrint('--- ProfileRepositoryImpl updateUserInfo');
    final res = await _dbService.updateUserInfo(image, username, bio);
    switch (res) {
      case Ok<void>():
        debugPrint('--- success');
        var user = await DbProvider.db.getClient(FirebaseUtils.currentUser);

        await DbProvider.db.updateUser(user.copyWith(
          username: username,
          bio: bio
        ));
        return;
      case Error<void>():
        debugPrint('--- exception');
        return;
    }
  }

}