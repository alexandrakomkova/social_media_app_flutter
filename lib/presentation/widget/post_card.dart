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

  const PostCard({
    required this.postEntity,
    this.onCommentsPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: BlocProvider.of<PostBloc>(context),),
        BlocProvider.value(value: BlocProvider.of<CommentsBloc>(context),),
      ],
      child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // profile avatar + username
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ProfileAvatar(
                              radius: 20.0,
                              userEntity: state.postEntity.userEntity,
                          ),
                          const SizedBox(width: 10.0,),
                          Text(
                            state.postEntity.userEntity.username,
                            style: TextStyle(
                              fontSize: 16.0
                            ),
                          ),
                        ],
                      ),
                    ),

                    // post image
                    SizedBox(
                      child: CachedNetworkImage(
                        imageUrl: state.postEntity.imageUrl,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // date
                          Text(
                            state.postEntity.formattedCreationTimestamp,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(width: 8.0),

                          Row(
                            children: [
                              // like button
                              IconButton(
                                icon: Icon(
                                  state.isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: state.isLiked ? Colors.redAccent : Colors.grey,
                                  size: 22.0,
                                ),
                                onPressed: () {
                                  context.read<PostBloc>().add(PostEvent.toggleLike(state
                                      .isLiked));
                                },
                              ),
                              // likes count
                              Text(
                                state.likesCount.toString(),
                                style: const TextStyle(fontSize: 14.0),
                              ),

                              const SizedBox(width: 20.0),
                              // comments icon
                              IconButton(
                                icon: Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: Colors.grey,
                                  size: 22.0,
                                ),
                                onPressed: onCommentsPressed,
                              ),

                              // comments count
                              BlocBuilder<CommentsBloc, CommentsState>(
                                builder: (_, state) {
                                  return Text(
                                   state.comments.length.toString(),
                                   style: const TextStyle(fontSize: 14.0),
                                  );
                                },
                              ),
                            ],
                          )

                        ],
                      ),
                    ),

                    // description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        state.postEntity.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Divider()
                  ],
                ),
              );
            },
          ),
    );
  }
}
