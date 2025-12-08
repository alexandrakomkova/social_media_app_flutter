
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/utils/firebase_utils.dart';
import 'package:social_media_app/utils/image_loader.dart';
import 'package:social_media_app/utils/result.dart';

class FirebaseDbServiceImpl implements DbService {
  final firestore = FirebaseFirestore.instance;
  late final _usersRef = firestore.collection('users');
  late final _postsRef = firestore.collection('posts');
  late final _likesRef = firestore.collection('likes');
  late final _commentsRef = firestore.collection('comments');
  late final _followersRef = firestore.collection('followers');
  late final _followingsRef = firestore.collection('followings');
  late final _userFollowersCollection = 'userFollowers';
  late final _userFollowingsCollection = 'userFollowings';

  @override
  Future<void> createUser(User user, UserModel userModel) async {
    await _usersRef.doc(user.uid).set({
      'id': user.uid,
      'username': userModel.username,
      'email': userModel.email,
      'creationTime': userModel.creationTimestamp,
      'bio': '',
      'photoUrl': '',
    });
  }

  @override
  Future<Result<UserEntity>> getUserById(String? id) async {
    try {
      var userRef = await _usersRef.doc(id).withConverter(
          fromFirestore: UserEntity.fromFirestore,
          toFirestore: (UserEntity userEntity, _) => userEntity.toFirestore(),
      );
      final docSnap = await userRef.get();
      final userEntity = docSnap.data();

      return Result.ok(userEntity ?? UserEntity());
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<UserEntity>>> searchUserByUsername({required String username}) async {
    List<UserEntity> foundUsers = [];

    try {
      await _usersRef.where('username', isGreaterThanOrEqualTo: username)
          .where("username", isLessThanOrEqualTo: "$username\uf7ff")
          .get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            // debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
            var data = docSnapshot.data();

            foundUsers.add(UserEntity(
              id: data['id'],
              username: data['username'],
              email: data['email'],
              bio: data['bio'],
              creationTimestamp: data['creationTimestamp'],
              photoUrl: data['photoUrl'],
            ));
          }
        }
      );
      return Result.ok(foundUsers);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> createPost({required File image, required String description}) async {
    try {
      final int creationTimestamp = DateTime.now().millisecondsSinceEpoch;
      final String imageUrl = await ImageLoader.getImageUrl(image, creationTimestamp.toString());
      if(imageUrl.isEmpty) { return Result.error(Exception()); }

      await _postsRef.doc(creationTimestamp.toString()).set({
        'creationTimestamp': creationTimestamp,
        'description': description,
        'imageUrl': imageUrl,
        "userId": FirebaseUtils.currentUserId,
      });

      //debugPrint('loaded ${imageUrl}');

      return Result.ok('');
    } on Exception catch(e) {
      //debugPrint('--- FirebaseDbServiceImpl createPost ${e.toString()}');
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<PostEntity>>> getUserPosts({required String userId}) async {
    List<PostEntity> posts = [];
    try {
      await _postsRef.where('userId', isEqualTo: userId)
          .get().then(
              (querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              //debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
              var data = docSnapshot.data();

              posts.add(PostEntity(
                userId: data['userId'],
                imageUrl: data['imageUrl'],
                description: data['description'],
                creationTimestamp: data['creationTimestamp']
              ));
            }
          }
      );

      return Result.ok(posts);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> updateUserInfo(String imageUrl, String username, String bio)  async {
    //debugPrint('--- FirebaseDbServiceImpl updateUserInfo');
    try {

      final int creationTimestamp = DateTime.now().millisecondsSinceEpoch;

      String url = await _getImageUrl(imageUrl, creationTimestamp.toString());

        //debugPrint('--- FirebaseDbServiceImpl updateUserInfo $url');

        await _usersRef.doc(FirebaseUtils.currentUserId).update({
          'username': username,
          'bio': bio,
          'photoUrl': url,
        });
        //debugPrint('--- FirebaseDbServiceImpl updateUserInfo success');

        return Result.ok('');
    } on Exception catch(e) {
      //debugPrint('--- FirebaseDbServiceImpl updateUserInfo ${e.toString()}');
      return Result.error(e);
    }
  }

  Future<String> _getImageUrl(String imageUrl, String imageId) async {
    if (imageUrl.isNotEmpty) {
      if(RegExp(r'http').hasMatch(imageUrl)) {
        return imageUrl;
      } else {
        return await ImageLoader.getImageUrl(File(imageUrl), imageId);
      }
    }

    return '';
  }

  @override
  Future<Result<Map<String, int>>> getLikesInfo({required String postId}) async {
    int likesCount = 0;
    int isLiked = 0;

    try {
      await _likesRef
          .where('postId', isEqualTo: postId)
          .get()
          .then(
              (querySnapshot) {
                likesCount = querySnapshot.docs.length;

                for (var docSnapshot in querySnapshot.docs) {
                  var data = docSnapshot.data();
                  if(data['userId'] == FirebaseUtils.currentUserId) {
                    isLiked = 1;
                  }
                }
      });

      //debugPrint('--- $likesCount $isLiked');
      return Result.ok({'likesCount': likesCount, 'isLiked': isLiked});
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> addLike({required String postId}) async {
    try {
      await _likesRef.add({
        'userId': FirebaseUtils.currentUserId,
        'postId': postId,
        'date': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      //debugPrint('--- FirebaseDbServiceImpl addLike success');
      return Result.ok('');
    } on Exception catch (e) {
      //debugPrint('--- FirebaseDbServiceImpl addLike $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> removeLike({required String postId}) async {
    try {
      await _likesRef
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: FirebaseUtils.currentUserId)
          .get()
          .then(
              (querySnapshot) {
                for (var docSnapshot in querySnapshot.docs) {
                  docSnapshot.reference.delete();
                }
          });

      debugPrint('--- FirebaseDbServiceImpl removeLike success');
      return Result.ok('');
    } on Exception catch (e) {
      debugPrint('--- FirebaseDbServiceImpl removeLike $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> addComment({required String postId, required String commentText}) async {
    try {
      final user = await DbProvider.db.getClient(FirebaseUtils.currentUserId);

      await _commentsRef.add({
        'postId': postId,
        'userInfo': _usersRef.doc(user.id),
        'commentText': commentText,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      return Result.ok('');
    } on Exception catch(e) {
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
          debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
          var data = docSnapshot.data();

          var userRef = data['userInfo'] as DocumentReference;

          var userDoc = await userRef.get();
          if(userDoc.exists) {

            if(userDoc.data() == null) {
              return Result.ok([]);
            }
            var user = userDoc.data() as dynamic;

            comments.add(CommentEntity(
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
            ));
          }
        }
      }
      );

      return Result.ok(comments);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<void> followUser({required String userId, required String userIdToFollow}) async {
    try {
      await _followersRef
          .doc(userIdToFollow)
          .collection(_userFollowersCollection)
          .doc(userId)
          .set({
        'userInfo': _usersRef.doc(userId)
      });

      await _followingsRef
          .doc(userId)
          .collection(_userFollowingsCollection)
          .doc(userIdToFollow)
          .set({
        'userInfo': _usersRef.doc(userIdToFollow)
      });

    } on Exception catch(e) {
      debugPrint('--- FirebaseDbServiceImpl followUser ${e.toString()}');
    }
  }

  @override
  Future<void> unfollowUser({required String userId, required String userIdToUnfollow}) async {
    try {
      await _followersRef
          .doc(userIdToUnfollow)
          .collection(_userFollowersCollection)
          .doc(userId)
          .delete();

      await _followingsRef
          .doc(userId)
          .collection(_userFollowingsCollection)
          .doc(userIdToUnfollow)
          .delete();
    } on Exception catch(e) {
      debugPrint('--- FirebaseDbServiceImpl unfollowUser ${e.toString()}');
    }
  }

  @override
  Future<Result<List<UserEntity>>> getFollowers({required String userId}) async {
    List<UserEntity> followers = [];
    try {
      await _followersRef
          .doc(userId)
          .collection(_userFollowersCollection)
          .get()
          .then((querySnapshot) async {
            for (var docSnapshot in querySnapshot.docs) {
              debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
              var data = docSnapshot.data();
              var userRef = data['userInfo'] as DocumentReference;

              var userDoc = await userRef.get();
              if(userDoc.exists) {

                if(userDoc.data() == null) {
                  return Result.ok([]);
                }
                var user = userDoc.data() as dynamic;

                followers.add(UserEntity(
                  id: user['id'],
                  username: user['username'],
                  email: user['email'],
                  bio: user['bio'],
                  creationTimestamp: user['creationTimestamp'],
                  photoUrl: user['photoUrl'],
                ));
              }
            }
      });

      return Result.ok(followers);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<UserEntity>>> getFollowings({required String userId}) async {
    List<UserEntity> followings = [];
    try {
      await _followingsRef
          .doc(userId)
          .collection(_userFollowingsCollection)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
          var data = docSnapshot.data();
          var userRef = data['userInfo'] as DocumentReference;

          var userDoc = await userRef.get();
          if(userDoc.exists) {
            if (userDoc.data() == null) {
              return Result.ok([]);
            }
            var user = userDoc.data() as dynamic;

            followings.add(UserEntity(
              id: user['id'],
              username: user['username'],
              email: user['email'],
              bio: user['bio'],
              creationTimestamp: user['creationTimestamp'],
              photoUrl: user['photoUrl'],
            ));
          }
        }
      });

      return Result.ok(followings);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<PostEntity>>> getNewPosts({required String userId}) async {
    List<PostEntity> posts = [];
    List<String> followingUserIds = [];
    try {
      var followingsSnapshot = await _followingsRef
          .doc(userId)
          .collection(_userFollowingsCollection)
          .get();
      debugPrint('--- FirebaseDbServiceImpl getNewPosts ${followingsSnapshot.docs.length}');

      for (var doc in followingsSnapshot.docs) {
        followingUserIds.add(doc.id);
      }

      if(followingUserIds.isEmpty) { return Result.ok([]); }

      debugPrint('--- FirebaseDbServiceImpl getNewPosts ${followingUserIds.length}');

      await _postsRef.where('userId', whereIn: followingUserIds)
          .get().then(
              (querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
              var data = docSnapshot.data();

              posts.add(PostEntity(
                  userId: data['userId'],
                  imageUrl: data['imageUrl'],
                  description: data['description'],
                  creationTimestamp: data['creationTimestamp']
              ));
            }
          }
      );
      return Result.ok(posts);
    } on Exception catch(e) {
      debugPrint('--- FirebaseDbServiceImpl getNewPosts error $e');
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> isFollowedByCurrentUser({required String profileOwnerUserId}) async {
    bool isFollowed = false;
    try {
      await _followingsRef
          .doc(FirebaseUtils.currentUserId)
          .collection(_userFollowingsCollection)
          .get()
          .then((querySnapshot) async {
            for (var docSnapshot in querySnapshot.docs) {
              if(docSnapshot.id == profileOwnerUserId) {
                isFollowed = true;
                break;
              }
            }
          });

      debugPrint('--- FirebaseDbServiceImpl isFollowedByCurrentUser $isFollowed');
      return Result.ok(isFollowed);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }
}