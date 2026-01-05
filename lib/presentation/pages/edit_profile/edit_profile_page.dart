import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/image_service.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/widget/choose_image_source.dart';
import 'package:social_media_app/presentation/widget/custom_alert_dialog.dart';
import 'package:social_media_app/presentation/widget/custom_appbar.dart';
import 'package:social_media_app/presentation/widget/custom_text_form_field.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';
import 'package:social_media_app/utils/validator.dart';

import 'bloc/edit_profile_bloc.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc.getUserInfo(
        profileRepository: context.read<ProfileRepository>(),
        imageService: context.read<ImageService>(),
      ),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: l10n.editProfileLabel,
        leadingIcon: Icons.close,
        onLeadingIconPressed: () => _showCloseEditProfileAlertDialog(context),
        actionTitle: l10n.saveButton,
        onActionTap: () {
          if (_formKey.currentState?.validate() ?? false) {
            context.read<EditProfileBloc>().add(EditProfileEvent.saveProfile());
            Navigator.pop(context);
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            BlocBuilder<EditProfileBloc, EditProfileState>(
              builder: (_, state) {
                return GestureDetector(
                  onTap: () {
                    showBottomSheetToChooseImageSource(
                      context: context,
                      onCameraTap: () {
                        context.read<EditProfileBloc>().add(
                          EditProfileEvent.selectImage(true),
                        );
                        Navigator.pop(context);
                      },
                      onGalleryTap: () {
                        context.read<EditProfileBloc>().add(
                          EditProfileEvent.selectImage(false),
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: ProfileAvatar(
                    radius: 80,
                    userEntity: UserEntity(
                      username: state.username,
                      bio: state.bio,
                      photoUrl: state.imageUrl,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                context.read<EditProfileBloc>().add(
                  EditProfileEvent.deleteImage(),
                );
              },
              child: Text(
                l10n.deleteProfileAvatarTextButton,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<EditProfileBloc, EditProfileState>(
                    buildWhen: (previousState, state) =>
                        previousState.runtimeType != state.runtimeType,
                    builder: (editProfileContext, state) {
                      return CustomTextFormField(
                        textFieldKey: UniqueKey(),
                        initialValue: state.username,
                        hintText: l10n.usernameHintText,
                        onChanged: (value) {
                          editProfileContext.read<EditProfileBloc>().add(
                            EditProfileEvent.usernameChanged(value),
                          );
                        },
                        validator: (value) =>
                            Validator(context: context).validateUsername(value),
                      );
                    },
                  ),

                  const SizedBox(height: 15.0),
                  BlocBuilder<EditProfileBloc, EditProfileState>(
                    buildWhen: (previousState, state) =>
                        previousState.runtimeType != state.runtimeType,
                    builder: (editProfileContext, state) {
                      return CustomTextFormField(
                        textFieldKey: UniqueKey(),
                        initialValue: state.bio,
                        hintText: l10n.bioHintText,
                        onChanged: (value) {
                          editProfileContext.read<EditProfileBloc>().add(
                            EditProfileEvent.bioChanged(value),
                          );
                        },
                        maxLength: 20,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showCloseEditProfileAlertDialog(BuildContext context) {
  final l10n = context.l10n;
  showDialog(
    context: context,
    builder: (_) => CustomAlertDialog(
      dialogTitle: l10n.discardChangesDialogTitle,
      dialogContent: l10n.discardChangesDialogText,
      rightButtonTitle: l10n.okButton,
      onRightPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      leftButtonTitle: l10n.cancelButton,
      onLeftPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
