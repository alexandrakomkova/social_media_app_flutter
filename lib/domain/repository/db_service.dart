import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/utils/result.dart';

abstract class DbService {
  // user
  Future<void> createUser(User user, UserModel userModel);
  Future<Result<UserEntity>> getUserById(String? id);
  Future<Result<List<UserEntity>>> searchUserByUsername(String username);
  Future<Result<void>> updateUserInfo(String imageUrl, String username, String bio);

  // posts
  Future<Result<void>> createPost(File image, String description);
  Future<Result<List<PostEntity>>> getUserPosts(String? id);

  // likes
  Future<Result<int>> getLikesCount(String postId);
  Future<Result<void>> addLike(String postId);
  Future<Result<void>> removeLike(String postId);

  //comments
  Future<Result<List<CommentEntity>>> getComments({required String postId});
  Future<Result<void>> addComment({required String postId, required String commentText});

  // followers and followings
  Future<void> followUser({required String userId, required String userIdToFollow});
  Future<void> unfollowUser({required String userId, required String userIdToUnfollow});
  Future<Result<List<UserEntity>>> getFollowers(String? userId);
  Future<Result<List<UserEntity>>> getFollowings(String? userId);

  //home
  Future<Result<List<PostEntity>>> getNewPosts({String? userId});
}