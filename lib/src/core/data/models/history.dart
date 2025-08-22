import 'package:uuid/uuid.dart';

class History {
  int? dbID;
  final String uID;
  final String taskUID;
  final String tagUID;
  bool finished;
  final DateTime startedAt;
  DateTime? endedAt;

  History({
    this.dbID,
    required this.uID,
    required this.taskUID,
    required this.tagUID,
    required this.finished,
    required this.startedAt,
    this.endedAt,
  });

  factory History.newTag(String taskUID, String tagUID) {
    return History(
      uID: const Uuid().v4(),
      taskUID: taskUID,
      tagUID: tagUID,
      finished: false,
      startedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'db_id': dbID,
    'u_id': uID,
    'task_uid': taskUID,
    'tag_uid': taskUID,
    'finished': finished ? 1 : 0,
    'started_at': startedAt.toIso8601String(),
    'ended_at': endedAt?.toIso8601String(),
  };

  factory History.fromMap(Map<String, dynamic> map) => History(
    dbID: map['db_id'] as int?,
    uID: map['u_id'] as String,
    taskUID: map['task_uid'] as String,
    tagUID: map['tag_uid'] as String,
    finished: (map['finished'] as int) == 1,
    startedAt: DateTime.parse(map['started_at'] as String),
    endedAt: map['ended_at'] != null
        ? DateTime.parse(map['ended_at'] as String)
        : null,
  );
}
