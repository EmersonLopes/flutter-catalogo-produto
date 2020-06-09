import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "funny_sticker.db";
  static final _databaseVersion = 1;

  static final tbGifsLike = 'gifs_like';
  static final tbGifsMenu = 'gifs_menu';

  //region TABELA GIFS_LIKE
  static final colGifsLikeRowId = '_id';
  static final colGifsLikeCodigo = 'codigo';
  static final colGifsLikeTitle = 'title';
  static final colGifsLikeUrl = 'url';
  static final colGifsLikeHeight = 'height';
  static final colGifsLikeUserDisplayName = 'userDisplayName';
  static final colGifsLikeUserName = 'userName';
  static final colGifsLikeUserAvatarUrl = 'userAvatarUrl';
  static final colGifsLikeUserBannerUrl = 'userBannerUrl';

  //endregion

  //region TABELA GIFS_MENU
  static final colGifsMenuRowId = '_id';
  static final colGifsMenuUrl = 'url';
  static final colGifsMenuTitle = 'title';

  //endregion

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tbGifsLike (
            $colGifsLikeRowId INTEGER PRIMARY KEY,
            $colGifsLikeCodigo TEXT NOT NULL,
            $colGifsLikeTitle TEXT NOT NULL,
            $colGifsLikeUrl TEXT NOT NULL,
            $colGifsLikeHeight TEXT NOT NULL,
            $colGifsLikeUserDisplayName TEXT NULL,
            $colGifsLikeUserName TEXT NULL,
            $colGifsLikeUserAvatarUrl TEXT NULL,
            $colGifsLikeUserBannerUrl TEXT NULL
          )
          
          ''');
    await db.execute('''
          CREATE TABLE $tbGifsMenu (
            $colGifsMenuRowId INTEGER PRIMARY KEY,
            $colGifsMenuTitle TEXT NOT NULL,
            $colGifsMenuUrl TEXT NOT NULL            
          )
          ''');

    for (String s in inserMenus()) await db.execute(s);
  }

  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table,
      {String orderBy}) async {
    Database db = await instance.database;
    return await db.query(table, orderBy: orderBy);
  }

  Future<List<Map<String, dynamic>>> queryRowsOffset(String table, int id,
      {int limit = 15, String orderBy}) async {
    Database db = await instance.database;
    return await db.query(table,
        where: '$colGifsLikeCodigo > ?',
        whereArgs: [id],
        limit: limit,
        orderBy: orderBy);
  }

  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    int id = row[colGifsLikeRowId];
    return await db
        .update(table, row, where: '$colGifsLikeRowId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$colGifsLikeRowId = ?', whereArgs: [id]);
  }

  Future<int> deleteAll(String table) async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<String> queryRowByCodigo(String table, String codigo) async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> maps = await db.query(table,
          where: '$colGifsLikeCodigo = ?', whereArgs: [codigo], limit: 1);
      if (maps.length > 0)
        return maps[0]['codigo'];
      else
        return "";
    } catch (e) {
      print('ERRO>>> $e');
      return "";
    }
  }

  Future<int> deleteByCodigo(String table, String codigo) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$colGifsLikeCodigo = ?', whereArgs: [codigo]);
  }

  //region TABELA GIFS_LIKE
  static Map<String, dynamic> getRowGifsLike(
      {String codigo,
      String title,
      String url,
      String height,
      String userDisplayName,
      String userName,
      String userAvatarUrl,
      userBannerUrl}) {
    Map<String, dynamic> row = {
      DatabaseHelper.colGifsLikeCodigo: codigo,
      DatabaseHelper.colGifsLikeTitle: title,
      DatabaseHelper.colGifsLikeUrl: url,
      DatabaseHelper.colGifsLikeHeight: height,
      DatabaseHelper.colGifsLikeUserDisplayName: userDisplayName,
      DatabaseHelper.colGifsLikeUserName: userName,
      DatabaseHelper.colGifsLikeUserAvatarUrl: userAvatarUrl,
      DatabaseHelper.colGifsLikeUserBannerUrl: userBannerUrl,
    };

    return row;
  }

  //endregion

  //region TABELA GIFS_MENU
  static Map<String, dynamic> getRowGifsMenu({String title, String url}) {
    Map<String, dynamic> row = {
      DatabaseHelper.colGifsMenuTitle: title,
      DatabaseHelper.colGifsMenuUrl: url,
    };

    return row;
  }

  List<String> inserMenus() {
    return [
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('ANGRY','https://media.giphy.com/media/3og0IJHMqlmPzy7sGs/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('AWWW','https://media.giphy.com/media/XEIeaARvMaOxeaSOVu/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('BORED','https://media.giphy.com/media/Q7QfTyej3nwl4sVFhK/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('BYE','https://media.giphy.com/media/l3V0bpnfbQ3Ygpup2/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('CONGRATULATION','https://media.giphy.com/media/QC0goFAvl4WjfKjjgv/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('CRYING','https://media.giphy.com/media/3o7WIvNdkHa9toCFmo/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('EMBARASSED','https://media.giphy.com/media/3eZRwwX91t7xSaNkaE/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('FUNNY','https://media.giphy.com/media/Q7dtSarwiX2SrNDRKH/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('GOOD','https://media.giphy.com/media/Wp0C9nFRmR3A4Z8bYg/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('GOOD LUCKY','https://media.giphy.com/media/3ba6PqmGiVmCab4auJ/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('GOOD MORNING','https://media.giphy.com/media/l1J9rooRD8eFpVHOg/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('GOOD NIGHT','https://media.giphy.com/media/l1J9Dk3bDyb5oooQE/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('HAPPY','https://media.giphy.com/media/wIUQQ07BHzDry/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('HEY','https://media.giphy.com/media/l3nSGQUI8uU0udG7K/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('HI','https://media.giphy.com/media/26Fxy3Iz1ari8oytO/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('HUG','https://media.giphy.com/media/NSF7Vt18VPMigIwTjD/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('HUNGRY','https://media.giphy.com/media/wkmFSWTDdNASQ/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('KISSES','https://media.giphy.com/media/3og0IQ7L4cWZNP72Vi/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('LOL','https://media.giphy.com/media/xUA7b8bhAIcEPuXpF6/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('LOVE','https://media.giphy.com/media/3oKIPnyeAQ97VB0p0I/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('MISS YOU','https://media.giphy.com/media/3ohzdOFMQHd15lOOdO/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('NERVOUS','https://media.giphy.com/media/l378AeXUjhWzDgt8c/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('NEVER','https://media.giphy.com/media/Qz00OnU2FSwapXm0J3/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('NO','https://media.giphy.com/media/iD6QiXTTAYrU5C3c89/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('OK','https://media.giphy.com/media/YRtdDFvkg9ZtGrTHYv/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('OMG','https://media.giphy.com/media/l0MYPS6MF9IJTvnCo/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('PLEASE','https://media.giphy.com/media/IJjhKO6is7tMA/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('SAD','https://media.giphy.com/media/EEFEyXLO9E0YE/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('SLEEP','https://media.giphy.com/media/XoM1eSwGMXK4huqV2E/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('SCARED','https://media.giphy.com/media/21TWUordYY1Fe/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('SORRY','https://media.giphy.com/media/116uKb9kWhda8/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('STRESSED','https://media.giphy.com/media/3oKIPcfP1WbyGUV8Tm/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('WHY','https://media.giphy.com/media/3ov9jZU1Om6h16cdUs/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('WTF','https://media.giphy.com/media/l4pTa6TmeYyYjD9ss/giphy.gif')",
      "INSERT INTO $tbGifsMenu ($colGifsMenuTitle, $colGifsMenuUrl) VALUES('YES','https://media.giphy.com/media/f7BFZgwD7qltNSssoJ/giphy.gif')",
    ];
  }
//endregion

}
