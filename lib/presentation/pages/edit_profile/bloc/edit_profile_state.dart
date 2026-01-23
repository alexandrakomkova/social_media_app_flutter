part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileState with _$EditProfileState {
  const EditProfileState._();

  const factory EditProfileState.idle({
    @Default('') String username,
    @Default('') String bio,
    @Default('') String imageUrl,
  }) = EditProfileState$Idle;

  const factory EditProfileState.processing({
    @Default('') String username,
    @Default('') String bio,
    @Default('') String imageUrl,
  }) = EditProfileState$Processing;

  const factory EditProfileState.success({
    @Default('') String username,
    @Default('') String bio,
    @Default('') String imageUrl,
  }) = EditProfileState$Success;

  const factory EditProfileState.failed({
    @Default('') String username,
    @Default('') String bio,
    @Default('') String imageUrl,
  }) = EditProfileState$Failed;
}
