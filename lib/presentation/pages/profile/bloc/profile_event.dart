part of 'profile_bloc.dart';

@freezed
abstract class ProfileEvent with _$ProfileEvent {
  const ProfileEvent._();

  const factory ProfileEvent.signOut() = _SignOut;

  const factory ProfileEvent.getUserInfo({required String userId}) =
      _GetUserInfo;

  const factory ProfileEvent.getUserPostsNext({required String userId}) =
      _GetUserPostsNext;

  const factory ProfileEvent.getUserProfile({required String userId}) =
      _GetUserProfile;

  const factory ProfileEvent.followUser({required String userIdToFollow}) =
      _FollowUser;

  const factory ProfileEvent.unfollowUser({required String userIdToUnfollow}) =
      _UnfollowUser;
}
