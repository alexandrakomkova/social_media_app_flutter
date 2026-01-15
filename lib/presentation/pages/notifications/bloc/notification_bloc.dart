import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/notification_repository.dart';
import 'package:social_media_app/presentation/model/pagination.dart';
import 'package:social_media_app/utils/firebase_service.dart';

part 'notification_bloc.freezed.dart';
part 'notification_event.dart';
part 'notification_state.dart';

final _log = Logger('NotificationBloc');

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository,
      super(
        NotificationState.idle(
          pagination: Pagination<NotificationEntity>.empty(),
        ),
      ) {
    on<NotificationEvent>((event, emit) async {
      switch (event) {
        case _GetNotifications():
          await _getNotifications(emit);
        case _DeleteAll():
          await _deleteAll(emit);
        case _GetUserPost():
          await _getUserPost(event, emit);
      }
    });
  }

  factory NotificationBloc.getNotifications({
    required NotificationRepository notificationRepository,
  }) =>
      NotificationBloc(notificationRepository: notificationRepository)
        ..add(NotificationEvent.getNotifications());

  Future<void> _getNotifications(Emitter<NotificationState> emit) async {
    emit(NotificationState.processing(pagination: state.pagination));

    try {
      final res = await _notificationRepository.getNotifications(
        userId: FirebaseService.currentUserId,
        lastDoc: state.pagination.lastDoc,
      );

      state.pagination.addItemsToList(res.list);

      _log.info('_getNotifications success');

      emit(
        NotificationState.success(
          pagination: state.pagination.copyWith(
            lastDoc: res.lastDoc,
            hasMoreToLoad: res.hasMoreToLoad,
          ),
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        NotificationState.failed(
          errorMessage: e.toString(),
          pagination: state.pagination.copyWith(hasMoreToLoad: false),
        ),
      );
    }
  }

  Future<void> _deleteAll(Emitter<NotificationState> emit) async {
    emit(NotificationState.processing(pagination: state.pagination));
    try {
      await _notificationRepository.deleteAll(
        userId: FirebaseService.currentUserId,
      );

      emit(
        NotificationState.success(
          pagination: state.pagination.copyWith(list: [], hasMoreToLoad: false),
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        NotificationState.failed(
          errorMessage: e.toString(),
          pagination: state.pagination,
        ),
      );
    }
  }

  Future<void> _getUserPost(
    _GetUserPost event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationState.postLoading(pagination: state.pagination));

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
          emit(
            NotificationState.failed(
              errorMessage: errorMessage,
              pagination: state.pagination,
            ),
          );
        },
        (onOk) {
          final post = onOk.value;
          if (post == null) {
            emit(
              NotificationState.failed(
                errorMessage: 'No post found',
                pagination: state.pagination,
              ),
            );
          } else {
            emit(
              NotificationState.postLoaded(
                pagination: state.pagination,
                postEntity: post,
              ),
            );
          }
        },
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        NotificationState.failed(
          errorMessage: e.toString(),
          pagination: state.pagination,
        ),
      );
    }
  }
}
