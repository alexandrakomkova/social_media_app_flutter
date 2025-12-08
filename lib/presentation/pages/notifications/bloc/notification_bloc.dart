import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
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
      );
    });
  }

  Future<void> _getNotifications(Emitter<NotificationState> emit) async {
    emit(NotificationState.processing());

    try {
      final notifications = await _notificationRepository.getNotifications(userId: FirebaseUtils.currentUserId);

      emit(NotificationState.success(
        notifications: notifications,
      ));
    } catch(e) {
      emit(NotificationState.failed());
    }

  }
}
