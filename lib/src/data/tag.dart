/// __Tag__ - Klasse
/// <br> Die Klasse für die Tags
/// <br> (__Tags sind Gruppierungen für Tasks__)
class Tag {
  // Attribute //
  /* Die ID des Tags */
  final int id;
  /* Der Name des Tags */
  String name;
  /*  Die Tasks in der Tag  */
  List<int> taskIds;

  ///  __Tag__ - Konstruktor:
  /// <br> Erstellt einen Tag <br>
  /// <br>__Benötigt:__
  /// * Die ID des Tags __[int : id]__
  /// * Der Name des Tags __[string : name]__
  /// * Liste an Tasks in dem Tag __[List<int> : taskIds]__
  Tag({required this.id, required this.name, required this.taskIds});

  /// __Tag.fromJson()__ - Factory:
  /// <br> Erstellt ein Tag von einer Json
  /// <br> __Benötigt:__
  /// * Die Json von dem ein Tag erstellt werden soll __[Map &lt;String, dynamic&gt; : json]__
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as int,
      name: json['name'] as String,
      taskIds: (json['taskIDs'] != null) ? List<int>.from(json['taskIds']) : [],
    );
  }

  /// __toJson()__ - Funktion:
  /// <br> Erstellt einen Eintrag eines Tags in einem Json-Format
  /// <br> __Benötigt:__
  /// * Die ID des Tags __[int : id]__
  /// * Der Name des Tags __[string : name]__
  /// * Liste an Tasks in dem Tag __[List<int> : taskIDs]__
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'taskIds': taskIds};

  /// __removeTask()__ - Funktion:
  /// <br> Entfernt einen Task aus der Task-Liste des Tags
  /// <br> __Benötigt:__
  /// * Die ID des Tasks __[int : id]__
  void removeTask(int taskId) {
    taskIds.remove(taskId);
  }

  /// __copy()__ - Funktion:
  /// <br> Erstellt eine Kopie des Tags <br>
  Tag copy() => Tag(id: id, name: name, taskIds: List.from(taskIds));
}
