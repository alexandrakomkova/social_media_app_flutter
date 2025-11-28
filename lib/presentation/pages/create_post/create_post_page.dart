import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/firebase_db_service_impl.dart';
import 'package:social_media_app/data/repository/image_service_impl.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';
import 'package:social_media_app/presentation/pages/create_post/bloc/create_post_bloc.dart';
import 'package:social_media_app/presentation/widget/choose_image_source.dart';
import 'package:social_media_app/presentation/widget/custom_alert_dialog.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreatePostBloc>(
      create: (imageServiceContext) => CreatePostBloc(
        imageService: imageServiceContext.read<ImageServiceImpl>(),
        dbService: imageServiceContext.read<FirebaseDbServiceImpl>(),
      ),
      child: _CreatePostView(),
    );
  }
}

class _CreatePostView extends StatelessWidget {
  const _CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _showCloseCreatePostAlertDialog(context);
          },
          icon: Icon(
            Icons.close,
          ),
        ),
        title: Center(
          child: Text(
            'New post',
            style: TextStyle(
              fontSize: 18.0,
              //fontWeight: FontWeight.w300,
            ),
          )
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              context.read<CreatePostBloc>().add(CreatePostEvent.createPost());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MainPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Post',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
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
                color: Colors.grey[300],
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
                  builder: (context, state) {
                    if(state.imageFile == null) {
                      return Center(
                        child: Text(
                          'Upload a Photo',
                          style: TextStyle(
                            color:
                            Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                    } else {
                      return Image.file(
                        state.imageFile!,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width  * 0.5,
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
                  hintText: 'Post Description',
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
    showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
            dialogTitle: 'Discard changes',
            dialogContent: 'Your changes will be discarded.',
            rightButtonTitle: 'Ok',
            onRightPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MainPage(),
                ),
              );
            },
            leftButtonTitle: 'Cancel',
            onLeftPressed: () {
              Navigator.pop(context);
            },
        ),
    );
  }
}
