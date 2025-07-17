/// Klasse:
/// <br>__Task__
/// <br> Eine Klasse für die Aufbau einer Task
/// (__Task => Ein ToDo-Aufgabe__)
class Task {
  //  Attributes  //

  /*  Task-Name */
  String name;

  // Task-Dauer //
  Duration duration;

  ///  Konstruktor:
  /// <br>__Task__
  /// <br>Requires:
  /// * Der Name des Tasks (__[String : name]__)
  /// * Die Dauer des Tasks (__[Duration : duration]__)
  Task({required this.name, required this.duration});

  /*  Set */
  set setName(String newName) => name = newName;
  set setDuration(Duration newDuration) => duration = newDuration;
  /*  Get  */
  get getName => name;
  get getDuration => duration;
}
