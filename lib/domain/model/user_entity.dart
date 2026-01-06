class UserEntity {
  final String id;
  final String email;
  final String username;
  final int creationTimestamp;
  final String bio;
  final String photoUrl;

  UserEntity({
    required this.id,
    required this.email,
    String? username,
    String? bio,
    String? photoUrl,
    int? creationTimestamp,
  }) : username = username ?? '',
       bio = bio ?? '',
       photoUrl = photoUrl ?? '',
       creationTimestamp =
           creationTimestamp ?? DateTime.now().millisecondsSinceEpoch;

  factory UserEntity.fromMap(Map<String, dynamic> json) => UserEntity(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    bio: json["bio"],
    photoUrl: json["photoUrl"],
    creationTimestamp: json["creationTimestamp"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "username": username,
    "email": email,
    "bio": bio,
    "photoUrl": photoUrl,
    "creationTimestamp": creationTimestamp,
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
      creationTimestamp: creationTimestamp ?? this.creationTimestamp,
    );
  }
}
