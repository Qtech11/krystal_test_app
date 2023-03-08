import 'package:sqflite/sqflite.dart';
import '../../model/blog_post_model.dart';

class DatabaseHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "task";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}post.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            '''CREATE TABLE $_tableName(
            id INTEGER,
            userId TEXT, title TEXT, body TEXT)''',
          );
        },
      );
    } catch (e) {
      //
    }
  }

  static Future<int?> insert(BlogPostModel post) async {
    return await _db?.insert(_tableName, post.toJson());
  }

  static Future<List<Map<String, dynamic>>> query() async {
    List<Map<String, dynamic>> posts = await _db!.query(_tableName);
    return posts;
  }

  static Future doesPostExist(int id) async {
    List<Map<String, dynamic>> result =
        await _db!.query(_tableName, where: "id = ?", whereArgs: [id]);
    return result.isEmpty;
  }

  static Future<void> delete(int id) async {
    await _db!.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
