import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/image_service.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/create_post/bloc/create_post_bloc.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';
import 'package:social_media_app/presentation/widget/choose_image_source.dart';
import 'package:social_media_app/presentation/widget/custom_alert_dialog.dart';
import 'package:social_media_app/presentation/widget/custom_appbar.dart';
import 'package:social_media_app/utils/validator.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreatePostBloc>(
      create: (context) => CreatePostBloc(
        imageService: context.read<ImageService>(),
        dbService: context.read<DbService>(),
      ),
      child: const _CreatePostView(),
    );
  }
}

class _CreatePostView extends StatelessWidget {
  const _CreatePostView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formKey = GlobalKey<FormState>();
    final state = context.watch<CreatePostBloc>().state;

    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: l10n.createPostPageAppBarTitle,
        leadingIcon: Icons.close,
        onLeadingIconPressed: () => _showCloseCreatePostAlertDialog(context),
        actionTitle: l10n.postButton,
        onActionTap: () {
          if (formKey.currentState?.validate() ?? false) {
            context.read<CreatePostBloc>().add(CreatePostEvent.createPost());
            if (state is CreatePostState$Success) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MainPage()),
              );
            }
          }
        },
      ),
      body: BlocListener<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostState$Failed) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        listenWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          children: [
            _selectImageBox(context: context),
            const SizedBox(height: 20.0),

            Form(
              key: formKey,
              child: TextFormField(
                key: const Key('postDescription_textFormField'),
                initialValue: context
                    .watch<CreatePostBloc>()
                    .state
                    .postDescription,
                decoration: InputDecoration(
                  hintText: context.l10n.postDescriptionHintText,
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                  border: Theme.of(context).inputDecorationTheme.border,
                  errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
                ),
                onChanged: (value) => context.read<CreatePostBloc>().add(
                  CreatePostEvent.postDescriptionChanged(value),
                ),
                validator: Validator(context: context).validatePostDescription,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCloseCreatePostAlertDialog(BuildContext context) {
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

  Widget _selectImageBox({required BuildContext context}) {
    return InkWell(
      onTap: () {
        showBottomSheetToChooseImageSource(
          context: context,
          onCameraTap: () {
            context.read<CreatePostBloc>().add(
              CreatePostEvent.selectImage(true),
            );
            Navigator.pop(context);
          },
          onGalleryTap: () {
            context.read<CreatePostBloc>().add(
              CreatePostEvent.selectImage(false),
            );
            Navigator.pop(context);
          },
        );
      },
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.5,
        width: MediaQuery.sizeOf(context).width * 0.5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
          ),
          child: BlocBuilder<CreatePostBloc, CreatePostState>(
            builder: (context, state) {
              if (state.imageFile == null) {
                return Center(child: Text(context.l10n.uploadPhotoText));
              }

              return Image.file(
                state.imageFile!,
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: MediaQuery.sizeOf(context).width * 0.5,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }
}
