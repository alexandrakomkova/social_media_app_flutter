import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/presentation/pages/post/post_page.dart';
import 'package:social_media_app/presentation/pages/profile/profile_page.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notificationEntity;


  const NotificationCard({
    required this.notificationEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return switch(notificationEntity.type) {
      NotificationType.like => _likeListTile(
        context: context,
        notificationEntity: notificationEntity,
      ),
      NotificationType.comment => _commentListTile(
          context: context,
          notificationEntity: notificationEntity,
      ),
      NotificationType.follow => _followListTile(
          context: context,
          notificationEntity: notificationEntity,
      ),
      NotificationType.unfollow => _unfollowListTile(
          context: context,
          notificationEntity: notificationEntity,
      ),
      NotificationType.unknown => _unknownListTile(
          context: context,
          notificationEntity: notificationEntity,
      ),
    };
  }
}

Widget _likeListTile({
  required BuildContext context,
  required NotificationEntity notificationEntity,
}) {
  return ListTile(
    leading: Icon(notificationEntity.type.icon),
    title: Text('User ${notificationEntity.userEntity.username} liked your post'),
    subtitle: Text(notificationEntity.formattedCreationTimestamp),
    onTap: () {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (_) => PostPage(postEntity: notificationEntity.,),
      //   ),
      // );
    },
  );
}

Widget _commentListTile({
  required BuildContext context,
  required NotificationEntity notificationEntity,
}) {
  return ListTile(
    leading: Icon(notificationEntity.type.icon),
    title: Text('User ${notificationEntity.userEntity.username} commented your post'),
    subtitle: Text(notificationEntity.formattedCreationTimestamp),
  );
}

Widget _followListTile({
  required BuildContext context,
  required NotificationEntity notificationEntity,
}) {
  return ListTile(
    leading: Icon(notificationEntity.type.icon),
    title: Text('User ${notificationEntity.userEntity.username} started following you'),
    subtitle: Text(notificationEntity.formattedCreationTimestamp),
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProfilePage(userId: notificationEntity.userEntity.id),
        ),
      );
    },
  );
}

Widget _unfollowListTile({
  required BuildContext context,
  required NotificationEntity notificationEntity,
}) {
  return ListTile(
    leading: Icon(notificationEntity.type.icon),
    title: Text('User ${notificationEntity.userEntity.username} stopped following you'),
    subtitle: Text(notificationEntity.formattedCreationTimestamp),
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProfilePage(userId: notificationEntity.userEntity.id),
        ),
      );
    },
  );
}

Widget _unknownListTile({
  required BuildContext context,
  required NotificationEntity notificationEntity,
}) {
  return ListTile(
    leading: Icon(notificationEntity.type.icon),
    title: Text(notificationEntity.userEntity.username),
    subtitle: Text(notificationEntity.formattedCreationTimestamp),
  );
}