import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  DateTime get creationTimestampDateTime => DateTime.fromMillisecondsSinceEpoch(creationTimestamp ?? 0);
  String get formattedCreationTimestamp => DateFormat('dd/MM/yyyy HH:mm').format(creationTimestampDateTime);
  int get id => creationTimestamp ?? 0;

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