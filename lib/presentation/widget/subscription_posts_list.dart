import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/repository/post_repository.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/home/bloc/home_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/comments/comments_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/post/post_bloc.dart';
import 'package:social_media_app/presentation/pages/post/post_page.dart';
import 'package:social_media_app/presentation/widget/post_card.dart';

class SubscriptionPostsList extends StatelessWidget {
  const SubscriptionPostsList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeBloc>().state;

    return Expanded(
      child: ListView.builder(
        key: PageStorageKey('homePage_postsListView_key'),
        itemCount: state.pagination.list.length + 1,
        itemBuilder: (context, index) {
          if (index == state.pagination.list.length) {
            if (!state.pagination.hasMoreToLoad) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  top: 4.0,
                ),
                child: Center(child: Text(context.l10n.noMorePostsText)),
              );
            } else {
              return TextButton(
                onPressed: () {
                  context.read<HomeBloc>().add(HomeEvent.getNewPosts());
                },
                child: Text(context.l10n.homePageLoadMoreButton),
              );
            }
          }

          return _listTile(context: context, index: index);
        },
      ),
    );
  }

  Widget _listTile({required BuildContext context, required int index}) {
    final state = context.watch<HomeBloc>().state;
    var post = state.pagination.list[index];

    return Padding(
      key: ValueKey(state.pagination.list[index].id),
      padding: const EdgeInsets.only(bottom: 40.0),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>(
            create: (postContext) => PostBloc.getLikesCount(
              postEntity: post,
              postRepository: postContext.read<PostRepository>(),
            ),
          ),
          BlocProvider<CommentsBloc>(
            create: (commentsContext) => CommentsBloc.getComments(
              commentRepository: commentsContext.read<PostRepository>(),
              postId: post.id.toString(),
              postOwnerId: post.userId,
            ),
          ),
        ],
        child: PostCard(
          postEntity: post,
          onCommentsPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PostPage(postEntity: post)),
            );
          },
        ),
      ),
    );
  }
}
