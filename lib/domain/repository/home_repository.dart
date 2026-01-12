import 'package:social_media_app/domain/model/post_entity.dart';

abstract class HomeRepository {
  Future<List<PostEntity>> getNewPosts({required String userId});
}
