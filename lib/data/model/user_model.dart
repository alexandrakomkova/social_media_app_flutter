class UserModel {
  final String username;
  final String email;
  final String password;
  final int creationTimestamp;

  UserModel({
    String? username,
    required this.email,
    required this.password,
    int? creationTimestamp,
  }) : username = username ?? '',
       creationTimestamp =
           creationTimestamp ?? DateTime.now().millisecondsSinceEpoch;
}
