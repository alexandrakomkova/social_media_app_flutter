import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity postEntity;

  const PostCard({
    required this.postEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // post image
        SizedBox(
          // height: MediaQuery.of(context).size.height * 0.5,
          // width: MediaQuery.of(context).size.height * 0.5,
          child: CachedNetworkImage(
            imageUrl: postEntity.imageUrl,
          ),
        ),
        const SizedBox(height: 10.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // date
              Text(
                postEntity.formattedCreationTimestamp,
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(width: 8.0),
              // like button
               Icon(
                 Icons.favorite,
                 color: Colors.redAccent,
                 size: 22.0,
               ),
              // likes count
              Text(
                '81',
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),

        // description
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Text(
            postEntity.description,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
