import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:sqflite/sqflite.dart';

final _log = Logger('DbProvider');

class DbProvider {
  DbProvider._();

  static final DbProvider db = DbProvider._();

  late Database _database;

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");

    final Database db = await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE User (id TEXT PRIMARY KEY, email TEXT, username TEXT, bio TEXT, photoUrl TEXT, creationTime INTEGER)",
        );
      },
    );
    _database = db;
    _log.info('_database is initialized via initDb');
    return db;
  }

  Future<UserEntity> getClient(String id) async {
    final db = _database;
    var res = await db.query("User", where: "id = ?", whereArgs: [id]);

    _log.info('get user info: $id (res: $res)');
    return UserEntity.fromMap(res.first);
  }

  Future<int?>? newUser(UserEntity newUser) async {
    final db = _database;
    var res = await db.insert("User", newUser.toMap());

    _log.info('new user is: ${newUser.id} (res: $res)');
    return res;
  }

  Future<int> updateUser(UserEntity newUser) async {
    final db = _database;
    var res = await db.update(
      "User",
      newUser.toMap(),
      where: "id = ?",
      whereArgs: [newUser.id],
    );
    _log.info('user info updated (id: ${newUser.id}) (res: $res)');
    return res;
  }

  Future<int> deleteUser(String id) async {
    final db = _database;
    final res = await db.delete("User", where: "id = ?", whereArgs: [id]);

    _log.info('user info deleted from local db (id: $id) (res: $res)');
    return res;
  }
}
