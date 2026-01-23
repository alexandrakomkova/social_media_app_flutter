import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';

abstract class CommentRepository {
  Future<PaginationResponse<CommentEntity>> getComments({
    required String postId,
    DocumentSnapshot<Object?>? lastDoc,
  });

  Future<int> getCommentsCount({required String postId});

  Future<void> addComment({
    required String postId,
    required String commentText,
    required String postOwnerId,
  });
}
