part of 'profile_bloc.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const ProfileState._();

  const factory ProfileState.idle({
    @Default(null) UserEntity? user,
    @Default([]) List<PostEntity> posts,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
    @Default(false) bool isFollowed,
  }) = ProfileState$Idle;

  const factory ProfileState.processing({
    @Default(null) UserEntity? user,
    @Default([]) List<PostEntity> posts,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
    @Default(false) bool isFollowed,
  }) = ProfileState$Processing;

  const factory ProfileState.success({
    @Default(null) UserEntity? user,
    @Default([]) List<PostEntity> posts,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
    @Default(false) bool isFollowed,
  }) = ProfileState$Success;

  const factory ProfileState.failed({
    @Default(null) UserEntity? user,
    @Default([]) List<PostEntity> posts,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
    @Default(false) bool isFollowed,
    @Default('') String errorMessage,
  }) = ProfileState$Failed;
}
