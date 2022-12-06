import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(dbPath, 'users.db'),
        onCreate: (db, version) {
      return db.execute("""
        CREATE TABLE add_user(
        id TEXT PRIMARY KEY,
        title  TEXT, 
        job TEXT, 
        salary DOUBLE,
        age INT,
        image TEXT
        )
      """);
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await UserDatabase.database();
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await UserDatabase.database();
    return db.query(table);
  }

  static Future<Future<int>> updateData(
      String table, Map<String, Object> data) async {
    final db = await UserDatabase.database();
    return db.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  static Future<Future<int>> removeData(String table, String id) async {
    final db = await UserDatabase.database();
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
