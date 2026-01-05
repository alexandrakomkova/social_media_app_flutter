import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/profile/profile_page.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity entity;
  final void Function()? onTap;

  const NotificationCard({
    required this.entity,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (entity.type) {
      case NotificationType.like:
        return _likeListTile(
          context: context,
          notificationEntity: entity,
          onTap: onTap,
        );
      case NotificationType.comment:
        return _commentListTile(
          context: context,
          notificationEntity: entity,
          onTap: onTap,
        );
      case NotificationType.follow:
        return _followListTile(context: context, notificationEntity: entity);
      case NotificationType.unfollow:
        return _unfollowListTile(context: context, notificationEntity: entity);
      case NotificationType.unknown:
        return _unknownListTile(context: context, notificationEntity: entity);
    }
  }

  Widget _likeListTile({
    required BuildContext context,
    required NotificationEntity notificationEntity,
    required void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(notificationEntity.type.icon),
      title: Text(
        context.l10n.notificationOnLikeText(
          notificationEntity.userEntity.username,
        ),
      ),
      subtitle: Text(notificationEntity.formattedCreationTimestamp),
      onTap: onTap,
    );
  }

  Widget _commentListTile({
    required BuildContext context,
    required NotificationEntity notificationEntity,
    required void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(notificationEntity.type.icon),
      title: Text(
        context.l10n.notificationOnCommentText(
          notificationEntity.userEntity.username,
        ),
      ),
      subtitle: Text(notificationEntity.formattedCreationTimestamp),
      onTap: onTap,
    );
  }

  Widget _followListTile({
    required BuildContext context,
    required NotificationEntity notificationEntity,
  }) {
    return ListTile(
      leading: Icon(notificationEntity.type.icon),
      title: Text(
        context.l10n.notificationOnFollowText(
          notificationEntity.userEntity.username,
        ),
      ),
      subtitle: Text(notificationEntity.formattedCreationTimestamp),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                ProfilePage(userId: notificationEntity.userEntity.id),
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
      title: Text(
        context.l10n.notificationOnUnfollowText(
          notificationEntity.userEntity.username,
        ),
      ),
      subtitle: Text(notificationEntity.formattedCreationTimestamp),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                ProfilePage(userId: notificationEntity.userEntity.id),
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
}
