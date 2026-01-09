import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/utils/result.dart';

abstract class DbService {
  // user
  Future<void> createUser({required User user, required UserModel userModel});

  Future<Result<UserEntity>> getUserById({required String id});

  Future<Result<List<UserEntity>>> searchUserByUsername({
    required String username,
  });

  Future<Result<void>> updateUserInfo({
    required String imageUrl,
    required String username,
    required String bio,
  });

  // posts
  Future<Result<void>> createPost({
    required File? image,
    required String description,
  });

  Future<
    Result<({List<PostEntity> posts, DocumentSnapshot? lastDoc, bool hasMore})>
  >
  getUserPostsNext({required String userId, DocumentSnapshot? lastDoc});

  Future<Result<PostEntity?>> getUserPost({required String postId});

  // likes
  Future<Result<({int likesCount, bool isLiked})>> getLikesInfo({
    required String postId,
  });

  Future<Result<void>> addLike({
    required String postId,
    required String postOwnerId,
  });

  Future<Result<void>> removeLike({required String postId});

  //comments
  Future<Result<List<CommentEntity>>> getComments({required String postId});

  Future<Result<void>> addComment({
    required String postId,
    required String commentText,
    required String postOwnerId,
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

  Future<Result<List<UserEntity>>> getFollowers({required String userId});

  Future<Result<List<UserEntity>>> getFollowings({required String userId});

  Future<Result<bool>> isFollowedByCurrentUser({
    required String profileOwnerUserId,
  });

  //home
  Future<Result<List<PostEntity>>> getNewPosts({required String userId});

  // notifications
  Future<Result<List<NotificationEntity>>> getNotifications({
    required String userId,
  });

  Future<Result<void>> addNotification({
    String? postId,
    required String ownerId,
    required NotificationType type,
  });

  Future<Result<void>> deleteAllNotifications({required String userId});
}
