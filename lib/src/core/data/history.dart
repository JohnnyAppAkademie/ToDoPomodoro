class HistoryEntry {
  final String tagUID;
  final String tagTitle;
  final String taskUID;
  final String taskTitle;
  final bool finished;
  final DateTime startedAt;
  final DateTime? endedAt;

  HistoryEntry({
    required this.tagUID,
    required this.tagTitle,
    required this.taskUID,
    required this.taskTitle,
    required this.finished,
    required this.startedAt,
    this.endedAt,
  });
}
