import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/utils/result.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications({required String userId});
  Future<void> deleteAll({required String userId});
  Future<Result<PostEntity?>> getUserPost({required String postId});
}