part of 'follow_bloc.dart';

@freezed
sealed class FollowState with _$FollowState {
  const FollowState._();

  const factory FollowState.idle({
    required Pagination<UserEntity> followersPagination,
    required Pagination<UserEntity> followingsPagination,
  }) = FollowState$Idle;

  const factory FollowState.processing({
    required Pagination<UserEntity> followersPagination,
    required Pagination<UserEntity> followingsPagination,
  }) = FollowState$Processing;

  const factory FollowState.success({
    required Pagination<UserEntity> followersPagination,
    required Pagination<UserEntity> followingsPagination,
  }) = FollowState$Success;

  const factory FollowState.failed({
    @Default('') String errorMessage,
    required Pagination<UserEntity> followersPagination,
    required Pagination<UserEntity> followingsPagination,
  }) = FollowState$Failed;
}
