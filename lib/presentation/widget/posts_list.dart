import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:social_media_app/presentation/widget/custom_loader.dart';
import 'package:social_media_app/presentation/widget/profile_post_tile.dart';

class PostsList extends StatelessWidget {
  final String userId;

  const PostsList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return switch (state) {
          ProfileState$Idle() => SizedBox(),
          ProfileState$Processing() => CustomLoader(),
          ProfileState$Failed() => Center(
            child: Text(context.l10n.errorOccurredText(state.errorMessage)),
          ),
          ProfileState$Success() => _PostsListView(userId: userId),
        };
      },
    );
  }
}

class _PostsListView extends StatelessWidget {
  final String userId;

  const _PostsListView({required this.userId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileBloc>().state;

    if (state.pagination.list.isEmpty) {
      return _emptyList(context: context);
    }

    final rowCount = (state.pagination.list.length / 3).ceil();

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200 &&
            state.pagination.hasMoreToLoad) {
          context.read<ProfileBloc>().add(
            ProfileEvent.getUserPostsNext(userId: userId),
          );
        }
        return false;
      },
      child: Expanded(
        child: ListView.builder(
          // need to make text 'no more posts' a part of the this list
          itemCount: rowCount + 1,
          itemBuilder: (context, index) {
            if (index < rowCount) {
              final start = index * 3;
              final rowPosts = state.pagination.list
                  .skip(start)
                  .take(3)
                  .toList();
              return Row(
                children: List.generate(3, (colIdx) {
                  if (colIdx < rowPosts.length) {
                    return Flexible(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ProfilePostTile(postEntity: rowPosts[colIdx]),
                      ),
                    );
                  } else {
                    return const Flexible(child: SizedBox.shrink());
                  }
                }),
              );
            } else if (!state.pagination.hasMoreToLoad) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text(context.l10n.noMorePostsText)),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _emptyList({required BuildContext context}) {
    return Expanded(
      child: Center(child: Text(context.l10n.profilePageNoPosts)),
    );
  }
}
