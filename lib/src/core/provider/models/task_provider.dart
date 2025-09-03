/* General Import */
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

/* Data */
import 'package:todopomodoro/src/core/data/data.dart';

/* Database */
import 'package:todopomodoro/src/core/database/database.dart';

/* Provider */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show UserProvider;

class TaskProvider with ChangeNotifier {
  /* Run-Time Lists */
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  List<Tag> _tags = [];
  List<Tag> get tags => _tags;

  /*  Default-Tag */
  late String defaultTagUID;
  String get getDefaultTagUID => defaultTagUID;

  /* AppProvider - Status */
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  /* User - Daten */
  UserProvider? userProvider;
  late String userID;

  TaskProvider(this.userProvider) {
    if (userProvider?.currentUser != null) {
      userID = userProvider!.currentUser!.uID;
      defaultTagUID = "0000-${userProvider!.currentUser!.uID}-0000";
      _init();
    } else {
      userID = '';
      defaultTagUID = '';
    }
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    final db = await DatabaseHelper.instance.database;

    if (!userID.isNotEmpty) return;

    await _ensureDefaultTag(db);

    // Tasks und Tags parallel laden
    final results = await Future.wait([
      db.query('tasks', where: 'user_id = ?', whereArgs: [userID]),
      db.query('tags', where: 'user_id = ?', whereArgs: [userID]),
    ]);

    final tasksData = results[0] as List<Map<String, dynamic>>;
    final tagsData = results[1] as List<Map<String, dynamic>>;

    _tasks = tasksData.map((e) => Task.fromMap(e)).toList();
    _tags = tagsData.map((e) => Tag.fromMap(e)).toList();

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

  Future<void> fullReset() async {
    final db = await DatabaseHelper.instance.database;

    await db.delete('task_tags');
    await db.delete('tasks');
    await db.delete('tags');

    _tasks.clear();
    _tags.clear();

    await _ensureDefaultTag(db);

    await _init();

    notifyListeners();
  }

  // ---------- Tasks ---------- //
  Future<void> addTask(Task task) async {
    final db = await DatabaseHelper.instance.database;
    if (userID.isEmpty) return;

    await _ensureDefaultTag(db);

    await db.insert('tasks', task.toMap()..['user_id'] = userID);

    await addTaskToTag(taskUID: task.uID, tagUID: defaultTagUID);

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
    if (userID.isEmpty) return;

    final tagUID = "0000-$userID-0000";

    final result = await db.query(
      'tags',
      where: 'u_id = ? AND user_id = ?',
      whereArgs: [tagUID, userID],
    );

    if (result.isEmpty) {
      await db.insert('tags', {
        'u_id': tagUID,
        'title': 'All Tasks',
        'updated_at': DateTime.now().toIso8601String(),
        'user_id': userID,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    // DefaultTagUID setzen
    defaultTagUID = tagUID;
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
      where: 'task_uid = ? AND tag_uid = ? AND user_id = ?',
      whereArgs: [taskUID, tagUID, userID],
    );

    if (existing.isNotEmpty) return;

    await db.insert('task_tags', {
      'task_uid': taskUID,
      'tag_uid': tagUID,
      'user_id': userID,
    });

    final updatedTags = await _loadTagsForTask(taskUID);

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
}
