import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:todopomodoro/src/data/tag.dart';
import 'package:todopomodoro/src/data/task.dart';

/// __Task Controller__ - Klasse
/// Managed sowohl Tasks als auch Tags

class TaskController {
  /*  Konstante */
  static const int systemTagId = 0;

  /*  Variablen  */
  List<Tag> tags;
  List<Task> tasks;

  /*  Konstruktor  */
  TaskController({required this.tags, required this.tasks});

  //-------------  JSON  ----------------//

  /// __fromJson__ - Funktion
  /// <br> Factory zum Erstellen aus JSON-String. <br>
  /// <br> __Required__:
  /// * Der ausgelesene Json-String [String : jsonString]
  factory TaskController.fromJson(String jsonString) {
    final Map<String, dynamic> decoded = json.decode(jsonString);

    final List<Task> tasks = (decoded['tasks'] as List? ?? [])
        .map((taskJson) => Task.fromJson(taskJson))
        .toList();

    final List<Tag> tags = (decoded['tags'] as List? ?? [])
        .map((tagJson) => Tag.fromJson(tagJson))
        .toList();

    return TaskController(tasks: tasks, tags: tags);
  }

  ///  __toJson__ - Funktion
  /// <br> JSON String aus Controller - Instanz erzeugen. <br>
  String toJson() {
    final jsonMap = {
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'tags': tags.map((tag) => tag.toJson()).toList(),
    };
    return json.encode(jsonMap);
  }

  /// __filePath__ - Funktion
  /// <br> Pfad zur JSON Datei im Gerätespeicher. <br>
  static Future<String> get _filePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/data.json';
  }

  /// __saveToFile__ - Funktion
  /// <br> Controller in Datei speichern. <br>
  Future<void> saveToFile() async {
    final path = await _filePath;
    final file = File(path);
    await file.writeAsString(toJson());
  }

  /// __loadFromFile__ - Funktion
  /// <br> Controller aus Datei laden,
  /// oder falls Datei nicht existiert, aus den Assets laden. <br>
  static Future<TaskController> loadFromFile() async {
    try {
      final path = await _filePath;
      final file = File(path);

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        return TaskController.fromJson(jsonString);
      } else {
        // File doesn't exist in documents, so load from assets.
        final jsonString = await rootBundle.loadString('assets/data/data.json');
        final controller = TaskController.fromJson(jsonString);
        // Save the data from assets to the documents directory for future use.
        await controller.saveToFile();
        return controller;
      }
    } catch (e) {
      // If loading from both storage and assets fails, create a new instance as a fallback.
      return TaskController(
        tasks: [
          Task(id: 1, title: "A", duration: Duration(seconds: 35)),
          Task(id: 3, title: "B", duration: Duration(seconds: 45)),
          Task(id: 2, title: "C", duration: Duration(seconds: 45)),
        ],
        tags: [
          Tag(id: systemTagId, name: "Tasks", taskIds: [1, 2, 3]),
          Tag(id: 1, name: "Arbeit", taskIds: [2, 3]),
        ],
      );
    }
  }
}
