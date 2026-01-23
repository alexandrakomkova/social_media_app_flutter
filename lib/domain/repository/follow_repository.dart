import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';
import 'package:social_media_app/domain/model/user_entity.dart';

abstract class FollowRepository {
  Future<void> followUser({
    required String userId,
    required String userIdToFollow,
  });

  Future<void> unfollowUser({
    required String userId,
    required String userIdToUnfollow,
  });

  Future<PaginationResponse<UserEntity>> getFollowers({
    required String userId,
    DocumentSnapshot? lastDoc,
  });

  Future<PaginationResponse<UserEntity>> getFollowings({
    required String userId,
    DocumentSnapshot? lastDoc,
  });
}
