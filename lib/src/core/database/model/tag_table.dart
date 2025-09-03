import 'package:sqflite/sqflite.dart';

class TagTable {
  static const table = 'tags';

  static Future create(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        db_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        u_id TEXT NOT NULL UNIQUE,
        title TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(u_id) ON DELETE CASCADE
      );
    ''');
    await db.execute('CREATE INDEX idx_tags_user_id ON tags(user_id)');
  }

  static Future<int> insert(Database db, Map<String, dynamic> row) async {
    return await db.insert(table, row);
  }

  static Future<List<Map<String, dynamic>>> getAll(Database db) async {
    return await db.query(table);
  }

  static Future<int> update(
    Database db,
    String uId,
    Map<String, dynamic> row,
  ) async {
    return await db.update(table, row, where: 'u_id = ?', whereArgs: [uId]);
  }

  static Future<int> delete(Database db, String uId) async {
    return await db.delete(table, where: 'u_id = ?', whereArgs: [uId]);
  }
}
