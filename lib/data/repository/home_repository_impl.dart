import 'package:logging/logging.dart';
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
  Future<List<PostEntity>> getNewPosts({required String userId}) async {
    final posts = await _dbService.getNewPosts(userId: userId);

    switch (posts) {
      case Ok<List<PostEntity>>():
        _log.info('getNewPosts success');
        return posts.value;
      case Error<List<PostEntity>>():
        _log.warning('getNewPosts error: ${posts.error}');
        return [];
    }
  }
}
