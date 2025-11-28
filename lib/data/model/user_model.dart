
class UserModel {
  String? username;
  final String email;
  final String password;
  int? creationTimestamp;

  UserModel({
    this.username = '',
    required this.email,
    required this.password,
    this.creationTimestamp,
  });
}