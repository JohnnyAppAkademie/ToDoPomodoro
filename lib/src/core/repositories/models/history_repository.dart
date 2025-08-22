import 'package:todopomodoro/src/core/data/models/history.dart';
import 'package:todopomodoro/src/core/database/database.dart';

class HistoryRepository {
  /* DB-Connection */
  final dbHelper = DatabaseHelper.instance;

  //  --- Crud --- //

  Future<List<History>> getAll() async {
    final db = await dbHelper.database;
    final rows = await db.query('history', orderBy: 'started_at DESC');
    return rows.map((e) => History.fromMap(e)).toList();
  }

  Future<History?> getByUID(String uID) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'history',
      where: 'u_id = ?',
      whereArgs: [uID],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return History.fromMap(rows.first);
  }

  Future<void> add(History entry) async {
    final db = await dbHelper.database;
    await db.insert('history', entry.toMap());
  }

  Future<void> update(History entry) async {
    final db = await dbHelper.database;
    await db.update(
      'history',
      entry.toMap(),
      where: 'u_id = ?',
      whereArgs: [entry.uID],
    );
  }

  Future<void> delete(String uID) async {
    final db = await dbHelper.database;
    await db.delete('history', where: 'u_id = ?', whereArgs: [uID]);
  }

  //  --- Additional Funktions ---  //

  Future<History> startRun({
    required String uID,
    required String taskUID,
    required String tagUID,
    DateTime? startedAt,
  }) async {
    final entry = History(
      dbID: null,
      uID: uID,
      taskUID: taskUID,
      tagUID: tagUID,
      finished: false,
      startedAt: startedAt ?? DateTime.now(),
      endedAt: null,
    );
    await add(entry);
    return entry;
  }

  Future<void> finishRun({required History historyEntry}) async {
    historyEntry.finished = true;
    historyEntry.endedAt = DateTime.now();
    await update(historyEntry);
  }

  Future<List<History>> getOpenRuns({String? taskUID}) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'history',
      where: taskUID == null
          ? 'ended_at IS NULL'
          : 'ended_at IS NULL AND task_uid = ?',
      whereArgs: taskUID == null ? null : [taskUID],
      orderBy: 'started_at DESC',
    );
    return rows.map((e) => History.fromMap(e)).toList();
  }

  Future<List<History>> getByTask(
    String taskUID, {
    DateTime? from,
    DateTime? to,
    bool? finished,
  }) async {
    final db = await dbHelper.database;

    final where = <String>['task_uid = ?'];
    final args = <Object>[taskUID];

    if (from != null) {
      where.add('started_at >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where.add('started_at <= ?');
      args.add(to.toIso8601String());
    }
    if (finished != null) {
      where.add('finished = ?');
      args.add(finished ? 1 : 0);
    }

    final rows = await db.query(
      'history',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'started_at DESC',
    );
    return rows.map((e) => History.fromMap(e)).toList();
  }

  Future<List<Map<String, Object?>>> getTotalsByTask({
    DateTime? from,
    DateTime? to,
    bool onlyFinished = false,
  }) async {
    final db = await dbHelper.database;

    final where = <String>[];
    final args = <Object>[];

    if (from != null) {
      where.add('started_at >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where.add('started_at <= ?');
      args.add(to.toIso8601String());
    }
    if (onlyFinished) {
      where.add('finished = 1');
    }

    final sql =
        '''
      SELECT task_uid,
             SUM(
               CAST ((julianday(ended_at) - julianday(started_at)) * 86400 AS INTEGER)
             ) AS total_seconds
      FROM history
      ${where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : ''}
      GROUP BY task_uid
    ''';

    final rows = await db.rawQuery(sql, args);
    return rows;
  }

  Future<void> deleteByTask(String taskUID) async {
    final db = await dbHelper.database;
    await db.delete('history', where: 'task_uid = ?', whereArgs: [taskUID]);
  }

  Future<void> deleteByDate(DateTime date) async {
    final db = await dbHelper.database;
    await db.delete(
      'history',
      where: 'started_at >= ?',
      whereArgs: [date.toIso8601String()],
    );
  }
}
