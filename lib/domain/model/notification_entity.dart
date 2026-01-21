import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/domain/model/user_entity.dart';

enum NotificationType {
  like(icon: Icons.favorite),
  comment(icon: Icons.chat_bubble_outline_rounded),
  follow(icon: Icons.person_add),
  unfollow(icon: Icons.person_remove),
  unknown(icon: Icons.question_mark);

  final IconData icon;

  const NotificationType({required this.icon});
}

class NotificationEntity {
  final UserEntity userEntity;
  final String postId;
  final NotificationType type;
  final int creationTimestamp;

  NotificationEntity({
    required this.userEntity,
    required this.postId,
    required this.type,
    int? creationTimestamp,
  }) : creationTimestamp =
           creationTimestamp ?? DateTime.now().millisecondsSinceEpoch;

  DateTime get creationTimestampDateTime =>
      DateTime.fromMillisecondsSinceEpoch(creationTimestamp);

  String get formattedCreationTimestamp =>
      DateFormat('dd/MM/yyyy HH:mm').format(creationTimestampDateTime);

  int get id => creationTimestamp;
}
