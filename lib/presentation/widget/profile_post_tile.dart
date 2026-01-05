import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/post/post_page.dart';

class ProfilePostTile extends StatelessWidget {
  final PostEntity postEntity;

  const ProfilePostTile({required this.postEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PostPage(postEntity: postEntity)),
        );
      },
      child: SizedBox(
        height: 100,
        width: 150,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            child: CachedNetworkImage(
              imageUrl: postEntity.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(
                child: Text(
                  context.l10n.unableToLoadImageText,
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
