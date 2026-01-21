import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/presentation/pages/post/bloc/comments/comments_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/post/post_bloc.dart';
import 'package:social_media_app/presentation/pages/profile/profile_page.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';
import 'package:social_media_app/utils/datetime_formatter.dart';

class PostCard extends StatelessWidget {
  final PostEntity postEntity;
  final void Function()? onCommentsPressed;

  const PostCard({super.key, required this.postEntity, this.onCommentsPressed});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: BlocProvider.of<PostBloc>(context)),
        BlocProvider.value(value: BlocProvider.of<CommentsBloc>(context)),
      ],
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _userHeader(entity: state.postEntity, context: context),
                _postImage(imageUrl: state.postEntity.imageUrl),
                _postInfo(context: context),
                _description(
                  description: state.postEntity.description,
                  context: context,
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _userHeader({
    required PostEntity entity,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProfilePage(userId: entity.userId)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileAvatar(
              radius: 20.0,
              username: entity.userEntity.username,
              photoUrl: entity.userEntity.photoUrl,
            ),
            const SizedBox(width: 10.0),
            Text(
              entity.userEntity.username,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _postImage({required String imageUrl}) {
    return SizedBox(child: CachedNetworkImage(imageUrl: imageUrl));
  }

  Widget _postInfo({required BuildContext context}) {
    final state = context.watch<PostBloc>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateTimeFormatter(context: context).ddMMyyyyHHmm(
              dateTime: state.postEntity.creationTimestampDateTime,
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 8.0),

          Row(
            children: [
              _likeButton(context: context, isLiked: state.isLiked),
              Text(
                state.likesCount.toString(),
                style: const TextStyle(fontSize: 14.0),
              ),

              const SizedBox(width: 20.0),

              _commentButton(),
              BlocBuilder<CommentsBloc, CommentsState>(
                builder: (_, commentState) {
                  return Text(
                    commentState.commentsCount.toString(),
                    style: const TextStyle(fontSize: 14.0),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _description({
    required String description,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        description,
        style: Theme.of(context).textTheme.titleMedium,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _likeButton({required BuildContext context, required bool isLiked}) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.redAccent : Colors.grey,
        size: 22.0,
      ),
      onPressed: () {
        context.read<PostBloc>().add(PostEvent.toggleLike(isLiked));
      },
    );
  }

  Widget _commentButton() {
    return IconButton(
      icon: Icon(
        Icons.chat_bubble_outline_rounded,
        color: Colors.grey,
        size: 22.0,
      ),
      onPressed: onCommentsPressed,
    );
  }
}
