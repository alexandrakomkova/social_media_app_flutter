import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/notification_repository_impl.dart';

import 'package:social_media_app/presentation/pages/notifications/bloc/notification_bloc.dart';
import 'package:social_media_app/presentation/widget/notification_card.dart';
import 'package:social_media_app/utils/theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create:
        (notificationContext) =>
          NotificationBloc.getNotifications(
              notificationRepository: notificationContext.read<NotificationRepositoryImpl>()
          ),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                context.read<NotificationBloc>().add(NotificationEvent.deleteAll());
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Delete All',
                  style: SocialMediaTheme.appBarActionsTextStyle,
                ),
              ),
            )
          ],
        ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (_, state) {
              return switch(state.status) {
                NotificationStatus.idle => SizedBox(),
                NotificationStatus.processing => Center(child: CircularProgressIndicator(),),
                NotificationStatus.failed => Center(child: Text('something went wrong'),),
                NotificationStatus.success =>
                  state.notifications.isEmpty
                ? Center(child: Text('No new notifications'),)
                : Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                          itemCount: state.notifications.length,
                          itemBuilder: (BuildContext context, int index) {
                            final notification = state.notifications[index];

                            return NotificationCard(notificationEntity: notification);
                          }
                        ),
                    ),
                  ],
                ),
              };
            }
        ),
      ),
    );
  }
}

