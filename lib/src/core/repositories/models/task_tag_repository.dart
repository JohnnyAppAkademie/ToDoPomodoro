import 'package:todopomodoro/src/core/database/database.dart';

class TaskTagRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<void> addTaskToTag(String taskUID, String tagUID) async {
    final db = await dbHelper.database;
    await db.insert('task_tags', {'task_uid': taskUID, 'tag_uid': tagUID});
  }

  Future<void> removeTaskFromTag(String taskUID, String tagUID) async {
    final db = await dbHelper.database;
    await db.delete(
      'task_tags',
      where: 'task_uid = ? AND tag_uid = ?',
      whereArgs: [taskUID, tagUID],
    );
  }

  Future<List<String>> getTagsForTask(String taskUID) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'task_tags',
      columns: ['tag_uid'],
      where: 'task_uid = ?',
      whereArgs: [taskUID],
    );
    return result.map((e) => e['tag_uid'] as String).toList();
  }

  Future<List<String>> getTasksForTag(String tagUID) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'task_tags',
      columns: ['task_uid'],
      where: 'tag_uid = ?',
      whereArgs: [tagUID],
    );
    return result.map((e) => e['task_uid'] as String).toList();
  }
}
