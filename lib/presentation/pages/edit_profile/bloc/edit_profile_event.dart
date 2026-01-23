part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileEvent with _$EditProfileEvent {
  const EditProfileEvent._();

  const factory EditProfileEvent.usernameChanged(String username) =
      _UsernameChanged;

  const factory EditProfileEvent.bioChanged(String bio) = _BioChanged;

  const factory EditProfileEvent.selectImage(bool isCamera) = _SelectImage;

  const factory EditProfileEvent.deleteImage() = _DeleteImage;

  const factory EditProfileEvent.saveProfile() = _SaveProfile;

  const factory EditProfileEvent.getUserInfo() = _GetUserInfo;
}
