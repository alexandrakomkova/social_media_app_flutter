
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';

abstract class ProfileRepository {
  // user
  Future<List<PostEntity>> getUserPosts({required String userId});
  Future<UserEntity?> getUserInfo({required String userId});
  Future<void> updateUserInfo({
    required String imageUrl,
    required String username,
    required String bio,
  });

  // followers and followings
  Future<void> followUser({
    required String userId,
    required String userIdToFollow,
  });
  Future<void> unfollowUser({
    required String userId,
    required String userIdToUnfollow,
  });
  Future<List<UserEntity>> getFollowers({required String userId});
  Future<List<UserEntity>> getFollowings({required String userId});
  Future<bool> isFollowedByCurrentUser({required String profileOwnerUserId});
}