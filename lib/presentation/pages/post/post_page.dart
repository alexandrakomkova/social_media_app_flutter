import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/post_repository_impl.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/presentation/pages/post/bloc/comments/comments_bloc.dart';
import 'package:social_media_app/presentation/pages/post/bloc/post/post_bloc.dart';

class PostPage extends StatelessWidget {
  final PostEntity postEntity;

  const PostPage({
    required this.postEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>(
            create: (context) => PostBloc.getLikesCount(
              postEntity: postEntity,
              postRepository: context.read<PostRepositoryImpl>()
            )
          ),
          BlocProvider<CommentsBloc>(
              create: (context) => CommentsBloc.getComments(
                commentRepository: context.read<PostRepositoryImpl>(),
                postId: postEntity.id.toString(),
              )
          ),
        ],
        child: _PostView()
    );
  }
}

class _PostView extends StatelessWidget {

  const _PostView({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            children: [
              // post
              _postInfo(context),
              Divider(),
              // comments section

              // adding comment
            ],
          ),
    );
  }
}


Widget _postInfo(BuildContext context) {
  return BlocBuilder<PostBloc, PostState>(
  builder: (context, state) {
    return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.height * 0.5,
        child: CachedNetworkImage(
            imageUrl: state.postEntity.imageUrl
        ), //state.imageUrl
      ),
      SizedBox(height: 20.0,),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.postEntity.description, //state.description
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  state.postEntity.formattedCreationTimestamp, // state.creationTimestamp in dd/MM/YYYY
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(state.isLiked ? Icons.favorite : Icons.favorite_border),
                      color: state.isLiked ? Colors.redAccent : Colors.grey,
                      iconSize: 25.0,
                      onPressed: () {
                        // context.read<PostBloc>().add(PostEvent.);
                      },
                    );
                  },
                ),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    return Text(
                      state.likesCount.toString(),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),

    ],
  );
  },
);
}
