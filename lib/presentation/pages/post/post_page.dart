import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/post_entity.dart';

class PostPage extends StatelessWidget {
  final PostEntity postEntity;

  const PostPage({
    required this.postEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _PostView(postEntity: postEntity,);
  }
}

class _PostView extends StatelessWidget {
  final PostEntity postEntity;

  const _PostView({
    required this.postEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            children: [
              // post
              _postInfo(context, postEntity),
              Divider(),
              // comments section

              // adding comment
            ],
          ),
    );
  }
}


Widget _postInfo(BuildContext context, PostEntity postEntity) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.height * 0.5,
        child: CachedNetworkImage(
            imageUrl: postEntity.imageUrl
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
                  postEntity.description, //state.description
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  postEntity.formattedCreationTimestamp, // state.creationTimestamp in dd/MM/YYYY
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                    Icons.favorite_border,
                  size: 26.0,
                ),
                Text(
                  '322', // state.likes count or smth like that
                ),
              ],
            )
          ],
        ),
      ),

    ],
  );
}
