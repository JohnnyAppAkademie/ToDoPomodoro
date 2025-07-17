import 'package:todopomodoro/logic/task.dart';

/// Klasse:
/// <br>__TagTask__
/// <br> Eine Klasse für den Aufbau eines Tag's
/// <br> (__Tag => Gruppierung von Tasks__)
class TagTask {
  // Attribute  //

  /*  Tag-Name  */
  String name = "";

  /*  Task-Liste  */
  List<Task> taskList = [];

  ///  Konstruktor:
  /// <br>__PomodoroTimer__
  /// <br> Der Konstruktor bearbeitet eine Tag vor <br>
  /// <br>__Benötigt:__
  /// * Name des Tags (__[String : name]__)
  /// * Liste aller Tasks (__[List<Task> : taskList]__)
  TagTask(String tag, List<Task> tList) {
    name = "#$tag";
    taskList = tList;
  }

  /*  Set */
  set setName(String newName) => name = "#$newName";
  set setTaskList(List<Task> newTaskList) => taskList = newTaskList;
  /*  Get  */
  get getName => name;
  get getTaskList => taskList;

  // Methoden //

  ///  Funktion:
  /// <br>__addTask__
  /// <br>Fügt eine Task zur Liste hinzu.
  /// <br>__Requires:__
  /// * Benötigt die Task, die angehängt werden soll __[Task : task]__
  void addTask(Task task) {
    taskList.add(task);
  }

  ///  Funktion:
  /// <br>__getTask__
  /// <br>Hole eine Task aus der Liste raus.
  /// <br>__Requires:__
  /// * Die Taskposition in der Liste (__[int : position]__)
  Task getTask(int position) {
    return taskList[position];
  }

  ///  Funktion:
  /// <br>__deleteTask__
  /// <br>Löscht eine Task bei einer spezifischen Position
  /// <br>__Requires:__
  /// * Die Taskposition in der Liste (__[int : position]__)
  void deleteTask(int position) {
    taskList.removeAt(position);
  }
}
