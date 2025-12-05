part of 'profile_bloc.dart';

@freezed
abstract class ProfileEvent with _$ProfileEvent {
  const ProfileEvent._();
  const factory ProfileEvent.signOut() = _SignOut;
  const factory ProfileEvent.getUserInfo(String? id) = _GetUserInfo;
  const factory ProfileEvent.getUserPosts(String? userId) = _GetUserPosts;
  const factory ProfileEvent.getUserProfile(String userId) = _GetUserProfile;
  const factory ProfileEvent.followUser({required String userIdToFollow}) = _FollowUser;
  const factory ProfileEvent.unfollowUser({required String userIdToUnfollow}) = _UnfollowUser;
}
