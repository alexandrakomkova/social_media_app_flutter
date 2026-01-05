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
  Future<({int likesCount, bool isLiked})> getLikesInfo({
    required String postId,
  }) async {
    final res = await _dbService.getLikesInfo(postId: postId);

    switch (res) {
      case Ok<({int likesCount, bool isLiked})>():
        return res.value;
      case Failure<({int likesCount, bool isLiked})>():
        _log.warning("${_log.name} getLikesInfo error: ${res.error}");
        return (likesCount: 0, isLiked: false);
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
      case Failure<void>():
        return;
    }
  }

  @override
  Future<void> removeLike({required String postId}) async {
    final res = await _dbService.removeLike(postId: postId);
    switch (res) {
      case Ok<void>():
        return res.value;
      case Failure<void>():
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
      case Failure<void>():
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
      case Failure<List<CommentEntity>>():
        debugPrint(res.error.toString());
        return [];
    }
  }
}
