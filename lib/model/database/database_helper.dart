import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;

  static final table = 'favorites';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnAuthors = 'authors';
  static final columnThumbnailLink = 'thumbnailLink';
  static final columnInfoLink = 'infoLink';
  static final columnBuyLink = 'buyLink';


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT,
            $columnAuthors TEXT NOT NULL,
            $columnThumbnailLink TEXT,
            $columnInfoLink TEXT NOT NULL,
            $columnBuyLink TEXT
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<bool> contains(String id) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE id = "$id"')) > 0;
  }

  Future<int> delete(String id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}