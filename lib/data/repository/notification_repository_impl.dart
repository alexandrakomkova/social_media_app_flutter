import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/utils/firebase_utils.dart';
import 'package:social_media_app/utils/result.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final DbService _dbService;

  const NotificationRepositoryImpl({
    required DbService dbService,
  }): _dbService = dbService;

  @override
  Future<void> addNotification({
    String? postId,
    required NotificationType type,
}) async {
    final res = await _dbService.addNotification(postId: postId, type: type, ownerId: FirebaseUtils.currentUserId);

    switch(res) {
      case Ok<void>():
        return;
      case Error<void>():
        return;
    }
  }

  @override
  Future<List<NotificationEntity>> getNotifications({required String userId}) async {
    final notifications = await _dbService.getNotifications(userId: userId);

    switch(notifications) {
      case Ok<List<NotificationEntity>>():
        return notifications.value;
      case Error<List<NotificationEntity>>():
        return [];
    }
  }

}