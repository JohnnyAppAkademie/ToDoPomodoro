import 'package:uuid/uuid.dart';

class Tag {
  int? dbID;
  String uID;
  String title;
  List<String> taskList;
  DateTime updatedAt;

  Tag({
    this.dbID,
    required this.uID,
    required this.title,
    required this.taskList,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory Tag.newTag(String title) {
    return Tag(uID: const Uuid().v4(), title: title, taskList: []);
  }
}
