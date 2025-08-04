/// __Task__ - Klasse:
/// <br>Die Klasse für die Tasks
/// <br>( __Task => Aufgaben für den User zu bearbeiten__ )
class Task {
  /* Die Variablen für die Klasse Task */
  // Die ID des Tasks //
  final int id;
  // Der Titel des Tasks //
  String title;
  // Die Dauer des Tasks //
  Duration duration;

  /// __Task__ - Konstruktor:
  /// <br> Erstellt einen vollständigen Task <br>
  /// <br>__Benötigt:__
  /// * Die ID des Tasks __[int : id]__
  /// * Der Name des Tasks __[string : name]__
  /// * Dauer des Tasks __[Duration : duration]__
  Task({required this.id, required this.title, required this.duration});

  /// __Task.fromJson__ - Factory:
  /// <br> Erstellt einen Task von einer Json
  /// <br> __Benötigt:__
  /// * Die Json von dem ein Tag erstellt werden soll __[Map &lt;String, dynamic&gt; : json]__
  factory Task.fromJson(Map<String, dynamic> json) {
    /* Dauer kommt als Minutenzahl (int)  */
    int durationMinutes = json['duration'] ?? 0;

    return Task(
      id: json['id'],
      title: json['title'],
      duration: Duration(minutes: durationMinutes),
    );
  }

  /// __toJson()__ - Funktion:
  /// <br> Erstellt einen Eintrag eines Tasks in einem Json-Format
  /// <br> __Benötigt:__
  /// * Die ID des Tasks __[int : id]__
  /// * Der Name des Tasks __[string : name]__
  /// * Die Dauer des Tasks __[List<int> : taskIDs]__
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'duration': duration.inMinutes,
  };

  Task copy() => Task(id: id, title: title, duration: duration);
}
