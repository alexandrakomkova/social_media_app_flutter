import 'package:social_media_app/domain/model/user_entity.dart';

abstract class SearchRepository {
  Future<List<UserEntity>> searchUserByUsername({required String query});
}