import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/notification_repository_impl.dart';

import 'package:social_media_app/presentation/pages/notifications/bloc/notification_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create:
        (notificationContext) =>
          NotificationBloc(
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
          actions: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Delete All',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Expanded(
        //         child: BlocBuilder<NotificationBloc, NotificationState>(
        //           builder: (context, state) {
        //             return ListView.builder(
        //                 itemCount: state.notifications.length,
        //                 itemBuilder: (BuildContext context, int index) {
        //                   final notification = state.notifications[index];
        //
        //                   return ListTile(
        //                     trailing: Icon(notification.type.icon),
        //                     title: Text(notification.userEntity.username),
        //                     subtitle: Text(notification.type.typeName),
        //                   );
        //                 }
        //             );
        //           },
        //         )
        //     )
        //   ],
        // )
      body: Padding(
          padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              return switch(state.status) {
                NotificationStatus.idle => SizedBox(),
                NotificationStatus.processing => Center(child: CircularProgressIndicator(),),
                NotificationStatus.failed => Center(child: Text('something went wrong'),),
                NotificationStatus.success => Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                          itemCount: state.notifications.length,
                          itemBuilder: (BuildContext context, int index) {
                            final notification = state.notifications[index];

                            return ListTile(
                              trailing: Icon(notification.type.icon),
                              title: Text(notification.userEntity.username),
                              subtitle: Text(notification.type.typeName),
                              );
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

