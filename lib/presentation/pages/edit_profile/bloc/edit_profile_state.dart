part of 'edit_profile_bloc.dart';

enum EditProfileStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class EditProfileState with _$EditProfileState {
  const EditProfileState._();
  const factory EditProfileState.idle({
    @Default(EditProfileStatus.idle) EditProfileStatus status,
    @Default('') String username,
    @Default('') String bio,
    @Default('') String imageUrl,
  }) = EditProfileState$Idle;

  const factory EditProfileState.processing({
    @Default(EditProfileStatus.processing) EditProfileStatus status,
    @Default('') String username,
    @Default('') String bio,
    @Default('') String imageUrl,
  }) = EditProfileState$Processing;

  const factory EditProfileState.success({
    @Default(EditProfileStatus.success) EditProfileStatus status,
    @Default('') String username,
    @Default('') String bio,
    @Default('') String imageUrl,
  }) = EditProfileState$Success;

  const factory EditProfileState.failed({
    @Default(EditProfileStatus.failed) EditProfileStatus status,
    @Default('') String username,
    @Default('') String bio,
    @Default('') String imageUrl,
  }) = EditProfileState$Failed;
}
