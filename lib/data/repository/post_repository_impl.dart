import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';
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
    _log.info('addComment postOwnerId $postOwnerId');

    final res = await _dbService.addComment(
      postId: postId,
      commentText: commentText,
      postOwnerId: postOwnerId,
    );
    switch (res) {
      case Ok<void>():
        _log.info('addComment success');
        return;
      case Failure<void>():
        _log.warning('addComment ${res.error}');
        return;
    }
  }

  @override
  Future<PaginationResponse<CommentEntity>> getComments({
    required String postId,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    final res = await _dbService.getComments(postId: postId, lastDoc: lastDoc);

    switch (res) {
      case Ok<PaginationResponse<CommentEntity>>():
        _log.info('getComments success');
        return res.value;
      case Failure<PaginationResponse<CommentEntity>>():
        _log.warning('getComments error: ${res.error.toString()}');
        return PaginationResponse<CommentEntity>(
          list: <CommentEntity>[],
          lastDoc: null,
          hasMoreToLoad: false,
        );
    }
  }

  @override
  Future<int> getCommentsCount({required String postId}) async {
    final res = await _dbService.getCommentsCount(postId: postId);

    switch (res) {
      case Ok<int>():
        _log.info('getCommentsCount ${res.value}');
        return res.value;
      case Failure<int>():
        _log.warning('getCommentsCount error: ${res.error}');
        return 0;
    }
  }
}
