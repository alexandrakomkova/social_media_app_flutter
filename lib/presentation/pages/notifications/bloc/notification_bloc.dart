import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/utils/firebase_utils.dart';

part 'notification_event.dart';
part 'notification_state.dart';
part 'notification_bloc.freezed.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc({
    required NotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository,
        super(NotificationState.idle()) {
    on<NotificationEvent>((events, emit) async {
      await events.map(
        getNotifications: (_) => _getNotifications(emit),
        deleteAll: (_) => _deleteAll(emit),
        getUserPost: (event) => _getUserPost(event, emit),
      );
    });
  }

  factory NotificationBloc.getNotifications({
    required NotificationRepository notificationRepository
  }) => NotificationBloc(
      notificationRepository: notificationRepository,
  )..add(NotificationEvent.getNotifications());

  Future<void> _getNotifications(Emitter<NotificationState> emit) async {
    emit(NotificationState.processing());

    try {
      final notifications = await _notificationRepository.getNotifications(userId: FirebaseUtils.currentUserId);

      emit(NotificationState.success(
        notifications: notifications,
      ));
    } catch(e) {
      emit(NotificationState.failed(errorMessage: e.toString()));
    }
  }

  Future<void> _deleteAll(Emitter<NotificationState> emit) async {
    emit(NotificationState.processing());
    try {
      await _notificationRepository.deleteAll(userId: FirebaseUtils.currentUserId);

      emit(NotificationState.success(
        notifications: [],
      ));
    } catch(e) {
      emit(NotificationState.failed(errorMessage: e.toString()));
    }
  }

  Future<void> _getUserPost(
    _GetUserPost event,
    Emitter<NotificationState> emit
  ) async {
    emit(NotificationState.postLoading(
      notifications: state.notifications
    ));

    try {
      final res = await _notificationRepository.getUserPost(postId: event.postId);

      res.fold(
          (onError) {
            final String errorMessage = onError.error is FirebaseAuthException
                ? (onError.error as FirebaseAuthException).message ?? ''
                : 'An unexpected error occurred';

            emit(NotificationState.failed(
                errorMessage: errorMessage
            ));
          },
          (onOk) {
            final post = onOk.value;
            if(post == null) {
              emit(NotificationState.failed(
                  errorMessage: 'No post found',
                notifications: state.notifications
              ));
            } else {
              emit(NotificationState.postLoaded(
                notifications: state.notifications,
                postEntity: post,
              ));
            }

          }
      );

    } catch(e) {
      emit(NotificationState.failed(
        errorMessage: e.toString()
      ));
    }

  }
}
