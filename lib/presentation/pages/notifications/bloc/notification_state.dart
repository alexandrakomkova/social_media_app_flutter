part of 'notification_bloc.dart';

@freezed
sealed class NotificationState with _$NotificationState {
  const NotificationState._();

  const factory NotificationState.idle() = NotificationState$Idle;

  const factory NotificationState.processing() = NotificationState$Processing;

  const factory NotificationState.success({
    required Pagination<NotificationEntity> pagination,
  }) = NotificationState$Success;

  const factory NotificationState.failed({
    required Pagination<NotificationEntity> pagination,
    @Default('') String errorMessage,
  }) = NotificationState$Failed;

  const factory NotificationState.postLoading({
    required Pagination<NotificationEntity> pagination,
  }) = NotificationState$PostLoading;

  const factory NotificationState.postLoaded({
    required Pagination<NotificationEntity> pagination,
    PostEntity? postEntity,
  }) = NotificationState$PostLoaded;
}
