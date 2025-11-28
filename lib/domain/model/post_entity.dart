import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
  String userId;
  String description;
  String imageUrl;
  int? creationTimestamp;

  PostEntity({
    this.userId = '',
    this.imageUrl = '',
    this.description = '',
    this.creationTimestamp = 0,
  });

  factory PostEntity.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return PostEntity(
      userId: data?['userId'],
      description: data?['description'],
      imageUrl: data?['image'],
      creationTimestamp: data?['creationTimestamp'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "description": description,
      "creationTimestamp": creationTimestamp,
      "image": imageUrl,
      "userId": userId,
    };
  }
}