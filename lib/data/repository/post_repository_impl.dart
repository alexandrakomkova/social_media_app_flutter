import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/post_repository.dart';
import 'package:social_media_app/utils/result.dart';

final _log = Logger('PostRepositoryImpl');

class PostRepositoryImpl implements PostRepository {
  final DbService _dbService;

  const PostRepositoryImpl({required DbService dbService})
    : _dbService = dbService;

  @override
  Future<Map<String, int>> getLikesInfo({required String postId}) async {
    final res = await _dbService.getLikesInfo(postId: postId);

    switch (res) {
      case Ok<Map<String, int>>():
        return res.value;
      case Error<Map<String, int>>():
        _log.warning("${_log.name} getLikesInfo error: ${res.error}");
        return {'likesCount': 0, 'isLiked': 0};
    }
  }

  @override
  Future<void> addLike({
    required String postId,
    required String postOwnerId,
  }) async {
    final res = await _dbService.addLike(
      postId: postId,
      postOwnerId: postOwnerId,
    );
    switch (res) {
      case Ok<void>():
        return res.value;
      case Error<void>():
        return;
    }
  }

  @override
  Future<void> removeLike({required String postId}) async {
    final res = await _dbService.removeLike(postId: postId);
    switch (res) {
      case Ok<void>():
        return res.value;
      case Error<void>():
        return;
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required String commentText,
    required String postOwnerId,
  }) async {
    debugPrint('--- PostRepositoryImpl addComment postOwnerId $postOwnerId');

    final res = await _dbService.addComment(
      postId: postId,
      commentText: commentText,
      postOwnerId: postOwnerId,
    );
    switch (res) {
      case Ok<void>():
        return;
      case Error<void>():
        debugPrint('--- PostRepositoryImpl addComment ${res.error}');
        return;
    }
  }

  @override
  Future<List<CommentEntity>> getComments({required String postId}) async {
    final res = await _dbService.getComments(postId: postId);

    switch (res) {
      case Ok<List<CommentEntity>>():
        return res.value;
      case Error<List<CommentEntity>>():
        debugPrint(res.error.toString());
        return [];
    }
  }
}
