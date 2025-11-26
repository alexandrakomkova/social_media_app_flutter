part of 'profile_bloc.dart';

@freezed
abstract class ProfileEvent with _$ProfileEvent {
  const ProfileEvent._();
  const factory ProfileEvent.signOut() = _SignOut;
  const factory ProfileEvent.getUserInfo(String? id) = _GetUserInfo;
}
