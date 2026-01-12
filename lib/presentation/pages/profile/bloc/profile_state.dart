part of 'profile_bloc.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const ProfileState._();

  const factory ProfileState.idle({
    @Default(null) UserEntity? user,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
    @Default(0) int postsCount,
    @Default(false) bool isFollowed,
    required Pagination<PostEntity> pagination,
  }) = ProfileState$Idle;

  const factory ProfileState.processing({
    @Default(null) UserEntity? user,
    @Default(0) int postsCount,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
    @Default(false) bool isFollowed,
    required Pagination<PostEntity> pagination,
  }) = ProfileState$Processing;

  const factory ProfileState.success({
    @Default(null) UserEntity? user,
    @Default(0) int postsCount,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
    @Default(false) bool isFollowed,
    required Pagination<PostEntity> pagination,
  }) = ProfileState$Success;

  const factory ProfileState.failed({
    @Default(null) UserEntity? user,
    @Default(0) int postsCount,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
    @Default(false) bool isFollowed,
    @Default('') String errorMessage,
    required Pagination<PostEntity> pagination,
  }) = ProfileState$Failed;
}
