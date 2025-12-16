import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:sqflite/sqflite.dart';

final _log = Logger('DbProvider');
class DbProvider {
  DbProvider._();

  static final DbProvider db = DbProvider._();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");

    _log.info('local db is initialized');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE User (id TEXT PRIMARY KEY, email TEXT, username TEXT, bio TEXT, photoUrl TEXT, creationTime INTEGER)");
        });
  }

  Future<UserEntity> getClient(String id) async {
    final db = await database;
    var res = await db?.query("User", where: "id = ?", whereArgs: [id]);
    return res != null ? UserEntity.fromMap(res.first) : UserEntity();
  }

  Future<int?>? newUser(UserEntity newUser) async {
    final db = await database;
    debugPrint(newUser.toMap().toString());
    var res = await db?.insert("User", newUser.toMap());

    _log.info('new user is: ${newUser.id}');
    return res;
  }

  Future<int> updateUser(UserEntity newUser) async {
    final db = await database;
    var res = await db?.update("User", newUser.toMap(),
        where: "id = ?", whereArgs: [newUser.id]);
    return res ?? -1;
  }

  Future<int> deleteUser(String id) async {
    final db = await database;
    final res = await db?.delete("User", where: "id = ?", whereArgs: [id]);
    _log.info('user info deleted from local db (id: $id)');
    return res ?? 0;
  }
}