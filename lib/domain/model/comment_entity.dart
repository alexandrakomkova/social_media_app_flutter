import 'package:social_media_app/domain/model/user_entity.dart';

class CommentEntity {
  CommentEntity({
    required this.postId,
    required this.text,
    int? createdAt,
    required this.author,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  final String postId;
  final String text;
  final int createdAt;
  final UserEntity author;

  DateTime get createdAtDateTime =>
      DateTime.fromMillisecondsSinceEpoch(createdAt);
}
