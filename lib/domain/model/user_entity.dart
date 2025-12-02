import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  String id;
  String email;
  String username;
  int? creationTimestamp;
  String bio;
  String photoUrl;

  UserEntity({
    this.email = '',
    this.creationTimestamp = 0,
    this.username = '',
    this.bio = '',
    this.photoUrl = '',
    this.id = ''
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

  factory UserEntity.fromMap(Map<String, dynamic> json) => UserEntity(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    bio: json["bio"],
    photoUrl: json["photoUrl"],
    creationTimestamp: json["creationTime"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "username": username,
    "email": email,
    "bio": bio,
    "photoUrl": photoUrl,
    "creationTime": creationTimestamp,
  };

  UserEntity copyWith({
    String? id,
    String? username,
    String? email,
    String? bio,
    String? photoUrl,
    int? creationTimestamp,
  }) {
    return UserEntity(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        bio: bio ?? this.bio,
        photoUrl: photoUrl ?? this.photoUrl,
        creationTimestamp: creationTimestamp ?? this.creationTimestamp
    );
  }
}