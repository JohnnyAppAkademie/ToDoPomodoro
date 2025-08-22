import 'package:todopomodoro/src/core/data/models/task.dart';

import 'package:todopomodoro/src/core/database/database.dart';

class TaskRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<List<Task>> getAll() async {
    final db = await dbHelper.database;
    final result = await db.query('tasks');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<void> add(Task task) async {
    final db = await dbHelper.database;
    await db.insert('tasks', task.toMap());
  }

  Future<void> update(Task task) async {
    final db = await dbHelper.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'u_id = ?',
      whereArgs: [task.uID],
    );
  }

  Future<void> delete(String uID) async {
    final db = await dbHelper.database;
    await db.delete('tasks', where: 'u_id = ?', whereArgs: [uID]);
  }
}
