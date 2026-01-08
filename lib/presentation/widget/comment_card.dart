import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';

class CommentCard extends StatelessWidget {
  final CommentEntity entity;

  const CommentCard({required this.entity, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileAvatar(
        radius: 20.0,
        username: entity.author.username,
        photoUrl: entity.author.photoUrl,
      ),
      title: Text(
        entity.author.username,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        entity.text,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
