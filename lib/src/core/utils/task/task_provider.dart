import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:todopomodoro/src/data/tag.dart';
import 'package:todopomodoro/src/data/task.dart';
import 'package:todopomodoro/src/core/utils/task/task_controller.dart';

/// __Tag Task Controller Provider__ - Klasse
/// <br> Der Tag Task Controller der als Provider ausgestattet ist. <br>
/// ( Siehe __[Klasse : TaskController]__ )
class TaskProvider extends ChangeNotifier {
  static const int systemTagId = 0;

  TaskController? _controller;
  bool _isLoading = true;

  List<Tag> get tags => _controller?.tags ?? [];
  List<Task> get tasks => _controller?.tasks ?? [];
  TaskController? get controller => _controller;
  bool get isLoading => _isLoading;

  TaskProvider() {
    _loadController();
  }

  /// __initializeDataFile__ - Funktion
  /// <br> Ließt / Erstellt die Json-File. <br>
  Future<void> _initializeDataFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/data.json';
    final file = File(path);

    if (!await file.exists()) {
      final assetData = await rootBundle.loadString('assets/data/data.json');
      await file.writeAsString(assetData);
    }
  }

  /// __loadController__ - Funktion
  /// <br> Lädt den Controller. <br>
  Future<void> _loadController() async {
    if (kDebugMode) {
      print("TaskProvider: Starte Controller-Load...");
    }
    try {
      await _initializeDataFile();
      if (kDebugMode) {
        print("TaskProvider: DataFile initialisiert");
      }
      _controller = await TaskController.loadFromFile();
      if (kDebugMode) {
        print(
          "TaskProvider: Controller geladen mit ${_controller!.tasks.length} Tasks",
        );
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print("Fehler beim Laden: $e\n$stack");
      }
      _controller = TaskController(
        tags: [Tag(id: TaskController.systemTagId, name: "Tasks", taskIds: [])],
        tasks: [],
      );
      await _controller?.saveToFile();
    } finally {
      _isLoading = false;
      if (kDebugMode) {
        print("TaskProvider: isLoading=false, notifyListeners()");
      }
      notifyListeners();
    }
  }

  /// __save__ - Funktion
  /// <br> Speichert den Controller. <br>
  Future<void> save() async {
    if (_controller != null) {
      await _controller!.saveToFile();
      notifyListeners();
    }
  }

  //------------- Tags ----------------//

  /// __readAllTasks__ - Funktion
  /// <br> Liest alle Tasks aus einem Tag. <br>
  /// __Required__:
  /// * Der Tab aus dem die Tasks gelesen werden sollen __[Tag : tag]__
  List<Task> readAllTasks(Tag tag) {
    final List<Task> tagTasks = [];
    for (var tagTaskId in tag.taskIds) {
      for (var task in _controller!.tasks) {
        if (task.id == tagTaskId) {
          tagTasks.add(task);
        }
      }
    }
    return tagTasks;
  }

  /// __addTag__ - Funktion
  /// <br> Fügt ein Tag in die Liste hinzu. <br>
  /// <br>__Required__:
  /// * Der Tag, welche in die Liste hinzugefügt wird __[Tag : tag]__
  Future<void> addTag({required Tag tag}) async {
    _controller!.tags.add(tag);
    notifyListeners();
    await save();
  }

  /// __removeTag__ - Funktion
  /// <br> Entfernt ein Tag aus der Liste. <br>
  /// <br>__Required__:
  /// * Die ID des Tags __[int : tagID]__
  Future<void> removeTag(int tagId) async {
    if (tagId != systemTagId) {
      _controller!.tags.removeWhere((tag) => tag.id == tagId);
      notifyListeners();
      await save();
    }
  }

  /// __renameTag__ - Funktion
  /// <br> Umbennt ein Tag. <br>
  /// <br> __Required__:
  /// * Die ID des Tags, welche angepasst werden soll __[int : tagID]__
  /// * Der neue Name des Tags __[String : newName]__
  Future<void> renameTag({required int tagID, required String newName}) async {
    final tag = _controller!.tags.firstWhere(
      (t) => t.id == tagID,
      orElse: () => throw Exception("Tag $tagID nicht gefunden"),
    );

    if (tagID == systemTagId) {
      throw Exception("Der System-Tag darf nicht umbenannt werden.");
    }

    tag.name = newName;
    notifyListeners();

    await save();
  }

  //------------- Tasks ----------------//

  /// __addTask__ - Funktion
  /// <br> Fügt eine Task in die Liste hinzu. <br>
  /// <br>__Required__:
  /// *  Die Task, die zur Liste hinzugefügt werden soll __[Task : task]__
  /// *  __[List<Tag>? taskTags]__
  Future<void> addTask({required Task task, List<Tag>? taskTags}) async {
    _controller!.tasks.add(task);

    final systemTag = _controller!.tags.firstWhere(
      (tag) => tag.id == systemTagId,
      orElse: () => throw Exception('System-Tag (ID:0) nicht gefunden!'),
    );
    systemTag.taskIds.add(task.id);

    if (taskTags != null) {
      for (Tag tag in taskTags) {
        if (!tag.taskIds.contains(task.id)) {
          tag.taskIds.add(task.id);
        }
      }
    }
    notifyListeners();
    await save();
  }

  /// __removeTask__ - Funktion
  /// <br> Entfernt eine Task aus der Liste. <br>
  /// <br>__Required__:
  /// * Die ID der Task, welche gelöscht werden soll __[int : taskId]__
  Future<void> removeTask(int taskId) async {
    _controller!.tasks.removeWhere((task) => task.id == taskId);

    for (var tag in _controller!.tags) {
      tag.taskIds.remove(taskId);
    }
    notifyListeners();
    await save();
  }

  /// __updateTask__ - Funktion
  /// <br> Aktualisiert eine Task. <br>
  /// <br>__Required__:
  /// * Die ID, der Task, die geupdated wird __[int : taskId]__
  ///
  /// <br>__Non-Required__:
  /// * Der neue Task-Name __[String : newTitle]__
  /// * Die neue Task-Duration __[Duration : newDuration]__
  Future<void> updateTask({
    required int taskId,
    String? newTitle,
    Duration? newDuration,
  }) async {
    final task = _controller!.tasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => throw Exception("Task $taskId nicht gefunden"),
    );

    if (newTitle != null) task.title = newTitle;
    if (newDuration != null) task.duration = newDuration;
    notifyListeners();
    await save();
  }

  /// __addTaskToTag__ - Funktion
  /// <br> Fügt eine Task zu einem Tag hinzu. <br>
  /// <br>__Required__:
  /// * Die Task ID, welche zum Tag hinzugefügt werden soll [int : taskId]
  /// * Die Tag ID, zu dem die Task ID, hinzugefügt werden soll [int : tagId]
  Future<void> addTaskToTag({required int taskId, required int tagId}) async {
    final tag = _controller!.tags.firstWhere(
      (t) => t.id == tagId,
      orElse: () => throw Exception("Tag $tagId nicht gefunden"),
    );

    if (!tag.taskIds.contains(taskId)) tag.taskIds.add(taskId);
    notifyListeners();
    await save();
  }

  /// __removeTaskFromTag__ - Funktion
  /// <br> Entfernt eine Task aus einem Tag. <br>
  /// <br> __Required__:
  /// * Die Task ID, welche bei dem sie aus den Tag herausgenommen soll [int : taskId]
  /// * Die Tag ID, zu dem die Task ID, herausgenommen soll [int : tagId]
  Future<void> removeTaskFromTag({
    required int taskId,
    required int tagId,
  }) async {
    final tag = _controller!.tags.firstWhere(
      (t) => t.id == tagId,
      orElse: () => throw Exception("Tag $tagId nicht gefunden"),
    );

    if (tag.id == systemTagId) {
      throw Exception("Der System-Tag darf keine Tasks verlieren.");
    }

    tag.taskIds.remove(taskId);
    notifyListeners();
    await save();
  }

  /// __deleteTask__ - Funktion
  /// <br> Löscht eine Task. <br>
  /// <br> __Required__:
  /// * Die Task, welche gelöscht werden soll __[Task: task]__
  void deleteTask(Task task) {
    _controller!.tasks.remove(task);
    for (var tag in _controller!.tags) {
      tag.taskIds.remove(task.id);
    }
    notifyListeners();
  }
}
