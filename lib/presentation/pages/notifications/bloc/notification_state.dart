part of 'notification_bloc.dart';

enum NotificationStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class NotificationState with _$NotificationState {
  const NotificationState._();

  const factory NotificationState.idle({
    @Default(NotificationStatus.idle) NotificationStatus status,
    @Default([]) List<NotificationEntity> notifications,
  }) = NotificationState$Idle;

  const factory NotificationState.processing({
    @Default(NotificationStatus.processing) NotificationStatus status,
    @Default([]) List<NotificationEntity> notifications,
  }) = NotificationState$Processing;

  const factory NotificationState.success({
    @Default(NotificationStatus.success) NotificationStatus status,
    @Default([]) List<NotificationEntity> notifications,
  }) = NotificationState$Success;

  const factory NotificationState.failed({
    @Default(NotificationStatus.failed) NotificationStatus status,
    @Default([]) List<NotificationEntity> notifications,
  }) = NotificationState$Failed;
}