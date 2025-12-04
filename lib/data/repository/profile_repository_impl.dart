
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
    final res = await _dbService.getUserPosts(userId ?? FirebaseUtils.currentUserId);

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
    final res = await _dbService.getUserById(id ?? FirebaseUtils.currentUserId);

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
    required String imageUrl,
    required String username,
    required String bio,
  }) async {
    debugPrint('--- ProfileRepositoryImpl updateUserInfo');
    final res = await _dbService.updateUserInfo(imageUrl, username, bio);
    switch (res) {
      case Ok<void>():
        debugPrint('--- success');
        var user = await DbProvider.db.getClient(FirebaseUtils.currentUserId);

        await DbProvider.db.updateUser(user.copyWith(
          username: username,
          bio: bio,
          photoUrl: imageUrl
        ));
        return;
      case Error<void>():
        debugPrint('--- exception');
        return;
    }
  }

  @override
  Future<void> followUser({required String userId, required String userIdToFollow}) async {
    await _dbService.followUser(userId: userId, userIdToFollow: userIdToFollow);
  }

  @override
  Future<void> unfollowUser({required String userId, required String userIdToUnfollow}) async {
    await _dbService.unfollowUser(userId: userId, userIdToUnfollow: userIdToUnfollow);
  }

  @override
  Future<List<UserEntity>> getFollowers(String? userId) async {
    final res = await _dbService.getFollowers(userId);

    switch(res) {
      case Ok<List<UserEntity>>():
        return res.value;
      case Error<List<UserEntity>>():
        debugPrint(res.error.toString());
        return [];
    }
  }

  @override
  Future<List<UserEntity>> getFollowings(String? userId) async {
    final res = await _dbService.getFollowings(userId);

    switch(res) {
      case Ok<List<UserEntity>>():
        return res.value;
      case Error<List<UserEntity>>():
        debugPrint(res.error.toString());
        return [];
    }
  }
}