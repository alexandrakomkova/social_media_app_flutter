part of 'profile_bloc.dart';

enum ProfileStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class ProfileState with _$ProfileState{
  const ProfileState._();

  const factory ProfileState.idle({
    @Default(ProfileStatus.idle) ProfileStatus status,
    @Default(null) UserEntity? user,
    @Default([]) List<PostEntity> posts,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
  }) = ProfileState$Idle;

  const factory ProfileState.processing({
    @Default(ProfileStatus.processing) ProfileStatus status,
    @Default(null) UserEntity? user,
    @Default([]) List<PostEntity> posts,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
  }) = ProfileState$Processing;

  const factory ProfileState.success({
    @Default(ProfileStatus.success) ProfileStatus status,
    @Default(null) UserEntity? user,
    @Default([]) List<PostEntity> posts,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
  }) = ProfileState$Success;

  const factory ProfileState.failed({
    @Default(ProfileStatus.failed) ProfileStatus status,
    @Default(null) UserEntity? user,
    @Default([]) List<PostEntity> posts,
    @Default([]) List<UserEntity> followers,
    @Default([]) List<UserEntity> followings,
  }) = ProfileState$Failed;
}