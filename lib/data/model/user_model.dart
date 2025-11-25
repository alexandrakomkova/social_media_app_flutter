class UserModel {
  final String email;
  final String password;
  String? username;
  int? creationTimestamp;
  String? bio;

  UserModel({
    required this.email,
    required this.password,
    this.creationTimestamp,
    this.username,
    this.bio,
  });
}