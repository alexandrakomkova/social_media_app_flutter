import 'package:cloud_firestore/cloud_firestore.dart';

class CommentEntity {
  String userId;
  String commentText;
  String createdAt = DateTime.now().millisecondsSinceEpoch.toString();
  String postId;
  String userImageUrl;
  String username;

  CommentEntity({
    required this.postId,
    required this.userId,
    required this.commentText,
    required this.createdAt,
    required this.username,
    this.userImageUrl = '',
  });

  factory CommentEntity.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return CommentEntity(
      userId: data?['userId'],
      username: data?['username'],
      userImageUrl: data?['userImageUrl'],
      postId: data?['postId'],
      commentText: data?['commentText'],
      createdAt: data?['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'username': username,
      'userImageUrl': userImageUrl,
      'postId': postId,
      'commentText': commentText,
      'createdAt': createdAt,
    };
  }
}