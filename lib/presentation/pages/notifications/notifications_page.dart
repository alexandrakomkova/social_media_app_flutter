import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/notification_repository_impl.dart';

import 'package:social_media_app/presentation/pages/notifications/bloc/notification_bloc.dart';
import 'package:social_media_app/presentation/pages/post/post_page.dart';
import 'package:social_media_app/presentation/widget/notification_card.dart';
import 'package:social_media_app/theme/theme.dart';

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
    return BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationState$PostLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                // check the nullability in NotificationBloc _getUserPost event
                builder: (_) => PostPage(postEntity: state.postEntity!),
              ),
            );
          }
          if (state is NotificationState$Failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
      child: Scaffold(
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
                if(state.status == NotificationStatus.idle) {
                  return SizedBox();
                }

                if(state.status == NotificationStatus.processing) {
                  return Center(child: CircularProgressIndicator(),);
                }


                  return state.notifications.isEmpty
                      ? Center(child: Text('No new notifications'),)
                      : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: state.notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = state.notifications[index];

                              return NotificationCard(
                                  notificationEntity: notification,
                                  onNotificationTap: () {
                                    context.read<NotificationBloc>().add(NotificationEvent.getUserPost(notification.postId));
                                  }
                              );
                            }
                        ),
                      ),
                    ],
                  );

                // return switch(state.status) {
                //   NotificationStatus.idle => SizedBox(),
                //   NotificationStatus.processing => Center(child: CircularProgressIndicator(),),
                //   NotificationStatus.failed => Center(child: Text('something went wrong'),),
                //   NotificationStatus.success =>
                //   state.notifications.isEmpty
                //       ? Center(child: Text('No new notifications'),)
                //       : Column(
                //     children: [
                //       Expanded(
                //         child: ListView.builder(
                //             itemCount: state.notifications.length,
                //             itemBuilder: (BuildContext context, int index) {
                //               final notification = state.notifications[index];
                //
                //               return NotificationCard(
                //                 notificationEntity: notification,
                //                 onNotificationTap: () {
                //                     context.read<NotificationBloc>().add(NotificationEvent.getUserPost(notification.postId));
                //                 }
                //               );
                //             }
                //         ),
                //       ),
                //     ],
                //   ),
                // };
              }
          ),
        ),
      ),
    );
  }
}

