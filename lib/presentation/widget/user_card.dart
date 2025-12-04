import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';

class UserCard extends StatelessWidget {
  final UserEntity userEntity;
  final void Function()? onTap;

  const UserCard({
    required this.userEntity,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileAvatar(
        radius: 30.0,
        userEntity: userEntity,
      ),
      title: Text(
        userEntity.username,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      ),
      subtitle: Text(
        userEntity.bio,
        style: TextStyle(
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis
      ),
      onTap: onTap,
    );

  }
}
