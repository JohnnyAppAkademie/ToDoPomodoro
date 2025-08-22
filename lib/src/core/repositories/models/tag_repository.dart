import 'package:todopomodoro/src/core/data/data.dart' show Task, Tag;
import 'package:todopomodoro/src/core/data/models/repository.dart';
import 'package:todopomodoro/src/core/database/database.dart';

class TagRepository implements Repository<Tag> {
  final dbHelper = DatabaseHelper.instance;

  //  --- Crud --- //

  @override
  Future<List<Tag>> getAll() async {
    final db = await dbHelper.database;
    final result = await db.query('tags');
    return result.map((e) => Tag.fromMap(e)).toList();
  }

  @override
  Future<void> add(tag) async {
    final db = await dbHelper.database;
    await db.insert('tags', tag.toMap());
  }

  @override
  Future<void> update(tag) async {
    final db = await dbHelper.database;
    await db.update(
      'tags',
      tag.toMap(),
      where: 'u_id = ?',
      whereArgs: [tag.uID],
    );
  }

  @override
  Future<void> delete(String uID) async {
    final db = await dbHelper.database;
    await db.delete('tags', where: 'u_id = ?', whereArgs: [uID]);
  }

  //  --- Additional Operations --- //

  Future<void> ensureDefaultTag(String defaultTagUID) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'tags',
      where: 'u_id = ?',
      whereArgs: [defaultTagUID],
    );
    if (rows.isEmpty) {
      await db.insert('tags', {
        'u_id': defaultTagUID,
        'title': 'All Tasks',
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> addTaskToTag(String tagUID, String taskUID) async {
    final db = await dbHelper.database;
    await db.insert('tag_tasks', {'tag_uid': tagUID, 'task_uid': taskUID});
  }

  Future<void> removeTaskFromTag(String tagUID, String taskUID) async {
    final db = await dbHelper.database;
    await db.delete(
      'tag_tasks',
      where: 'tag_uid = ? AND task_uid = ?',
      whereArgs: [tagUID, taskUID],
    );
  }

  Future<List<Task>> getTasksForTag(String tagUID) async {
    final db = await dbHelper.database;
    final rows = await db.rawQuery(
      '''
      SELECT t.*
      FROM tasks t
      JOIN tag_tasks tt ON t.uid = tt.task_uid
      WHERE tt.tag_uid = ?
    ''',
      [tagUID],
    );
    return rows.map((e) => Task.fromMap(e)).toList();
  }
}
