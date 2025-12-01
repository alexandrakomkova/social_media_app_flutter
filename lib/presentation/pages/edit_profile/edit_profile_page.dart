import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/image_service_impl.dart';
import 'package:social_media_app/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/widget/custom_text_form_field.dart';
import 'package:social_media_app/presentation/widget/choose_image_source.dart';
import 'package:social_media_app/presentation/widget/custom_alert_dialog.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';

import 'bloc/edit_profile_bloc.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (editProfileContext) =>
          EditProfileBloc(
              profileRepository: editProfileContext.read<ProfileRepositoryImpl>(),
              imageService: editProfileContext.read<ImageServiceImpl>(),
          )..add(EditProfileEvent.getUserInfo()),
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
   // final userEntity = context.read<ProfileBloc>().state.user;

    return Scaffold(
        // appBar: CustomAppBar(
        //   appBarTitle: 'Edit profile',
        //   leadingIcon: Icons.close,
        //   onLeadingIconPressed: () => _showCloseEditProfileAlertDialog(context),
        //   actionTitle: 'Save',
        //   onActionTap: () {
        //     context.read<EditProfileBloc>().add(EditProfileEvent.saveProfile());
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (_) => MainPage(),
        //       ),
        //     );
        //   },
        // ),

        appBar: AppBar(
          leading: IconButton(
            onPressed: () => _showCloseEditProfileAlertDialog(context),
            icon: Icon(
              Icons.close,
            ),
          ),
          title: Center(
              child: Text(
                'Edit profile',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              )
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                debugPrint('--- tapped');
                context.read<EditProfileBloc>().add(EditProfileEvent.saveProfile());
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => MainPage(),
                    //   ),
                    // );
                //Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
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
                          context.read<EditProfileBloc>().add(EditProfileEvent.selectImage(true));
                          Navigator.pop(context);
                        },
                        onGalleryTap: () {
                          context.read<EditProfileBloc>().add(EditProfileEvent.selectImage(false));
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: ProfileAvatar(
                      radius: 80,
                      userEntity: UserEntity(
                        username: state.username,
                        bio: state.bio,
                        photoUrl: state.imageFile
                      ) ?? UserEntity(),
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
                    BlocBuilder<EditProfileBloc, EditProfileState>(
                        builder: (context, state) {
                          return CustomTextFormField(
                            textFieldKey: const Key(
                              'editProfileForm_username_textFormField'
                            ),
                            initialValue: state.username,
                            hintText: 'Username',
                            onChanged: (value) {
                              context.read<EditProfileBloc>().add(EditProfileEvent.usernameChanged(value));
                            },
                          );
                        }
                    ),

                    const SizedBox(height: 15.0),
                    BlocBuilder<EditProfileBloc, EditProfileState>(
                      builder: (context, state) {
                        return CustomTextFormField(
                          textFieldKey: const Key(
                              'editProfileForm_bio_textFormField'
                          ),
                          initialValue: state.bio,
                          hintText: 'Bio',
                          onChanged: (value) {
                            context.read<EditProfileBloc>().add(EditProfileEvent.bioChanged(value));
                          },
                        );
                      },
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
            Navigator.pop(context);
            Navigator.pop(context);

          },
          leftButtonTitle: 'Cancel',
          onLeftPressed: () {
            Navigator.pop(context);
          },
        ),
  );
}