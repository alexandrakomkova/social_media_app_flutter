part of 'profile_bloc.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const ProfileState._();

  const factory ProfileState.idle({
    UserEntity? user,
    @Default(0) int postsCount,
    @Default(0) int followersCount,
    @Default(0) int followingsCount,
    @Default(false) bool isFollowed,
    required Pagination<PostEntity> pagination,
    required Pagination<UserEntity> followersPagination,
    required Pagination<UserEntity> followingsPagination,
  }) = ProfileState$Idle;

  const factory ProfileState.processing({
    UserEntity? user,
    @Default(0) int postsCount,
    @Default(0) int followersCount,
    @Default(0) int followingsCount,
    @Default(false) bool isFollowed,
    required Pagination<PostEntity> pagination,
    required Pagination<UserEntity> followersPagination,
    required Pagination<UserEntity> followingsPagination,
  }) = ProfileState$Processing;

  const factory ProfileState.success({
    UserEntity? user,
    @Default(0) int postsCount,
    @Default(0) int followersCount,
    @Default(0) int followingsCount,
    @Default(false) bool isFollowed,
    required Pagination<PostEntity> pagination,
    required Pagination<UserEntity> followersPagination,
    required Pagination<UserEntity> followingsPagination,
  }) = ProfileState$Success;

  const factory ProfileState.failed({
    UserEntity? user,
    @Default(0) int postsCount,
    @Default(0) int followersCount,
    @Default(0) int followingsCount,
    @Default(false) bool isFollowed,
    @Default('') String errorMessage,
    required Pagination<PostEntity> pagination,
    required Pagination<UserEntity> followersPagination,
    required Pagination<UserEntity> followingsPagination,
  }) = ProfileState$Failed;
}
