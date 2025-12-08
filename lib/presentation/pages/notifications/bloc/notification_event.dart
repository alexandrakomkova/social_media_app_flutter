part of 'notification_bloc.dart';

@freezed
abstract class NotificationEvent with _$NotificationEvent {
  const NotificationEvent._();

  const factory NotificationEvent.getNotifications() = _GetNotifications;
}
