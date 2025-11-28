part of 'profile_bloc.dart';

@freezed
abstract class ProfileEvent with _$ProfileEvent {
  const ProfileEvent._();
  const factory ProfileEvent.signOut() = _SignOut;
  const factory ProfileEvent.getUserInfo(String? id) = _GetUserInfo;
  const factory ProfileEvent.getUserPosts(String? userId) = _GetUserPosts;
  const factory ProfileEvent.getUserProfile(String? userId) = _GetUserProfile;
}
