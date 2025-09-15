/* General Import */
import 'package:uuid/uuid.dart';

class Tag {
  int? dbID;
  String uID;
  final String userID;
  String title;
  DateTime updatedAt;

  Tag({
    this.dbID,
    required this.uID,
    required this.title,
    required this.userID,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory Tag.newTag({required String title, required String userID}) {
    return Tag(
      uID: const Uuid().v4(),
      title: title,
      userID: userID,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'u_id': uID,
      'title': title,
      'user_id': userID,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      dbID: map['db_id'],
      uID: map['u_id'],
      title: map['title'],
      userID: map['user_id'],
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
