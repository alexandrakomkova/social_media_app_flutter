import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/home_repository.dart';
import 'package:social_media_app/utils/result.dart';

final _log = Logger('HomeRepositoryImpl');

class HomeRepositoryImpl implements HomeRepository {
  final DbService _dbService;

  const HomeRepositoryImpl({required DbService dbService})
    : _dbService = dbService;

  @override
  Future<PaginationResponse<PostEntity>> getNewPosts({
    required String userId,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    final res = await _dbService.getNewPosts(userId: userId, lastDoc: lastDoc);

    switch (res) {
      case Ok<PaginationResponse<PostEntity>>():
        _log.info('getNewPosts success');
        return res.value;
      case Failure<PaginationResponse<PostEntity>>():
        _log.warning('getNewPosts error: ${res.error}');
        return PaginationResponse<PostEntity>(
          list: <PostEntity>[],
          lastDoc: null,
          hasMoreToLoad: false,
        );
    }
  }
}
