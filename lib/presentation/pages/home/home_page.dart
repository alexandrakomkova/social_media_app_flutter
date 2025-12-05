import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/home_repository_impl.dart';
import 'package:social_media_app/data/repository/post_repository_impl.dart';
import 'package:social_media_app/domain/model/post_entity.dart';

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
      create: (context) => HomeBloc(
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            var post = PostEntity(
                              userId: 'JVMjiN2MOqdfRNi1sggKmJQUuML2',
                              imageUrl: 'https://firebasestorage.googleapis.com/v0/b/social-media-flutter-4fefb.firebasestorage.app/o/images%2F1764311835069?alt=media&token=8965b2b3-b801-44bc-9894-37d04c110265',
                              description: 'best cat ever!!',
                              creationTimestamp: 1764311835069,
                            );
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 40.0),
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider<PostBloc>(
                                    create: (context) => PostBloc.getLikesCount(
                                        postEntity: post,
                                        postRepository: context.read<PostRepositoryImpl>(),
                                    ),
                                  ),
                                  BlocProvider<CommentsBloc>(
                                    create: (context) => CommentsBloc.getComments(
                                        commentRepository: context.read<PostRepositoryImpl>(),
                                        postId: post.id.toString(),
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
              );
            }
        ),
      )
    );
  }
}

