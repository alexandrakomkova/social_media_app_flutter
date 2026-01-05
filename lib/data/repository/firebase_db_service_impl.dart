import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/domain/model/notification_entity.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/utils/firebase_service.dart';
import 'package:social_media_app/utils/image_loader.dart';
import 'package:social_media_app/utils/result.dart';

final _log = Logger('FirebaseDbServiceImpl');

class FirebaseDbServiceImpl implements DbService {
  final firestore = FirebaseFirestore.instance;
  late final _usersRef = firestore.collection('users');
  late final _userTokenCollection = 'userToken';
  late final _postsRef = firestore.collection('posts');
  late final _likesRef = firestore.collection('likes');
  late final _commentsRef = firestore.collection('comments');
  late final _followersRef = firestore.collection('followers');
  late final _followingsRef = firestore.collection('followings');
  late final _userFollowersCollection = 'userFollowers';
  late final _userFollowingsCollection = 'userFollowings';
  late final _notificationsRef = firestore.collection('notifications');
  late final _userNotificationCollection = 'userNotification';

  @override
  Future<void> createUser({
    required User user,
    required UserModel userModel,
  }) async {
    await _usersRef.doc(user.uid).set({
      'id': user.uid,
      'username': userModel.username,
      'email': userModel.email,
      'creationTime': userModel.creationTimestamp,
      'bio': '',
      'photoUrl': '',
    });

    _saveFcmToken(userId: user.uid);
  }

  Future<void> _saveFcmToken({required String userId}) async {
    final String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      var tokens = _usersRef
          .doc(userId)
          .collection(_userTokenCollection)
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    }
  }

  @override
  Future<Result<UserEntity>> getUserById({required String id}) async {
    try {
      final docSnap = await _usersRef
          .doc(id)
          .withConverter(
            fromFirestore: UserEntity.fromFirestore,
            toFirestore: (UserEntity userEntity, _) => userEntity.toFirestore(),
          )
          .get();

      final userEntity = docSnap.data();

      return Result.ok(userEntity ?? UserEntity());
    } on Exception catch (e) {
      _log.warning('getUserById error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<UserEntity>>> searchUserByUsername({
    required String username,
  }) async {
    try {
      final querySnapshot = await _usersRef
          .where('username', isGreaterThanOrEqualTo: username)
          .where('username', isLessThanOrEqualTo: '$username\uf7ff')
          .get();

      List<UserEntity> foundUsers = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserEntity(
          id: data['id'],
          username: data['username'],
          email: data['email'],
          bio: data['bio'],
          creationTimestamp: data['creationTimestamp'],
          photoUrl: data['photoUrl'],
        );
      }).toList();

      return Result.ok(foundUsers);
    } on Exception catch (e) {
      _log.warning('searchUserByUsername error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> createPost({
    required File image,
    required String description,
  }) async {
    try {
      final int creationTimestamp = DateTime.now().millisecondsSinceEpoch;
      final String imageUrl = await ImageLoader.getImageUrl(
        image,
        creationTimestamp.toString(),
      );
      if (imageUrl.isEmpty) {
        return Result.error(Exception());
      }

      await _postsRef.doc(creationTimestamp.toString()).set({
        'creationTimestamp': creationTimestamp,
        'description': description,
        'imageUrl': imageUrl,
        'userInfo': _usersRef.doc(FirebaseService.currentUserId),
        'userId': FirebaseService.currentUserId,
      });

      _log.info('createPost success image loaded: $imageUrl');

      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('createPost error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<PostEntity>>> getUserPosts({
    required String userId,
  }) async {
    try {
      final querySnapshot = await _postsRef
          .where('userId', isEqualTo: userId)
          .get();
      List<PostEntity> posts = await _getPostEntitiesFromQuery(querySnapshot);
      return Result.ok(posts);
    } on Exception catch (e) {
      _log.warning('getUserPosts error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> updateUserInfo({
    required String imageUrl,
    required String username,
    required String bio,
  }) async {
    try {
      final int creationTimestamp = DateTime.now().millisecondsSinceEpoch;

      String url = await _getImageUrl(imageUrl, creationTimestamp.toString());
      _log.info('_getImageUrl $url');
      _log.info('updateUserInfo current id: ${FirebaseService.currentUserId}');

      await _usersRef.doc(FirebaseService.currentUserId).update({
        'username': username,
        'bio': bio,
        'photoUrl': url,
      });
      _log.info('updateUserInfo success');

      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('updateUserInfo error: $e');
      return Result.error(e);
    }
  }

  Future<String> _getImageUrl(String imageUrl, String imageId) async {
    if (imageUrl.isNotEmpty) {
      if (RegExp(r'http').hasMatch(imageUrl)) {
        return imageUrl;
      } else {
        return await ImageLoader.getImageUrl(File(imageUrl), imageId);
      }
    }

    return '';
  }

  @override
  Future<Result<({int likesCount, bool isLiked})>> getLikesInfo({
    required String postId,
  }) async {
    try {
      final querySnapshot = await _likesRef
          .where('postId', isEqualTo: postId)
          .get();
      int likesCount = querySnapshot.docs.length;
      bool isLiked =
          querySnapshot.docs.any(
            (doc) => doc['userId'] == FirebaseService.currentUserId,
          )
          ? true
          : false;

      _log.info(
        'getLikesInfo success {likeCount: $likesCount, isLiked: $isLiked}',
      );

      return Result.ok((likesCount: likesCount, isLiked: isLiked));
    } on Exception catch (e) {
      _log.warning('getLikesInfo error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> addLike({
    required String postId,
    required String postOwnerId,
  }) async {
    try {
      await _likesRef.add({
        'userId': FirebaseService.currentUserId,
        'postId': postId,
        'date': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      await addNotification(
        postId: postId,
        ownerId: postOwnerId,
        type: NotificationType.like,
      );

      _log.info('addLike success');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('addLike error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> removeLike({required String postId}) async {
    try {
      final querySnapshot = await _likesRef
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: FirebaseService.currentUserId)
          .get();

      for (var docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.delete();
      }

      _log.info('removeLike success');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('removeLike error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> addComment({
    required String postId,
    required String commentText,
    required String postOwnerId,
  }) async {
    try {
      await _commentsRef.add({
        'postId': postId,
        'userInfo': _usersRef.doc(FirebaseService.currentUserId),
        'commentText': commentText,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      await addNotification(
        postId: postId,
        ownerId: postOwnerId,
        type: NotificationType.comment,
      );

      _log.info('addComment success');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('addComment error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<CommentEntity>>> getComments({
    required String postId,
  }) async {
    List<CommentEntity> comments = [];
    try {
      await _commentsRef
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true)
          .get()
          .then((querySnapshot) async {
            for (var docSnapshot in querySnapshot.docs) {
              // _log.info('${docSnapshot.id} => ${docSnapshot.data()}');
              var data = docSnapshot.data();

              var userRef = data['userInfo'] as DocumentReference;

              var userDoc = await userRef.get();
              if (userDoc.exists) {
                if (userDoc.data() == null) {
                  return Result.ok([]);
                }
                var user = userDoc.data() as dynamic;

                comments.add(
                  CommentEntity(
                    postId: data['postId'],
                    commentText: data['commentText'],
                    userEntity: UserEntity(
                      id: user['id'],
                      username: user['username'],
                      email: user['email'],
                      bio: user['bio'],
                      creationTimestamp: user['creationTimestamp'],
                      photoUrl: user['photoUrl'],
                    ),
                    createdAt: data['createdAt'],
                  ),
                );
              }
            }
          });

      _log.info('getComments success commentsList length: ${comments.length}');

      return Result.ok(comments);
    } on Exception catch (e) {
      _log.warning('getComments error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<void> followUser({
    required String userId,
    required String userIdToFollow,
  }) async {
    try {
      Future.wait([
        _followersRef
            .doc(userIdToFollow)
            .collection(_userFollowersCollection)
            .doc(userId)
            .set({'userInfo': _usersRef.doc(userId)}),
        _followingsRef
            .doc(userId)
            .collection(_userFollowingsCollection)
            .doc(userIdToFollow)
            .set({'userInfo': _usersRef.doc(userIdToFollow)}),
      ]);

      await addNotification(
        ownerId: userIdToFollow,
        type: NotificationType.follow,
      );
    } on Exception catch (e) {
      _log.warning('followUser error: $e');
    }
  }

  @override
  Future<void> unfollowUser({
    required String userId,
    required String userIdToUnfollow,
  }) async {
    try {
      await Future.wait([
        _followersRef
            .doc(userIdToUnfollow)
            .collection(_userFollowersCollection)
            .doc(userId)
            .delete(),
        _followingsRef
            .doc(userId)
            .collection(_userFollowingsCollection)
            .doc(userIdToUnfollow)
            .delete(),
      ]);

      await addNotification(
        postId: '',
        ownerId: userIdToUnfollow,
        type: NotificationType.unfollow,
      );
    } catch (e) {
      _log.warning('unfollowUser error: $e');
    }
  }

  Future<List<UserEntity>> _getUserEntitiesFromQuery(
    QuerySnapshot querySnapshot,
  ) async {
    List<UserEntity> users = [];
    for (var docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data() as dynamic;
      var userRef = data['userInfo'] as DocumentReference;
      final userDoc = await userRef.get();

      if (userDoc.exists) {
        var userData = userDoc.data() as dynamic;

        users.add(
          UserEntity(
            id: userData['id'],
            username: userData['username'],
            email: userData['email'],
            bio: userData['bio'],
            creationTimestamp: userData['creationTimestamp'],
            photoUrl: userData['photoUrl'],
          ),
        );
      }
    }
    return users;
  }

  @override
  Future<Result<List<UserEntity>>> getFollowers({
    required String userId,
  }) async {
    try {
      final followersSnapshot = await _followersRef
          .doc(userId)
          .collection(_userFollowersCollection)
          .get();
      if (followersSnapshot.docs.isEmpty) return Result.ok([]);
      List<UserEntity> followers = await _getUserEntitiesFromQuery(
        followersSnapshot,
      );

      _log.info(
        'getFollowers success followerList length: ${followers.length}',
      );
      return Result.ok(followers);
    } on Exception catch (e) {
      _log.warning('getFollowers error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<UserEntity>>> getFollowings({
    required String userId,
  }) async {
    try {
      final followingsSnapshot = await _followingsRef
          .doc(userId)
          .collection(_userFollowingsCollection)
          .get();
      if (followingsSnapshot.docs.isEmpty) return Result.ok([]);
      List<UserEntity> followings = await _getUserEntitiesFromQuery(
        followingsSnapshot,
      );

      _log.info(
        'getFollowings success followingsList length: ${followings.length}',
      );
      return Result.ok(followings);
    } on Exception catch (e) {
      _log.warning('getFollowings error: $e');
      return Result.error(e);
    }
  }

  Future<List<PostEntity>> _getPostEntitiesFromQuery(
    QuerySnapshot querySnapshot,
  ) async {
    List<PostEntity> posts = [];
    for (var docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data() as dynamic;
      var userRef = data['userInfo'] as DocumentReference;

      final userDoc = await userRef.get();
      if (userDoc.exists) {
        var userData = userDoc.data() as dynamic;
        posts.add(
          PostEntity(
            userEntity: UserEntity(
              id: userData['id'],
              username: userData['username'],
              email: userData['email'],
              bio: userData['bio'],
              creationTimestamp: userData['creationTimestamp'],
              photoUrl: userData['photoUrl'],
            ),
            userId: data['userId'],
            imageUrl: data['imageUrl'],
            description: data['description'],
            creationTimestamp: data['creationTimestamp'],
          ),
        );
      }
    }
    return posts;
  }

  @override
  Future<Result<List<PostEntity>>> getNewPosts({required String userId}) async {
    try {
      final followingsSnapshot = await _followingsRef
          .doc(userId)
          .collection(_userFollowingsCollection)
          .get();

      if (followingsSnapshot.docs.isEmpty) return Result.ok([]);

      List<String> followingUserIds = followingsSnapshot.docs
          .map((doc) => doc.id)
          .toList();
      final querySnapshot = await _postsRef
          .where('userId', whereIn: followingUserIds)
          .get();
      List<PostEntity> posts = await _getPostEntitiesFromQuery(querySnapshot);

      _log.info('getNewPosts success postList length: ${posts.length}');
      return Result.ok(posts);
    } on Exception catch (e) {
      _log.warning('getNewPosts error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> isFollowedByCurrentUser({
    required String profileOwnerUserId,
  }) async {
    try {
      final querySnapshot = await _followingsRef
          .doc(FirebaseService.currentUserId)
          .collection(_userFollowingsCollection)
          .get();

      bool isFollowed = querySnapshot.docs.any(
        (docSnapshot) => docSnapshot.id == profileOwnerUserId,
      );
      _log.info('isFollowedByCurrentUser success isFollowed: $isFollowed');
      return Result.ok(isFollowed);
    } on Exception catch (e) {
      _log.warning('isFollowedByCurrentUser error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<NotificationEntity>>> getNotifications({
    required String userId,
  }) async {
    try {
      final notificationsSnapshot = await _notificationsRef
          .doc(userId)
          .collection(_userNotificationCollection)
          .orderBy('creationTimestamp', descending: true)
          .get();

      if (notificationsSnapshot.docs.isEmpty) return Result.ok([]);
      List<NotificationEntity> notifications = [];

      for (var docSnapshot in notificationsSnapshot.docs) {
        final data = docSnapshot.data() as dynamic;
        var userRef = data['userInfo'] as DocumentReference;

        final userDoc = await userRef.get();
        if (userDoc.exists) {
          final userData = userDoc.data() as dynamic;

          //_log.info('${userDoc.id} => $userData');

          notifications.add(
            NotificationEntity(
              userEntity: UserEntity(
                id: userData['id'],
                username: userData['username'],
                email: userData['email'],
                bio: userData['bio'],
                creationTimestamp: userData['creationTimestamp'],
                photoUrl: userData['photoUrl'],
              ),
              postId: data['postId'],
              type: data['type'].toString().toNotificationType,
              creationTimestamp: data['creationTimestamp'],
            ),
          );
        }
      }

      _log.info(
        'getNotifications success notificationList length: ${notifications.length}',
      );
      return Result.ok(notifications);
    } on Exception catch (e) {
      _log.warning('getNotifications error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> addNotification({
    String? postId,
    required String ownerId,
    required NotificationType type,
  }) async {
    try {
      await _notificationsRef
          .doc(ownerId)
          .collection(_userNotificationCollection)
          .add({
            'postId': postId,
            'userInfo': _usersRef.doc(FirebaseService.currentUserId),
            'type': type.typeName,
            'creationTimestamp': DateTime.now().millisecondsSinceEpoch,
          });

      _log.info('addNotification success');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('addNotification error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> deleteAllNotifications({required String userId}) async {
    try {
      final notificationSnapshot = await _notificationsRef
          .doc(userId)
          .collection(_userNotificationCollection)
          .get();

      for (var doc in notificationSnapshot.docs) {
        await doc.reference.delete();
      }

      _log.info('deleteAllNotifications success');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('deleteAllNotifications error: $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<PostEntity?>> getUserPost({required String postId}) async {
    try {
      final postSnapshot = await _postsRef.doc(postId).get();
      if (!postSnapshot.exists) {
        return Result.error(Exception('No post found'));
      }

      final postData = postSnapshot.data() as dynamic;
      var userRef = postData['userInfo'] as DocumentReference;

      final userDoc = await userRef.get();
      if (userDoc.exists) {
        final userData = userDoc.data() as dynamic;
        final postEntity = PostEntity(
          imageUrl: postData['imageUrl'],
          creationTimestamp: postData['creationTimestamp'],
          description: postData['description'],
          userId: userData['id'],
          userEntity: UserEntity(
            email: userData['email'],
            username: userData['username'],
            bio: userData['bio'],
            creationTimestamp: userData['creationTimestamp'],
            photoUrl: userData['photoUrl'],
          ),
        );

        return Result.ok(postEntity);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('getUserPost error: $e');
      return Result.error(e);
    }
  }
}

extension on String {
  NotificationType get toNotificationType {
    switch (this) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'follow':
        return NotificationType.follow;
      case 'unfollow':
        return NotificationType.unfollow;
      default:
        return NotificationType.unknown;
    }
  }
}
