import 'package:uuid/uuid.dart';

class Tag {
  int? dbID;
  String uID;
  String title;
  DateTime updatedAt;

  Tag({this.dbID, required this.uID, required this.title, DateTime? updatedAt})
    : updatedAt = updatedAt ?? DateTime.now();

  factory Tag.newTag(String title) {
    return Tag(uID: const Uuid().v4(), title: title, updatedAt: DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'db_id': dbID,
      'u_id': uID,
      'title': title,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      dbID: map['db_id'],
      uID: map['u_id'],
      title: map['title'],
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
