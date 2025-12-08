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

  // factory CommentEntity.fromFirestore(
  //     DocumentSnapshot<Map<String, dynamic>> snapshot,
  //     SnapshotOptions? options,
  //     ) {
  //   final data = snapshot.data();
  //   return CommentEntity(
  //     userId: data?['userId'],
  //     username: data?['username'],
  //     userImageUrl: data?['userImageUrl'],
  //     postId: data?['postId'],
  //     commentText: data?['commentText'],
  //     createdAt: data?['createdAt'],
  //   );
  // }
  //
  // Map<String, dynamic> toFirestore() {
  //   return {
  //     'userId': userId,
  //     'username': username,
  //     'userImageUrl': userImageUrl,
  //     'postId': postId,
  //     'commentText': commentText,
  //     'createdAt': createdAt,
  //   };
  // }
}