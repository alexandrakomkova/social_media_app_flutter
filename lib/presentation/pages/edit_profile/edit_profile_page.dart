import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:social_media_app/presentation/widget/custom_text_form_field.dart';
import 'package:social_media_app/presentation/widget/choose_image_source.dart';
import 'package:social_media_app/presentation/widget/custom_alert_dialog.dart';
import 'package:social_media_app/presentation/widget/custom_appbar.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (profileContext) =>
          ProfileBloc(
              authRepository: profileContext.read<AuthRepositoryImpl>(),
              profileRepository: profileContext.read<ProfileRepositoryImpl>()
          ),
      child: _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView({super.key});

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appBarTitle: 'Edit profile',
          leadingIcon: Icons.close,
          onLeadingIconPressed: () => _showCloseEditProfileAlertDialog(context),
          actionTitle: 'Save',
          onActionTap: () {
            // context.read<CreatePostBloc>().add(CreatePostEvent.createPost());
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => MainPage(),
            //   ),
            // );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (_, state) {
                  return GestureDetector(
                    onTap: () {
                      showBottomSheetToChooseImageSource(
                        context: context,
                        onCameraTap: () {
                          //context.read<CreatePostBloc>().add(CreatePostEvent.selectImage(true));
                          Navigator.pop(context);
                        },
                        onGalleryTap: () {
                          // context.read<CreatePostBloc>().add(CreatePostEvent.selectImage(false));
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: ProfileAvatar(
                      radius: 80,
                      userEntity: state.user ?? UserEntity(),
                    ),
                  );
                },
              ),
              SizedBox(height: 50.0,),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      textFieldKey: const Key(
                        'editProfileForm_username_textFormField'
                      ),
                      initialValue: '',
                      hintText: 'Username',
                      onChanged: (value) {},
                    ),

                    const SizedBox(height: 15.0),
                    CustomTextFormField(
                      textFieldKey: const Key(
                          'editProfileForm_bio_textFormField'
                      ),
                      initialValue: '',
                      hintText: 'Bio',
                      onChanged: (value) {},
                    ),

                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}


void _showCloseEditProfileAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) =>
        CustomAlertDialog(
          dialogTitle: 'Discard changes',
          dialogContent: 'Your changes will be discarded.',
          rightButtonTitle: 'Ok',
          onRightPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => SettingsPage(),
            //   ),
            // );

          },
          leftButtonTitle: 'Cancel',
          onLeftPressed: () {
            Navigator.pop(context);
          },
        ),
  );
}