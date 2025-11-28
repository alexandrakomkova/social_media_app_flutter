import 'package:flutter/foundation.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/utils/firebase_utils.dart';
import 'package:social_media_app/utils/result.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DbService _dbService;

  ProfileRepositoryImpl({
    required DbService dbService,
  }): _dbService = dbService;

  @override
  Future<List<PostEntity>> getUserPosts(String? userId) async {
    final res = await _dbService.getUserPosts(userId ?? FirebaseUtils.currentUser);

    switch(res) {
      case Ok<List<PostEntity>>():
        return res.value;
      case Error<List<PostEntity>>():
        debugPrint(res.error.toString());
        return [];
    }
  }

  @override
  Future<UserEntity?> getUserInfo(String? id) async {
    //debugPrint('id: $id userId: ${FirebaseAuth.instance.currentUser?.uid}');
    final res = await _dbService.getUserById(id ?? FirebaseUtils.currentUser);

    switch (res) {
      case Ok<UserEntity>():
      //debugPrint('--- ${res.value.email}');
        return res.value;
      case Error<UserEntity>():
      //debugPrint('--- exception');
        return null;
    }
  }

}