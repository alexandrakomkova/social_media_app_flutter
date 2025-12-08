import 'package:social_media_app/domain/model/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications({required String userId});
  Future<void> addNotification({String? postId, required NotificationType type});
}