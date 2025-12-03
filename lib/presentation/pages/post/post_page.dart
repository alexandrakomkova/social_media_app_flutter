import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/post_repository_impl.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/pages/post/bloc/comments/comments_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/post/post_bloc.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';

class PostPage extends StatelessWidget {
  final PostEntity postEntity;

  const PostPage({
    required this.postEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>(
            create: (context) => PostBloc.getLikesCount(
              postEntity: postEntity,
              postRepository: context.read<PostRepositoryImpl>()
            )
          ),
          BlocProvider<CommentsBloc>(
              create: (context) => CommentsBloc.getComments(
                commentRepository: context.read<PostRepositoryImpl>(),
                postId: postEntity.id.toString(),
              )
          ),
        ],
        child: _PostView()
    );
  }
}

class _PostView extends StatelessWidget {

  const _PostView({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body:
      Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 70.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    children: [
                      // post
                      _postInfo(context),
                      const Divider(),

                      BlocBuilder<CommentsBloc, CommentsState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${state.comments.length} comments',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          );
                        },
                      ),

                      // comments section
                      BlocBuilder<CommentsBloc, CommentsState>(
                        builder: (context, state) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.comments.length,
                            itemBuilder: (BuildContext context, int index) {
                              var comment = state.comments[index];

                              return ListTile(
                                leading: ProfileAvatar(
                                  radius: 20.0,
                                  userEntity: UserEntity(
                                      username: comment.username,
                                      photoUrl: comment.userImageUrl
                                  ),
                                ),
                                title: Text(
                                    comment.username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600
                                    )
                                ),
                                subtitle: Text(
                                    comment.commentText,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ], //
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                color: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<CommentsBloc, CommentsState>(
                        builder: (context, state) {
                          return TextFormField(
                            initialValue: state.commentText,
                            decoration: const InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                            ),
                            onChanged: (value) {
                              context.read<CommentsBloc>().add(
                                  CommentsEvent.commentTextChanged(value));
                            },
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // context.read<CommentsBloc>().add(AddComment(_commentController.text));
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

Widget _postInfo(BuildContext context) {
  return BlocBuilder<PostBloc, PostState>(
  builder: (context, state) {
    return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.height * 0.5,
        child: CachedNetworkImage(
            imageUrl: state.postEntity.imageUrl
        ), //state.imageUrl
      ),
      SizedBox(height: 20.0,),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.postEntity.description,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    state.postEntity.formattedCreationTimestamp,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(state.isLiked ? Icons.favorite : Icons.favorite_border),
                      color: state.isLiked ? Colors.redAccent : Colors.grey,
                      iconSize: 25.0,
                      onPressed: () {
                        // context.read<PostBloc>().add(PostEvent.);
                      },
                    );
                  },
                ),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    return Text(
                      state.likesCount.toString(),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),

    ],
  );
  },
);
}
