part of 'follow_bloc.dart';

@freezed
sealed class FollowEvent with _$FollowEvent {
  const FollowEvent._();

  const factory FollowEvent.getFollowers({required String userId}) =
      _GetFollowers;

  const factory FollowEvent.getFollowings({required String userId}) =
      _GetFollowings;

  const factory FollowEvent.followUser({required String userIdToFollow}) =
      _FollowUser;

  const factory FollowEvent.unfollowUser({required String userIdToUnfollow}) =
      _UnfollowUser;
}
