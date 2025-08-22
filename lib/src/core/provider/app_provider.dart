/* General Import */
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';

/* Data */
import 'package:todopomodoro/src/core/data/data.dart';

/* Database */
import 'package:todopomodoro/src/core/database/database.dart';

class AppProvider with ChangeNotifier {
  /* History Delete Date */
  Duration historyDeleteDate = Duration(days: 30);

  /* View-Flags */
  bool tagGridView = false;
  bool taskGridView = false;

  /* Run-Time Lists */
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  List<Tag> _tags = [];
  List<Tag> get tags => _tags;
  List<History> _history = [];
  List<History> get history => _history;

  /*  Default-Tag */
  static const String defaultTagUID = "6006-0000-1221-2442-4224";
  String get getDefaultTagUID => defaultTagUID;

  /* AppProvider - Status */
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  AppProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    final db = await DatabaseHelper.instance.database;

    // Default-Tag sicherstellen
    await _ensureDefaultTag(db);

    // Alle Tasks laden
    final tasksData = await db.query('tasks');
    _tasks = tasksData.map((e) => Task.fromMap(e)).toList();

    // Alle Tags laden
    final tagsData = await db.query('tags');
    _tags = tagsData.map((e) => Tag.fromMap(e)).toList();

    // Alle History laden
    final historyData = await db.query('history');
    _history = historyData.map((e) => History.fromMap(e)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    final db = await DatabaseHelper.instance.database;
    final tasksData = await db.query('tasks');
    _tasks = tasksData.map((e) => Task.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> _loadTags() async {
    final db = await DatabaseHelper.instance.database;
    final tagsData = await db.query('tags');
    _tags = tagsData.map((e) => Tag.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> _loadHistory() async {
    final db = await DatabaseHelper.instance.database;
    final historyData = await db.query('history');
    _history = historyData.map((e) => History.fromMap(e)).toList();
    notifyListeners();
  }

  // ---------- Tasks ---------- //

  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final db = await DatabaseHelper.instance.database;
    await db.insert('tasks', task.toMap());

    // Default-Tag hinzufügen
    await addTaskToTag(taskUID: task.uID, tagUID: getDefaultTagUID);

    // Daten neu laden
    await _loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'u_id = ?',
      whereArgs: [task.uID],
    );
    await _loadTasks();
  }

  Future<void> deleteTask(String taskUID) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final db = await DatabaseHelper.instance.database;
    await db.delete('tasks', where: 'u_id = ?', whereArgs: [taskUID]);
    await _loadTasks();
  }

  // ---------- Tags ---------- //

  Tag get getDefaultTag {
    return _tags.firstWhere(
      (tag) => tag.uID == defaultTagUID,
      orElse: () => _tags.isNotEmpty
          ? _tags.first
          : throw Exception("Keine Tags vorhanden"),
    );
  }

  Future<void> addTag(Tag tag) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final db = await DatabaseHelper.instance.database;
    await db.insert('tags', tag.toMap());
    await _loadTags();
  }

  Future<void> updateTag(Tag tag) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'tags',
      tag.toMap(),
      where: 'u_id = ?',
      whereArgs: [tag.uID],
    );
    await _loadTags();
  }

  Future<void> deleteTag(String tagUID) async {
    await Future.delayed(const Duration(milliseconds: 50));

    final db = await DatabaseHelper.instance.database;

    if (tagUID == getDefaultTagUID) return;

    await db.delete('tags', where: 'u_id = ?', whereArgs: [tagUID]);
    await _loadTags();
  }

  Future<void> _ensureDefaultTag(Database db) async {
    final result = await db.query(
      'tags',
      where: 'u_id = ?',
      whereArgs: [defaultTagUID],
    );

    if (result.isEmpty) {
      await db.insert('tags', {
        'u_id': defaultTagUID,
        'title': 'Alle Tasks',
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // ---------- Task-Tag-Zuordnung ---------- //

  Future<List<Tag>> _loadTagsForTask(String taskUID) async {
    final db = await DatabaseHelper.instance.database;

    final rows = await db.rawQuery(
      '''
    SELECT t.*
    FROM tags t
    INNER JOIN task_tags tt ON t.u_id = tt.tag_uid
    WHERE tt.task_uid = ?
  ''',
      [taskUID],
    );

    return rows.map((e) => Tag.fromMap(e)).toList();
  }

  Future<void> addTaskToTag({
    required String taskUID,
    required String tagUID,
  }) async {
    final db = await DatabaseHelper.instance.database;

    final existing = await db.query(
      'task_tags',
      where: 'task_uid = ? AND tag_uid = ?',
      whereArgs: [taskUID, tagUID],
    );

    if (existing.isNotEmpty) return;

    await db.insert('task_tags', {'task_uid': taskUID, 'tag_uid': tagUID});

    // 🔹 Gezieltes Nachladen statt _loadData()
    final updatedTags = await _loadTagsForTask(taskUID);

    // Optional: lokale Tags aktualisieren
    _tags = _tags.map((tag) {
      if (updatedTags.any((t) => t.uID == tag.uID)) {
        return tag;
      }
      return tag;
    }).toList();

    notifyListeners();
  }

  Future<void> removeTaskFromTag({
    required String taskUID,
    required String tagUID,
  }) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'task_tags',
      where: 'task_uid = ? AND tag_uid = ?',
      whereArgs: [taskUID, tagUID],
    );

    final updatedTags = await _loadTagsForTask(taskUID);

    _tags = _tags.map((tag) {
      if (updatedTags.any((t) => t.uID == tag.uID)) {
        return tag;
      }
      return tag;
    }).toList();

    notifyListeners();
  }

  Future<List<Task>> readAllTasks({required Tag tag}) async {
    final db = await DatabaseHelper.instance.database;

    if (tag.title == 'Alle Tasks') return _tasks;

    final rows = await db.rawQuery(
      '''
      SELECT t.*
      FROM tasks t
      INNER JOIN task_tags tt ON t.u_id = tt.task_uid
      WHERE tt.tag_uid = ?
    ''',
      [tag.uID],
    );

    return rows.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Tag>> readAllTagsfromTask({required Task task}) async {
    final db = await DatabaseHelper.instance.database;

    final rows = await db.rawQuery(
      '''
      SELECT t.*
      FROM tags t
      INNER JOIN task_tags tt ON t.u_id = tt.tag_uid
      WHERE tt.task_uid = ?
    ''',
      [task.uID],
    );

    return rows.map((e) => Tag.fromMap(e)).toList();
  }

  // ---------- History ---------- //

  Future<void> addHistory(History entry) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('history', entry.toMap());
    await _loadHistory();
  }

  Future<void> updateHistory(History entry) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'history',
      entry.toMap(),
      where: 'u_id = ?',
      whereArgs: [entry.uID],
    );
    await _loadHistory();
  }

  Future<void> deleteHistory(String historyUID) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('history', where: 'u_id = ?', whereArgs: [historyUID]);
    await _loadHistory();
  }

  Future<History> startRun({
    required String taskUID,
    required String tagUID,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final newRun = History(
      uID: const Uuid().v4(),
      taskUID: taskUID,
      tagUID: tagUID,
      finished: false,
      startedAt: DateTime.now(),
      endedAt: null,
    );
    await db.insert('history', newRun.toMap());
    await _loadHistory();
    return newRun;
  }

  Future<void> finishRun(String historyUID) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'history',
      {'finished': 1, 'ended_at': DateTime.now().toIso8601String()},
      where: 'u_id = ?',
      whereArgs: [historyUID],
    );
    await _loadHistory();
  }

  List<History> openRuns({String? taskUID}) {
    return _history
        .where(
          (h) => h.endedAt == null && (taskUID == null || h.taskUID == taskUID),
        )
        .toList();
  }

  List<History> historyForTask(String taskUID) {
    return _history.where((h) => h.taskUID == taskUID).toList();
  }
}
