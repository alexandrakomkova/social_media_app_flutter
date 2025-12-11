import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/utils/result.dart';

final _log = Logger('NotificationRepositoryImpl');
class NotificationRepositoryImpl implements NotificationRepository {
  final DbService _dbService;

  const NotificationRepositoryImpl({
    required DbService dbService,
  }): _dbService = dbService;

  @override
  Future<List<NotificationEntity>> getNotifications({required String userId}) async {
    final notifications = await _dbService.getNotifications(userId: userId);

    switch(notifications) {
      case Ok<List<NotificationEntity>>():
        _log.info('getNotifications success');
        return notifications.value;
      case Error<List<NotificationEntity>>():
        _log.warning('getNotifications error: ${notifications.error}');
        return [];
    }
  }

  @override
  Future<void> deleteAll({required String userId}) async {
    final res = await _dbService.deleteAllNotifications(userId: userId);

    switch(res) {
      case Ok<void>():
        return;
      case Error<void>():
        _log.warning('deleteAll error: ${res.error}');
        return;
    }
  }
}