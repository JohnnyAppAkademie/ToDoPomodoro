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

  factory Task.newTag(String title) {
    return Task(
      uID: const Uuid().v4(),
      title: title,
      duration: Duration(minutes: 5),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'db_id': dbID,
      'u_id': uID,
      'title': title,
      'duration': duration.inMinutes,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      dbID: map['db_id'],
      uID: map['u_id'],
      title: map['title'],
      duration: Duration(minutes: map['duration']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
