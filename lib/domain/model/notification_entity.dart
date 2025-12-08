
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/domain/model/user_entity.dart';

enum NotificationType {
  like(typeName: 'like', icon: Icons.favorite),
  comment(typeName: 'comment', icon: Icons.chat_bubble_outline_rounded),
  follow(typeName: 'follow', icon: Icons.person_add),
  unfollow(typeName: 'unfollow', icon: Icons.person_remove),
  unknown(typeName: 'unknown', icon: Icons.question_mark);

  final IconData icon;
  final String typeName;

  const NotificationType({
    required this.icon,
    required this.typeName,
  });
}

class NotificationEntity {
  final UserEntity userEntity;
  final String postId;
  final NotificationType type;
  final int creationTimestamp;

  const NotificationEntity({
    required this.userEntity,
    required this.postId,
    required this.type,
    this.creationTimestamp = 0,
  });


  DateTime get creationTimestampDateTime => DateTime.fromMillisecondsSinceEpoch(creationTimestamp ?? 0);
  String get formattedCreationTimestamp => DateFormat('dd/MM/yyyy HH:mm').format(creationTimestampDateTime);
}