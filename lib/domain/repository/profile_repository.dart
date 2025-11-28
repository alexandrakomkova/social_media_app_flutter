import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';

abstract class ProfileRepository {
  Future<List<PostEntity>> getUserPosts(String? userId);
  Future<UserEntity?> getUserInfo(String? id);
}