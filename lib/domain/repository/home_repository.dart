import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';
import 'package:social_media_app/domain/model/post_entity.dart';

abstract class HomeRepository {
  Future<PaginationResponse<PostEntity>> getNewPosts({
    required String userId,
    DocumentSnapshot<Object?>? lastDoc,
  });
}
