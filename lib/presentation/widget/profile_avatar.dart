import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final String username;
  final String photoUrl;

  const ProfileAvatar({
    required this.radius,
    required this.username,
    required this.photoUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return photoUrl.isEmpty
        ? CircleAvatar(
            radius: radius,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Center(
              child: Text(
                username.isEmpty ? '?' : username[0].toUpperCase(),
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
            backgroundImage: RegExp(r'http').hasMatch(photoUrl)
                ? CachedNetworkImageProvider(photoUrl)
                : FileImage(File(photoUrl)),
          );
  }
}
