import 'package:sqflite/sqflite.dart';

class TaskTagTable {
  static const table = 'task_tags';

  static Future create(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        task_uid TEXT NOT NULL,
        tag_uid TEXT NOT NULL,
        user_id TEXT NOT NULL,
        PRIMARY KEY (task_uid, tag_uid, user_id),
        FOREIGN KEY (task_uid) REFERENCES tasks(u_id) ON DELETE CASCADE,
        FOREIGN KEY (tag_uid) REFERENCES tags(u_id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users(u_id) ON DELETE CASCADE
      );
    ''');
  }

  static Future<int> insert(Database db, Map<String, dynamic> row) async {
    return await db.insert(table, row);
  }

  static Future<int> delete(
    Database db,
    String taskUid,
    String tagUid,
    String userId,
  ) async {
    return await db.delete(
      table,
      where: 'task_uid = ? AND tag_uid = ? AND user_id = ?',
      whereArgs: [taskUid, tagUid, userId],
    );
  }
}
