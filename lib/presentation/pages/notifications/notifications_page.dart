import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/model/pagination.dart';
import 'package:social_media_app/presentation/pages/notifications/bloc/notification_bloc.dart';
import 'package:social_media_app/presentation/pages/post/post_page.dart';
import 'package:social_media_app/presentation/widget/custom_loader.dart';
import 'package:social_media_app/presentation/widget/notification_card.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (context) => NotificationBloc.getNotifications(
        notificationRepository: context.read<NotificationRepository>(),
      ),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationState$PostLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              // prevent nullable exception in NotificationBloc _getUserPost event
              builder: (_) => PostPage(postEntity: state.postEntity!),
            ),
          );
        }
        if (state is NotificationState$Failed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.notificationsPageLabel),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                context.read<NotificationBloc>().add(
                  NotificationEvent.deleteAll(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  l10n.deleteAllButton,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              return switch (state) {
                NotificationState$Idle() => SizedBox(),
                NotificationState$Processing() => CustomLoader(),
                NotificationState$Success(:final pagination) ||
                NotificationState$Failed(:final pagination) ||
                NotificationState$PostLoading(:final pagination) ||
                NotificationState$PostLoaded(
                  :final pagination,
                ) when pagination.list.isEmpty => _emptyList(context: context),
                NotificationState$Success(:final pagination) ||
                NotificationState$PostLoaded(:final pagination) ||
                NotificationState$PostLoading(:final pagination) ||
                NotificationState$Failed(:final pagination) =>
                  _notificationList(context: context, pagination: pagination),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _emptyList({required BuildContext context}) {
    return Center(child: Text(context.l10n.notificationPageNoNotifications));
  }

  Widget _notificationList({
    required BuildContext context,
    required Pagination<NotificationEntity> pagination,
  }) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >=
                scrollNotification.metrics.maxScrollExtent - 200 &&
            pagination.hasMoreToLoad) {
          context.read<NotificationBloc>().add(
            NotificationEvent.getNotifications(),
          );
        }
        return false;
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: pagination.list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == pagination.list.length) {
            if (!pagination.hasMoreToLoad) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  top: 14.0,
                ),
                child: Center(
                  child: Text(context.l10n.noMoreNotificationsText),
                ),
              );
            } else {
              return SizedBox();
            }
          }

          final notification = pagination.list[index];

          return NotificationCard(
            entity: notification,
            onTap: () {
              context.read<NotificationBloc>().add(
                NotificationEvent.getUserPost(notification.postId),
              );
            },
          );
        },
      ),
    );
  }
}
