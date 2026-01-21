import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/post_repository.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/model/pagination.dart';
import 'package:social_media_app/presentation/pages/home/bloc/home_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/comments/comments_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/post/post_bloc.dart';
import 'package:social_media_app/presentation/pages/post/post_page.dart';
import 'package:social_media_app/presentation/widget/post_card.dart';

class SubscriptionPostsList extends StatelessWidget {
  final Pagination<PostEntity> pagination;

  const SubscriptionPostsList({super.key, required this.pagination});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        key: PageStorageKey('homePage_postsListView_key'),
        itemCount: pagination.list.length + 1,
        itemBuilder: (context, index) {
          if (index == pagination.list.length) {
            if (!pagination.hasMoreToLoad) {
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

          return _listTile(
            context: context,
            index: index,
            pagination: pagination,
          );
        },
      ),
    );
  }

  Widget _listTile({
    required BuildContext context,
    required int index,
    required Pagination<PostEntity> pagination,
  }) {
    var post = pagination.list[index];

    return Padding(
      key: ValueKey(post.id),
      padding: const EdgeInsets.only(bottom: 40.0),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>(
            create: (context) => PostBloc.getLikesCount(
              postEntity: post,
              postRepository: context.read<PostRepository>(),
            ),
          ),
          BlocProvider<CommentsBloc>(
            create: (context) => CommentsBloc.getComments(
              commentRepository: context.read<PostRepository>(),
              postId: post.id.toString(),
              postOwnerId: post.userEntity.id,
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
