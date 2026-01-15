import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/pages/post/post_page.dart';
import 'package:social_media_app/presentation/pages/profile/profile_page.dart';

final _log = Logger('NotificationHandler');

class NotificationHandler {
  final GlobalKey<NavigatorState> navigatorKey;

  NotificationHandler(this.navigatorKey);

  void handleMessageData(dynamic rawData) {
    try {
      final data = _parseData(rawData);
      if (data == null) {
        _log.warning('Cannot parse notification data: $rawData');
        return;
      }
      final type = data['type'];
      if ((type == 'follow' || type == 'unfollow') && data['userId'] != null) {
        _handleUserNavigation(data['userId']);
      } else if ((type == 'comment' || type == 'like') &&
          data['postEntity'] != null) {
        _handlePostNavigation(data['postEntity']);
      }
    } catch (e, stack) {
      _log.warning('handleMessageData error: $e\n$stack');
    }
  }

  Map<String, dynamic>? _parseData(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        return decoded is Map<String, dynamic> ? decoded : null;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  void _handleUserNavigation(dynamic userId) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => ProfilePage(userId: userId)),
    );
    _log.info('Navigated to user: $userId');
  }

  void _handlePostNavigation(dynamic postRaw) {
    final postData = _parseData(postRaw);
    if (postData == null) {
      _log.warning('postEntity is not a Map or JSON: $postRaw');
      return;
    }
    final userData = postData['userEntity'];

    if (userData == null) {
      _log.warning('userData is not a Map or JSON: $postRaw');
      return;
    }

    final postEntity = PostEntity(
      imageUrl: postData['imageUrl'].toString(),
      description: postData['description'].toString(),
      creationTimestamp: int.parse(postData['creationTimestamp'].toString()),
      userId: postData['userId'].toString(),
      userEntity: UserEntity(
        bio: userData['bio'].toString(),
        id: userData['id'].toString(),
        email: userData['email'].toString(),
        photoUrl: userData['photoUrl'].toString(),
        username: userData['username'].toString(),
        creationTimestamp: int.parse(userData['creationTime'].toString()),
      ),
    );
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => PostPage(postEntity: postEntity)),
    );
    _log.info('Navigated to post: ${postEntity.description}');
  }
}
