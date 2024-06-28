import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String facesTable = 'faces_table';
  String colId = 'id';
  String colImagePath = 'image_path';
  String colName = 'name';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'faces.db');
    final facesDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return facesDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $facesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colImagePath TEXT, $colName TEXT)',
    );
  }

  Future<int> insertFace(Map<String, dynamic> face) async {
    Database? db = await this.db;
    final int result = await db!.insert(facesTable, face);
    return result;
  }

  Future<List<Map<String, dynamic>>> getFaceList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(facesTable);
    return result;
  }
}
