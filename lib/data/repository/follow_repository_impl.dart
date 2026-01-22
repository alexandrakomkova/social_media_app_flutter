import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/follow_repository.dart';
import 'package:social_media_app/utils/result.dart';

final _log = Logger('FollowRepositoryImpl');

class FollowRepositoryImpl implements FollowRepository {
  final DbService _dbService;

  FollowRepositoryImpl({required DbService dbService}) : _dbService = dbService;

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
  Future<PaginationResponse<UserEntity>> getFollowers({
    required String userId,
    DocumentSnapshot? lastDoc,
  }) async {
    final res = await _dbService.getFollowers(userId: userId, lastDoc: lastDoc);

    switch (res) {
      case Ok<PaginationResponse<UserEntity>>():
        _log.info(
          'getFollowers success followerList length ${res.value.list.length}',
        );
        return res.value;
      case Failure<PaginationResponse<UserEntity>>():
        _log.warning('getFollowers error: ${res.error}');
        return PaginationResponse<UserEntity>(
          list: <UserEntity>[],
          lastDoc: null,
          hasMoreToLoad: false,
        );
    }
  }

  @override
  Future<PaginationResponse<UserEntity>> getFollowings({
    required String userId,
    DocumentSnapshot? lastDoc,
  }) async {
    final res = await _dbService.getFollowings(
      userId: userId,
      lastDoc: lastDoc,
    );

    switch (res) {
      case Ok<PaginationResponse<UserEntity>>():
        return res.value;
      case Failure<PaginationResponse<UserEntity>>():
        _log.warning('getFollowings error: ${res.error}');
        return PaginationResponse<UserEntity>(
          list: <UserEntity>[],
          lastDoc: null,
          hasMoreToLoad: false,
        );
    }
  }
}
