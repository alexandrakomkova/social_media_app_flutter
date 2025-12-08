import 'package:social_media_app/domain/model/user_entity.dart';

class CommentEntity {
  String commentText;
  int createdAt = DateTime.now().millisecondsSinceEpoch;
  String postId;
  UserEntity userEntity;

  CommentEntity({
    required this.postId,
    required this.commentText,
    required this.createdAt,
    required this.userEntity,
  });
}