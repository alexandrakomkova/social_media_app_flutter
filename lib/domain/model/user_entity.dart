import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  String? id;
  String? email;
  String? username;
  int? creationTimestamp;
  String? bio;
  String? photoUrl;

  UserEntity({
    this.email,
    this.creationTimestamp,
    this.username,
    this.bio,
    this.photoUrl,
    this.id
  });

  factory UserEntity.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserEntity(
        email: data?['email'],
        username: data?['username'],
        bio: data?['bio'],
        photoUrl: data?['photoUrl'],
        creationTimestamp: data?['creationTimestamp'],
        id: data?['id'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "email": email,
      if (username != null) "username": username,
      if (bio != null) "bio": bio,
      if (photoUrl != null) "photoUrl": photoUrl,
      if (creationTimestamp != null) "creationTimestamp": creationTimestamp,
      if (id != null) "id": id,
    };
  }
}