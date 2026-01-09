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
          ProfileState$Success() => NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200 &&
                  state.hasMorePosts) {
                context.read<ProfileBloc>().add(
                  ProfileEvent.getUserPostsNext(userId: userId),
                );
              }
              return false;
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    ...buildRows(context: context),
                    if (!state.hasMorePosts)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(context.l10n.noMorePostsText),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        };
      },
    );
  }

  List<Widget> buildRows({required BuildContext context}) {
    final state = context.watch<ProfileBloc>().state;
    List<Widget> rows = [];

    for (int i = 0; i < state.posts.length; i += 3) {
      final rowPosts = state.posts.skip(i).take(3).toList();
      rows.add(
        Row(
          children: List.generate(3, (j) {
            return Flexible(
              child: j < rowPosts.length
                  ? AspectRatio(
                      aspectRatio: 1,
                      child: ProfilePostTile(postEntity: rowPosts[j]),
                    )
                  : const SizedBox.shrink(),
            );
          }),
        ),
      );
    }
    return rows;
  }
}
