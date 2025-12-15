import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/firebase_db_service_impl.dart';
import 'package:social_media_app/data/repository/image_service_impl.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';
import 'package:social_media_app/presentation/pages/create_post/bloc/create_post_bloc.dart';
import 'package:social_media_app/presentation/widget/choose_image_source.dart';
import 'package:social_media_app/presentation/widget/custom_alert_dialog.dart';
import 'package:social_media_app/presentation/widget/custom_appbar.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreatePostBloc>(
      create: (imageServiceContext) => CreatePostBloc(
        imageService: imageServiceContext.read<ImageServiceImpl>(),
        dbService: imageServiceContext.read<FirebaseDbServiceImpl>(),
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
    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: l10n.createPostPageAppBarTitle,
          leadingIcon: Icons.close,
          onLeadingIconPressed: () => _showCloseCreatePostAlertDialog(context),
          actionTitle: l10n.postButton,
          onActionTap: () {
            context.read<CreatePostBloc>().add(CreatePostEvent.createPost());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MainPage(),
              ),
            );
          },
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        children: [
          // photo inkwell
         InkWell(
            onTap: () {
              showBottomSheetToChooseImageSource(
                context: context,
                onCameraTap: () {
                  context.read<CreatePostBloc>().add(CreatePostEvent.selectImage(true));
                  Navigator.pop(context);
                },
                onGalleryTap: () {
                  context.read<CreatePostBloc>().add(CreatePostEvent.selectImage(false));
                  Navigator.pop(context);
                },
              );
            },
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.5,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                border: Border.all(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                ),
              ),
              child: BlocBuilder<CreatePostBloc, CreatePostState>(
                  builder: (createPostContext, state) {
                    if(state.imageFile == null) {
                      return Center(
                        child: Text(
                          createPostContext.l10n.uploadPhotoText,
                          style: TextStyle(
                            //color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                    } else {
                      return Image.file(
                        state.imageFile!,
                        width: MediaQuery.of(createPostContext).size.width * 0.5,
                        height: MediaQuery.of(createPostContext).size.width  * 0.5,
                        fit: BoxFit.cover,
                      );
                    }
                  },
              ) // image
            ),
          ),
          SizedBox(height: 20.0),

          //description
          BlocBuilder<CreatePostBloc, CreatePostState>(
            builder: (createPostContext, state) {
              return TextFormField(
                initialValue: state.postDescription,
                decoration: InputDecoration(
                  hintText: createPostContext.l10n.postDescriptionHintText,
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  errorStyle: TextStyle(fontSize: 12.0),
                ),
                maxLines: null,
                onChanged: (value) =>
                    createPostContext.read<CreatePostBloc>().add(
                        CreatePostEvent.postDescriptionChanged(value)
                    ),
              );
            },
          ),
        ],
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
}
