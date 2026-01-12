import 'package:social_media_app/domain/model/comment_entity.dart';

abstract class CommentRepository {
  Future<List<CommentEntity>> getComments({required String postId});

  Future<void> addComment({
    required String postId,
    required String commentText,
    required String postOwnerId,
  });
}
