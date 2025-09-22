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

/* Firestore */
import 'package:cloud_firestore/cloud_firestore.dart';

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

  /* Firestore */
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TaskProvider(this.userProvider) {
    if (userProvider?.currentUser != null) {
      userID = userProvider!.currentUser!.uID;
      defaultTagUID = "0000-${userProvider!.currentUser!.uID}-0000";
      _initWithSync();
    } else {
      userID = '';
      defaultTagUID = '';
    }
  }

  Future<void> _initWithSync() async {
    _isLoading = true;
    notifyListeners();

    final db = await DatabaseHelper.instance.database;
    if (!userID.isNotEmpty) return;

    await _ensureDefaultTag(db);

    await _loadTasks();
    await _loadTags();

    await _syncFromFirestore();

    _startFirestoreListener();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _syncFromFirestore() async {
    if (userID.isEmpty) return;
    final db = await DatabaseHelper.instance.database;

    // === Tasks ===
    final taskSnapshot = await _firestore
        .collection('users')
        .doc(userID)
        .collection('tasks')
        .get();
    for (var doc in taskSnapshot.docs) {
      final task = Task.fromMap(doc.data());
      await db.insert(
        'tasks',
        task.toMap()..['user_id'] = userID,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    _tasks = (await db.query(
      'tasks',
      where: 'user_id = ?',
      whereArgs: [userID],
    )).map((e) => Task.fromMap(e)).toList();

    // === Tags ===
    final tagSnapshot = await _firestore
        .collection('users')
        .doc(userID)
        .collection('tags')
        .get();
    for (var doc in tagSnapshot.docs) {
      final tag = Tag.fromMap(doc.data());
      await db.insert(
        'tags',
        tag.toMap()..['user_id'] = userID,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    _tags = (await db.query(
      'tags',
      where: 'user_id = ?',
      whereArgs: [userID],
    )).map((e) => Tag.fromMap(e)).toList();

    // === TaskTags (Relationen) ===
    final relSnapshot = await _firestore
        .collection('users')
        .doc(userID)
        .collection('task_tags')
        .get();
    for (var doc in relSnapshot.docs) {
      await db.insert('task_tags', {
        'task_uid': doc['task_uid'],
        'tag_uid': doc['tag_uid'],
        'user_id': doc['user_id'],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

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

    await _initWithSync();

    notifyListeners();
  }

  void _startFirestoreListener() {
    if (userID.isEmpty) return;

    // === Tasks Listener ===
    _firestore
        .collection('users')
        .doc(userID)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) async {
          final db = await DatabaseHelper.instance.database;
          for (var doc in snapshot.docs) {
            final task = Task.fromMap(doc.data());
            await db.insert(
              'tasks',
              task.toMap()..['user_id'] = userID,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          _tasks = (await db.query(
            'tasks',
            where: 'user_id = ?',
            whereArgs: [userID],
          )).map((e) => Task.fromMap(e)).toList();
          notifyListeners();
        });

    // === Tags Listener ===
    _firestore
        .collection('users')
        .doc(userID)
        .collection('tags')
        .snapshots()
        .listen((snapshot) async {
          final db = await DatabaseHelper.instance.database;
          for (var doc in snapshot.docs) {
            final tag = Tag.fromMap(doc.data());
            await db.insert(
              'tags',
              tag.toMap()..['user_id'] = userID,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          _tags = (await db.query(
            'tags',
            where: 'user_id = ?',
            whereArgs: [userID],
          )).map((e) => Tag.fromMap(e)).toList();
          notifyListeners();
        });

    // === TaskTags Listener ===
    _firestore
        .collection('users')
        .doc(userID)
        .collection('task_tags')
        .snapshots()
        .listen((snapshot) async {
          final db = await DatabaseHelper.instance.database;
          // wir setzen hier nicht _tasks/_tags neu, weil es nur die Relation betrifft,
          // sondern halten einfach die DB aktuell
          for (var doc in snapshot.docs) {
            await db.insert('task_tags', {
              'task_uid': doc['task_uid'],
              'tag_uid': doc['tag_uid'],
              'user_id': doc['user_id'],
            }, conflictAlgorithm: ConflictAlgorithm.replace);
          }
          notifyListeners();
        });
  }

  // -------- Firestore - Task -------- //

  Future<void> addTaskToFirestore(Task task) async {
    if (userID.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(userID)
        .collection('tasks')
        .doc(task.uID)
        .set(task.toMap());
  }

  Future<void> updateTaskInFirestore(Task task) async {
    if (userID.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(userID)
        .collection('tasks')
        .doc(task.uID)
        .update(task.toMap());
  }

  Future<void> deleteTaskFromFirestore(String taskUID) async {
    if (userID.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(userID)
        .collection('tasks')
        .doc(taskUID)
        .delete();
  }

  Future<List<Task>> loadTasksFromFirestore() async {
    if (userID.isEmpty) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(userID)
        .collection('tasks')
        .get();

    return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }

  // ---------- Firestore - Tags ---------- //
  Future<void> addTagToFirestore(Tag tag) async {
    if (userID.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(userID)
        .collection('tags')
        .doc(tag.uID)
        .set(tag.toMap());
  }

  Future<void> updateTagInFirestore(Tag tag) async {
    if (userID.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(userID)
        .collection('tags')
        .doc(tag.uID)
        .update(tag.toMap());
  }

  Future<void> deleteTagFromFirestore(String tagUID) async {
    if (userID.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(userID)
        .collection('tags')
        .doc(tagUID)
        .delete();
  }

  // -------- Firestore - Tag/Task ------- //

  Future<void> addTaskTagFirestoreRelation(
    String taskUID,
    String tagUID,
  ) async {
    if (userID.isEmpty) return;

    final docId = '${taskUID}_$tagUID'; // Eindeutig
    await _firestore
        .collection('users')
        .doc(userID)
        .collection('task_tags')
        .doc(docId)
        .set({'task_uid': taskUID, 'tag_uid': tagUID, 'user_id': userID});
  }

  Future<void> removeTaskTagFirestoreRelation(
    String taskUID,
    String tagUID,
  ) async {
    if (userID.isEmpty) return;

    final docId = '${taskUID}_$tagUID';
    await _firestore
        .collection('users')
        .doc(userID)
        .collection('task_tags')
        .doc(docId)
        .delete();
  }

  // ---------- Tasks ---------- //
  Future<void> addTask(Task task) async {
    final db = await DatabaseHelper.instance.database;
    if (userID.isEmpty) return;

    await _ensureDefaultTag(db);
    await db.insert('tasks', task.toMap()..['user_id'] = userID);
    await addTaskToTag(taskUID: task.uID, tagUID: defaultTagUID);
    await _loadTasks();

    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('tasks')
          .doc(task.uID)
          .set(task.toMap());
      await addTaskTagFirestoreRelation(task.uID, defaultTagUID);
    } catch (_) {}
  }

  Future<void> updateTask(Task task) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'u_id = ? AND user_id = ?',
      whereArgs: [task.uID, userID],
    );
    await _loadTasks();

    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('tasks')
          .doc(task.uID)
          .update(task.toMap());
    } catch (_) {}
  }

  Future<void> deleteTask(String taskUID) async {
    final db = await DatabaseHelper.instance.database;

    // Lokale DB löschen
    await db.delete('tasks', where: 'u_id = ?', whereArgs: [taskUID]);
    await db.delete('task_tags', where: 'task_uid = ?', whereArgs: [taskUID]);
    await _loadTasks();

    // Firestore
    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('tasks')
          .doc(taskUID)
          .delete();

      // Alle TaskTag-Relationen löschen
      final relSnapshot = await _firestore
          .collection('users')
          .doc(userID)
          .collection('task_tags')
          .where('task_uid', isEqualTo: taskUID)
          .get();

      for (var doc in relSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (_) {}
  }

  Future<Task> getTask(String taskUID) async {
    return _tasks.firstWhere(
      (t) => t.uID == taskUID,
      orElse: () => throw Exception("Task not found"),
    );
  }

  Future<List<Task>> getAllTasks() async {
    return _tasks;
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
    final db = await DatabaseHelper.instance.database;
    await db.insert('tags', tag.toMap());
    await _loadTags();

    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('tags')
          .doc(tag.uID)
          .set(tag.toMap());
    } catch (_) {}
  }

  Future<void> updateTag(Tag tag) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'tags',
      tag.toMap(),
      where: 'u_id = ? AND user_id = ?',
      whereArgs: [tag.uID, userID],
    );
    await _loadTags();

    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('tags')
          .doc(tag.uID)
          .update(tag.toMap());
    } catch (_) {}
  }

  Future<void> deleteTag(String tagUID) async {
    if (tagUID == defaultTagUID) return;

    final db = await DatabaseHelper.instance.database;
    await db.delete('tags', where: 'u_id = ?', whereArgs: [tagUID]);
    await db.delete('task_tags', where: 'tag_uid = ?', whereArgs: [tagUID]);
    await _loadTags();

    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('tags')
          .doc(tagUID)
          .delete();

      // Alle TaskTag-Relationen löschen
      final relSnapshot = await _firestore
          .collection('users')
          .doc(userID)
          .collection('task_tags')
          .where('tag_uid', isEqualTo: tagUID)
          .get();

      for (var doc in relSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (_) {}
  }

  Future<Tag> getTag(String tagUID) async {
    return _tags.firstWhere(
      (t) => t.uID == tagUID,
      orElse: () => throw Exception("Tag not found"),
    );
  }

  Future<List<Tag>> getAllTags() async {
    return _tags;
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

      await _firestore
          .collection('users')
          .doc(userID)
          .collection('tags')
          .doc(tagUID)
          .set({
            'u_id': tagUID,
            'title': 'All Tasks',
            'updated_at': DateTime.now().toIso8601String(),
            'user_id': userID,
          });
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

    // Lokale DB
    final existing = await _loadTagsForTask(taskUID);

    if (existing.isEmpty) {
      await db.insert('task_tags', {
        'task_uid': taskUID,
        'tag_uid': tagUID,
        'user_id': userID,
      });
    }

    // Firestore
    if (userID.isNotEmpty) {
      final relId = '${taskUID}_$tagUID';
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('task_tags')
          .doc(relId)
          .set({'task_uid': taskUID, 'tag_uid': tagUID, 'user_id': userID});
    }

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

    // Firestore
    if (userID.isNotEmpty) {
      final relId = '${taskUID}_$tagUID';
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('task_tags')
          .doc(relId)
          .delete();
    }

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
      WHERE tt.tag_uid = ? AND t.user_id = ?
    ''',
      [tag.uID, userID],
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
