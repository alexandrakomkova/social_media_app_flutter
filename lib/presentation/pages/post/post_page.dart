import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/post_repository.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/post/bloc/comments/comments_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/post/post_bloc.dart';
import 'package:social_media_app/presentation/widget/comment_card.dart';
import 'package:social_media_app/presentation/widget/custom_loader.dart';
import 'package:social_media_app/presentation/widget/post_card.dart';
import 'package:social_media_app/utils/validator.dart';

class PostPage extends StatelessWidget {
  final PostEntity postEntity;

  const PostPage({super.key, required this.postEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (context) => PostBloc.getLikesCount(
            postEntity: postEntity,
            postRepository: context.read<PostRepository>(),
          ),
        ),
        BlocProvider<CommentsBloc>(
          create: (context) => CommentsBloc.getComments(
            commentRepository: context.read<PostRepository>(),
            postId: postEntity.id.toString(),
            postOwnerId: postEntity.userId,
          ),
        ),
      ],
      child: _PostView(),
    );
  }
}

class _PostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 70.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    children: [
                      PostCard(
                        postEntity: context.read<PostBloc>().state.postEntity,
                      ),

                      BlocBuilder<CommentsBloc, CommentsState>(
                        builder: (_, state) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              l10n.commentsCount(state.commentsCount),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          );
                        },
                      ),

                      _commentsList(context: context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _commentTextField(context: context),
        ],
      ),
    );
  }

  Widget _commentsList({required BuildContext context}) {
    return BlocBuilder<CommentsBloc, CommentsState>(
      builder: (context, state) {
        switch (state) {
          case CommentsState$Idle():
            return SizedBox();
          case CommentsState$Processing():
            return CustomLoader();
          case CommentsState$Failed():
            return Center(child: Text(context.l10n.errorLoadingCommentText));
          case CommentsState$Success():
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification.metrics.pixels >=
                        scrollNotification.metrics.maxScrollExtent - 200 &&
                    state.pagination.hasMoreToLoad) {
                  context.read<CommentsBloc>().add(CommentsEvent.getComments());
                }
                return false;
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.pagination.list.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == state.pagination.list.length) {
                    if (!state.pagination.hasMoreToLoad) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          left: 16.0,
                          right: 16.0,
                          top: 4.0,
                        ),
                        child: Center(
                          child: Text(context.l10n.noMoreCommentsText),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }

                  return CommentCard(entity: state.pagination.list[index]);
                },
              ),
            );
        }
      },
    );
  }

  Widget _commentTextField({required BuildContext context}) {
    final formKey = GlobalKey<FormState>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: BlocBuilder<CommentsBloc, CommentsState>(
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        key: const Key('comment_textFormField'),
                        initialValue: state.commentText,
                        decoration: InputDecoration(
                          hintText: context.l10n.addCommentHintText,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                        ),
                        onChanged: (value) {
                          context.read<CommentsBloc>().add(
                            CommentsEvent.commentTextChanged(value),
                          );
                        },
                        maxLength: 100,
                        validator: Validator(context: context).validateComment,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        context.read<CommentsBloc>()
                          ..add(CommentsEvent.addComment())
                          ..add(CommentsEvent.getComments());
                      } else {
                        null;
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
