import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/utils/result.dart';

abstract class NotificationRepository {
  Future<PaginationResponse<NotificationEntity>> getNotifications({
    required String userId,
    DocumentSnapshot<Object?>? lastDoc,
  });

  Future<void> deleteAll({required String userId});

  Future<Result<PostEntity?>> getUserPost({required String postId});
}
