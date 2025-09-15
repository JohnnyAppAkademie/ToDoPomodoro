/* Genral Import */
import 'package:uuid/uuid.dart';

/// `HistoryEntry`- Class <br>
/// <br> __Info:__
/// <br>  Creates a History-Entries.  <br>
class HistoryEntry {
  final String uID;
  final String taskName;
  final String userID;
  bool finished;
  DateTime startedAt;
  DateTime? endedAt;

  /// `HistoryEntry` - Constructor <br>
  /// <br>  __Info:__
  /// <br>  __Do not use this constructor,__
  /// <br>  __use `HistoryEntry.newHistoryEntry` instead__ <br>
  HistoryEntry({
    required this.uID,
    required this.taskName,
    required this.userID,
    required this.finished,
    required this.startedAt,
    this.endedAt,
  });

  /// `HistoryEntry` - Constructor (Factory) <br>
  /// <br>  __Info:__
  /// <br>  Creates a new `HistoryEntry`-Object.  <br>
  /// <br>  __Required:__ <br>
  /// * [__String : taskName__] - _The Name of the Task_
  /// * [__String : userID__] - _The ID of the User_
  ///
  /// <br>  __Optional:__ <br>
  /// * [__DateTime : startedAt__]  - _The startime of the Task_
  /// * [__bool : finished__] - _Was the Task finished?_
  /// * [__DateTime : endedAt__]  - _The endtime of the Task_
  factory HistoryEntry.newHistoryEntry({
    required String taskName,
    required String userID,
    bool finished = false,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return HistoryEntry(
      uID: const Uuid().v4(),
      taskName: taskName,
      userID: userID,
      finished: finished,
      startedAt: startedAt ?? DateTime.now(),
      endedAt: endedAt,
    );
  }

  /// `HistoryEntry` - Constructor (Factory) <br>
  /// <br>  __Info:__
  /// <br> Creats a `HistoryEntry`-Object from a Json-Map <br>
  /// <br>  __Required:__ <br>
  /// * [__Map<String, dynamic> : json__] - _The Json-Data which gets transformed_
  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      uID: json['u_id'],
      taskName: json['task_name'],
      userID: json['user_id'],
      finished: json['finished'] == 1,
      startedAt: DateTime.parse(json['started_at']),
      endedAt: json['ended_at'] != null
          ? DateTime.tryParse(json['ended_at'])
          : null,
    );
  }

  /// `HistoryEntry - toJson()` <br>
  /// <br>  __Info:__
  /// <br> Converts the `HistoryEntry` object into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'u_id': uID,
      'task_name': taskName,
      'user_id': userID,
      'finished': finished ? 1 : 0,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
    };
  }
}
