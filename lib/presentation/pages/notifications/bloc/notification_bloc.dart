import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/utils/firebase_service.dart';

part 'notification_bloc.freezed.dart';
part 'notification_event.dart';
part 'notification_state.dart';

final _log = Logger('NotificationBloc');

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository,
      super(NotificationState.idle()) {
    on<NotificationEvent>((event, emit) async {
      switch (event.runtimeType) {
        case const (_GetNotifications):
          await _getNotifications(emit);
        case const (_DeleteAll):
          await _deleteAll(emit);
        case const (_GetUserPost):
          await _getUserPost(event as _GetUserPost, emit);
      }
    });
  }

  factory NotificationBloc.getNotifications({
    required NotificationRepository notificationRepository,
  }) =>
      NotificationBloc(notificationRepository: notificationRepository)
        ..add(NotificationEvent.getNotifications());

  Future<void> _getNotifications(Emitter<NotificationState> emit) async {
    emit(NotificationState.processing());

    try {
      final notifications = await _notificationRepository.getNotifications(
        userId: FirebaseService.currentUserId,
      );

      emit(NotificationState.success(notifications: notifications));
    } catch (e) {
      _log.warning(e.toString());
      emit(NotificationState.failed(errorMessage: e.toString()));
    }
  }

  Future<void> _deleteAll(Emitter<NotificationState> emit) async {
    emit(NotificationState.processing());
    try {
      await _notificationRepository.deleteAll(
        userId: FirebaseService.currentUserId,
      );

      emit(NotificationState.success(notifications: []));
    } catch (e) {
      _log.warning(e.toString());
      emit(NotificationState.failed(errorMessage: e.toString()));
    }
  }

  Future<void> _getUserPost(
    _GetUserPost event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationState.postLoading(notifications: state.notifications));

    try {
      final res = await _notificationRepository.getUserPost(
        postId: event.postId,
      );

      res.fold(
        (onError) {
          final String errorMessage = onError.error is FirebaseAuthException
              ? (onError.error as FirebaseAuthException).message ?? ''
              : 'An unexpected error occurred';

          _log.warning('-- ${onError.error.toString()}');
          emit(NotificationState.failed(errorMessage: errorMessage));
        },
        (onOk) {
          final post = onOk.value;
          if (post == null) {
            emit(
              NotificationState.failed(
                errorMessage: 'No post found',
                notifications: state.notifications,
              ),
            );
          } else {
            emit(
              NotificationState.postLoaded(
                notifications: state.notifications,
                postEntity: post,
              ),
            );
          }
        },
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(NotificationState.failed(errorMessage: e.toString()));
    }
  }
}
