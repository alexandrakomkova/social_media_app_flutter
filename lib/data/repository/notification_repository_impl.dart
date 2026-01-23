import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/utils/result.dart';

final _log = Logger('NotificationRepositoryImpl');

class NotificationRepositoryImpl implements NotificationRepository {
  final DbService _dbService;

  const NotificationRepositoryImpl({required DbService dbService})
    : _dbService = dbService;

  @override
  Future<PaginationResponse<NotificationEntity>> getNotifications({
    required String userId,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    final res = await _dbService.getNotifications(
      userId: userId,
      lastDoc: lastDoc,
    );

    switch (res) {
      case Ok<PaginationResponse<NotificationEntity>>():
        _log.info('getNotifications success ${res.value.hasMoreToLoad}');
        return res.value;
      case Failure<PaginationResponse<NotificationEntity>>():
        _log.warning('getNotifications error: ${res.error}');
        return PaginationResponse<NotificationEntity>(
          list: <NotificationEntity>[],
          lastDoc: null,
          hasMoreToLoad: false,
        );
    }
  }

  @override
  Future<void> deleteAll({required String userId}) async {
    final res = await _dbService.deleteAllNotifications(userId: userId);

    switch (res) {
      case Ok<void>():
        return;
      case Failure<void>():
        _log.warning('deleteAll error: ${res.error}');
        return;
    }
  }

  @override
  Future<Result<PostEntity?>> getUserPost({required String postId}) async {
    final res = await _dbService.getUserPost(postId: postId);
    switch (res) {
      case Ok<PostEntity?>():
        if (res.value == null) {
          return Result.error(Exception('No post found'));
        } else {
          return Result.ok(res.value);
        }
      case Failure<PostEntity?>():
        _log.warning('deleteAll error: ${res.error}');
        return Result.error(res.error);
    }
  }
}
