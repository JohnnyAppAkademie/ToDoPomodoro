import 'package:uuid/uuid.dart';

class Task {
  int? dbID;
  String uID;
  String title;
  Duration duration;
  DateTime updatedAt;

  Task({
    this.dbID,
    required this.uID,
    required this.title,
    required this.duration,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory Task.newTask({String? title, Duration? duration}) {
    return Task(
      uID: const Uuid().v4(),
      title: title ?? 'Neuer Task',
      duration: duration ?? const Duration(minutes: 0),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      dbID: json['dbID'],
      uID: json['uID'] ?? const Uuid().v4(),
      title: json['title'],
      duration: Duration(minutes: json['duration'] ?? 0),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': dbID,
    'uuid': uID,
    'title': title,
    'duration': duration.inMinutes,
    'updatedAt': updatedAt.toIso8601String(),
  };

  void mergeFromRemote(Task remote) {
    if (remote.updatedAt.isAfter(updatedAt)) {
      title = remote.title;
      duration = remote.duration;
      updatedAt = remote.updatedAt;
    }
    dbID ??= remote.dbID;
  }

  void updateTitle(String newTitle) {
    title = newTitle;
    updatedAt = DateTime.now();
  }
}
