import 'package:logging/logging.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/utils/firebase_service.dart';
import 'package:social_media_app/utils/result.dart';

final _log = Logger('ProfileRepositoryImpl');

class ProfileRepositoryImpl implements ProfileRepository {
  final DbService _dbService;

  ProfileRepositoryImpl({required DbService dbService})
    : _dbService = dbService;

  @override
  Future<List<PostEntity>> getUserPosts({required String userId}) async {
    final res = await _dbService.getUserPosts(userId: userId);

    switch (res) {
      case Ok<List<PostEntity>>():
        return res.value;
      case Failure<List<PostEntity>>():
        _log.warning('getUserPosts error: ${res.error}');
        return [];
    }
  }

  @override
  Future<UserEntity?> getUserInfo({required String userId}) async {
    final res = await _dbService.getUserById(id: userId);

    switch (res) {
      case Ok<UserEntity>():
        _log.info(
          'getUserInfo success userInfo: ${res.value.id} ${res.value.username}',
        );
        await DbProvider.db.updateUser(res.value);
        return res.value;
      case Failure<UserEntity>():
        _log.warning('getUserInfo error: ${res.error}');
        return null;
    }
  }

  @override
  Future<void> updateUserInfo({
    required String imageUrl,
    required String username,
    required String bio,
  }) async {
    final res = await _dbService.updateUserInfo(
      imageUrl: imageUrl,
      username: username,
      bio: bio,
    );
    switch (res) {
      case Ok<void>():
        var user = await DbProvider.db.getClient(FirebaseService.currentUserId);

        await DbProvider.db.updateUser(
          user.copyWith(username: username, bio: bio, photoUrl: imageUrl),
        );
        _log.info('updateUserInfo success');
        return;
      case Failure<void>():
        _log.warning('updateUserInfo error: ${res.error}');
        return;
    }
  }

  @override
  Future<void> followUser({
    required String userId,
    required String userIdToFollow,
  }) async {
    await _dbService.followUser(userId: userId, userIdToFollow: userIdToFollow);
  }

  @override
  Future<void> unfollowUser({
    required String userId,
    required String userIdToUnfollow,
  }) async {
    await _dbService.unfollowUser(
      userId: userId,
      userIdToUnfollow: userIdToUnfollow,
    );
  }

  @override
  Future<List<UserEntity>> getFollowers({required String userId}) async {
    final res = await _dbService.getFollowers(userId: userId);

    switch (res) {
      case Ok<List<UserEntity>>():
        _log.info(
          'getFollowers success followerList length ${res.value.length}',
        );
        return res.value;
      case Failure<List<UserEntity>>():
        _log.warning('getFollowers error: ${res.error}');
        return [];
    }
  }

  @override
  Future<List<UserEntity>> getFollowings({required String userId}) async {
    final res = await _dbService.getFollowings(userId: userId);

    switch (res) {
      case Ok<List<UserEntity>>():
        return res.value;
      case Failure<List<UserEntity>>():
        _log.warning('getFollowings error: ${res.error}');
        return [];
    }
  }

  @override
  Future<bool> isFollowedByCurrentUser({
    required String profileOwnerUserId,
  }) async {
    final res = await _dbService.isFollowedByCurrentUser(
      profileOwnerUserId: profileOwnerUserId,
    );

    switch (res) {
      case Ok<bool>():
        _log.info('isFollowedByCurrentUser ${res.value}');
        return res.value;
      case Failure<bool>():
        _log.warning('isFollowedByCurrentUser error: ${res.error}');
        return false;
    }
  }
}
