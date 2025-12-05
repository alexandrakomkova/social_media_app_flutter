import 'package:flutter/foundation.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/search_repository.dart';
import 'package:social_media_app/utils/result.dart';

class SearchRepositoryImpl implements SearchRepository {
  final DbService _dbService;

  SearchRepositoryImpl({
    required DbService dbService,
  }): _dbService = dbService;

  @override
  Future<List<UserEntity>> searchUserByUsername({required String query}) async {
    final res = await _dbService.searchUserByUsername(username: query);
    switch (res) {
      case Ok<List<UserEntity>>():
        return res.value;
      case Error<List<UserEntity>>():
        debugPrint(res.error.toString());
        return [];
    }
  }

}