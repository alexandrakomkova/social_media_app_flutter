import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/home_repository_impl.dart';
import 'package:social_media_app/data/repository/post_repository_impl.dart';
import 'package:social_media_app/l10n/l10n.dart';

import 'package:social_media_app/presentation/pages/home/bloc/home_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/comments/comments_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/post/post_bloc.dart';
import 'package:social_media_app/presentation/pages/post/post_page.dart';
import 'package:social_media_app/presentation/widget/post_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc.getNewPosts(
          homeRepository: context.read<HomeRepositoryImpl>()
      ),
      child: _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homePageLabel),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {

              return switch(state.status) {
                HomeStatus.idle => SizedBox(),
                HomeStatus.processing => Center(child: CircularProgressIndicator(),),
                HomeStatus.failed => Center(child: Text('something went wrong'),),
                HomeStatus.success => Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child:
                          state.posts.isEmpty
                          ? Center(
                              child: Text(
                                context.l10n.homePageNoNews,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary
                                ),
                              ),
                          )
                          : ListView.builder(
                              itemCount: state.posts.length,
                              itemBuilder: (context, index) {

                                var post = state.posts[index];
                                return Padding(
                                    padding: const EdgeInsets.only(bottom: 40.0),
                                    child: MultiBlocProvider(
                                      providers: [
                                        BlocProvider<PostBloc>(
                                          create: (postContext) => PostBloc.getLikesCount(
                                            postEntity: post,
                                            postRepository: postContext.read<PostRepositoryImpl>(),
                                          ),
                                        ),
                                        BlocProvider<CommentsBloc>(
                                          create: (commentsContext) => CommentsBloc.getComments(
                                            commentRepository: commentsContext.read<PostRepositoryImpl>(),
                                            postId: post.id.toString(),
                                            postOwnerId: post.userId,
                                          ),
                                        ),
                                      ],
                                      child: PostCard(
                                        postEntity: post,
                                        onCommentsPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => PostPage(postEntity: post,),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                );
                              }
                          ),
                      )
                    ],
                  ),
                ),
              };
            }
        ),
      )
    );
  }
}

