import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/post_repository_impl.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/pages/post/bloc/comments/comments_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/post/post_bloc.dart';
import 'package:social_media_app/presentation/widget/post_card.dart';
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
                      //_postInfo(context),
                      PostCard(postEntity: context.read<PostBloc>().state.postEntity,),

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
                          switch(state.status) {
                            case CommentsStatus.idle:
                              return SizedBox();
                            case CommentsStatus.processing:
                              return Center(child: CircularProgressIndicator(),);
                            case CommentsStatus.failed:
                              return Center(child: Text('Error loading comments'),);
                            case CommentsStatus.success:
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
                          }
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
                child: BlocBuilder<CommentsBloc, CommentsState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  key: const Key('comment_textFormField'),
                                  initialValue: state.commentText,
                                  decoration: const InputDecoration(
                                    hintText: 'Add a comment...',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                  ),
                                  onChanged: (value) {
                                    context.read<CommentsBloc>().add(
                                    CommentsEvent.commentTextChanged(value));
                                  },
                                )
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<CommentsBloc>()
                                    ..add(CommentsEvent.addComment())
                                    ..add(CommentsEvent.getComments());
                                },
                                icon: const Icon(Icons.send),
                              ),
                            ],
                          );
                        }
                  )
                ),
              ),
            ),
        ],
      ),
    );
  }
}