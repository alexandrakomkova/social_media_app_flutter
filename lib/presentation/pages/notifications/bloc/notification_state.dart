part of 'notification_bloc.dart';

enum NotificationStatus {
  idle,
  processing,
  success,
  failed,
  postLoading,
  postLoaded
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
    @Default('') String errorMessage,
  }) = NotificationState$Failed;

  const factory NotificationState.postLoading({
    @Default(NotificationStatus.postLoading) NotificationStatus status,
    @Default([]) List<NotificationEntity> notifications,
  }) = NotificationState$PostLoading;

  const factory NotificationState.postLoaded({
    @Default(NotificationStatus.postLoaded) NotificationStatus status,
    @Default([]) List<NotificationEntity> notifications,
    @Default(null) PostEntity? postEntity,
  }) = NotificationState$PostLoaded;
}