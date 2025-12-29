import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/user_entity.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final UserEntity userEntity;

  const ProfileAvatar({
    required this.radius,
    required this.userEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: userEntity.photoUrl.isEmpty
          ? CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context)
            .colorScheme
            .secondary,
        child: Center(
          child: Text(
            userEntity.username.isEmpty ? '?' : userEntity.username[0].toUpperCase(),
            //userEntity.username[0].toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: radius * 30 / 100,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      )
        : CircleAvatar(
            radius: radius,
            backgroundImage:
              RegExp(r'http').hasMatch(userEntity.photoUrl)
                  ? CachedNetworkImageProvider(
                      userEntity.photoUrl,
                    )
                  : FileImage(
                      File(userEntity.photoUrl),
              ),
      ),
    );
  }
}
