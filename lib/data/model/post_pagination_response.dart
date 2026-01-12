import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/domain/model/post_entity.dart';

class PostPaginationResponse {
  final bool hasMoreToLoad;
  final List<PostEntity> posts;
  final DocumentSnapshot? lastDoc;

  PostPaginationResponse({
    required this.hasMoreToLoad,
    required this.posts,
    required this.lastDoc,
  });

  PostPaginationResponse copyWith({
    bool? hasMoreToLoad,
    List<PostEntity>? posts,
    DocumentSnapshot? lastDoc,
  }) {
    return PostPaginationResponse(
      hasMoreToLoad: hasMoreToLoad ?? this.hasMoreToLoad,
      posts: posts ?? this.posts,
      lastDoc: lastDoc ?? this.lastDoc,
    );
  }
}
