import 'package:uuid/uuid.dart';

class Task {
  int? dbID;
  String uID;
  String title;
  final String userID;
  Duration duration;
  DateTime updatedAt;

  Task({
    this.dbID,
    required this.uID,
    required this.title,
    required this.duration,
    required this.userID,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory Task.newTag(String title, String userId) {
    return Task(
      uID: const Uuid().v4(),
      title: title,
      duration: Duration(minutes: 5),
      userID: userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'u_id': uID,
      'user_id': userID,
      'title': title,
      'duration': duration.inMinutes,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      dbID: map['db_id'],
      uID: map['u_id'],
      userID: map['user_id'],
      title: map['title'],
      duration: Duration(minutes: map['duration']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
