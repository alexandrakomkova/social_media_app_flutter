
class UserModel {
  final String email;
  final String password;
  int? creationTimestamp;

  UserModel({
    required this.email,
    required this.password,
    this.creationTimestamp,
  });
}