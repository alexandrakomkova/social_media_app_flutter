part of 'follow_bloc.dart';

@freezed
sealed class FollowEvent with _$FollowEvent {
  const FollowEvent._();

  const factory FollowEvent.getFollowers({required String userId}) =
      _GetFollowers;

  const factory FollowEvent.getFollowings({required String userId}) =
      _GetFollowings;
}
