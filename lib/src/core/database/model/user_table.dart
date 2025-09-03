import 'package:sqflite/sqflite.dart';

class UserTable {
  static const table = 'users';

  static Future create(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        db_id INTEGER PRIMARY KEY AUTOINCREMENT,
        u_id TEXT NOT NULL UNIQUE,
        username TEXT,
        email TEXT UNIQUE,
        hashedPassword TEXT,
        profilePath TEXT,
        createdAt TEXT,
        lastLogin TEXT
      );
    ''');
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
