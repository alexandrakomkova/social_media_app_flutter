part of 'notification_bloc.dart';

@freezed
sealed class NotificationState with _$NotificationState {
  const NotificationState._();

  const factory NotificationState.idle({
    @Default([]) List<NotificationEntity> notifications,
  }) = NotificationState$Idle;

  const factory NotificationState.processing({
    @Default([]) List<NotificationEntity> notifications,
  }) = NotificationState$Processing;

  const factory NotificationState.success({
    @Default([]) List<NotificationEntity> notifications,
  }) = NotificationState$Success;

  const factory NotificationState.failed({
    @Default([]) List<NotificationEntity> notifications,
    @Default('') String errorMessage,
  }) = NotificationState$Failed;

  const factory NotificationState.postLoading({
    @Default([]) List<NotificationEntity> notifications,
  }) = NotificationState$PostLoading;

  const factory NotificationState.postLoaded({
    @Default([]) List<NotificationEntity> notifications,
    @Default(null) PostEntity? postEntity,
  }) = NotificationState$PostLoaded;
}
