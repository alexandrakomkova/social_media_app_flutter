import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/presentation/pages/post/bloc/comments/comments_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/post/post_bloc.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';

class PostCard extends StatelessWidget {
  final PostEntity postEntity;
  final void Function()? onCommentsPressed;

  const PostCard({required this.postEntity, this.onCommentsPressed, super.key});

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
                _userHeader(entity: state.postEntity),
                _postImage(imageUrl: state.postEntity.imageUrl),
                _postInfo(context: context, state: state),
                _description(description: state.postEntity.description),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _userHeader({required PostEntity entity}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfileAvatar(radius: 20.0, userEntity: entity.userEntity),
          const SizedBox(width: 10.0),
          Text(entity.userEntity.username, style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }

  Widget _postImage({required String imageUrl}) {
    return SizedBox(child: CachedNetworkImage(imageUrl: imageUrl));
  }

  Widget _postInfo({required BuildContext context, required PostState state}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            state.postEntity.formattedCreationTimestamp,
            style: const TextStyle(fontSize: 14.0),
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
                    commentState.comments.length.toString(),
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

  Widget _description({required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        description,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
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
