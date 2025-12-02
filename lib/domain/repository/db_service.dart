import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/utils/result.dart';

abstract class DbService {
  Future<void> createUser(User user, UserModel userModel);
  Future<Result<UserEntity>> getUserById(String? id);
  Future<Result<List<UserEntity>>> searchUserByUsername(String username);
  Future<Result<void>> createPost(File image, String description);
  Future<Result<List<PostEntity>>> getUserPosts(String? id);
  Future<Result<void>> updateUserInfo(String imageUrl, String username, String bio);
  Future<Result<int>> getLikesCount(String postId);
  Future<Result<void>> addLike(String postId);
  Future<Result<void>> removeLike(String postId);
}