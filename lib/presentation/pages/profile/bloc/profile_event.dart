part of 'profile_bloc.dart';

@freezed
sealed class ProfileEvent with _$ProfileEvent {
  const ProfileEvent._();

  const factory ProfileEvent.signOut() = _SignOut;

  const factory ProfileEvent.getUserPostsNext({required String userId}) =
      _GetUserPostsNext;

  const factory ProfileEvent.getFollowers({required String userId}) =
      _GetFollowers;

  const factory ProfileEvent.getFollowings({required String userId}) =
      _GetFollowings;

  const factory ProfileEvent.getUserProfile({required String userId}) =
      _GetUserProfile;

  const factory ProfileEvent.followUser({required String userIdToFollow}) =
      _FollowUser;

  const factory ProfileEvent.unfollowUser({required String userIdToUnfollow}) =
      _UnfollowUser;
}
