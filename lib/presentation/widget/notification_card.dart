import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notificationEntity;


  const NotificationCard({
    required this.notificationEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return switch(notificationEntity.type) {
      NotificationType.like => ListTile(
        leading: Icon(notificationEntity.type.icon),
        title: Text('User ${notificationEntity.userEntity.username} liked your post'),
        subtitle: Text(notificationEntity.formattedCreationTimestamp),
        ),
      NotificationType.comment => ListTile(
        leading: Icon(notificationEntity.type.icon),
        title: Text('User ${notificationEntity.userEntity.username} commented your post'),
        subtitle: Text(notificationEntity.formattedCreationTimestamp),
      ),
      NotificationType.follow => ListTile(
        leading: Icon(notificationEntity.type.icon),
        title: Text('User ${notificationEntity.userEntity.username} started following you'),
        subtitle: Text(notificationEntity.formattedCreationTimestamp),
      ),
      NotificationType.unfollow => ListTile(
        leading: Icon(notificationEntity.type.icon),
        title: Text('User ${notificationEntity.userEntity.username} stopped following you'),
        subtitle: Text(notificationEntity.formattedCreationTimestamp),
      ),
      NotificationType.unknown => ListTile(
        leading: Icon(notificationEntity.type.icon),
        title: Text(notificationEntity.userEntity.username),
        subtitle: Text(notificationEntity.formattedCreationTimestamp),
      ),
    };
  }
}
