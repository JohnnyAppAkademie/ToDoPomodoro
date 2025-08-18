import 'package:todopomodoro/src/core/data/repository.dart';
import 'package:todopomodoro/src/core/data/tag.dart';

class TagRepository implements Repository<Tag> {
  static const String defaultTagUID = '00000000-0000-0000-0000-000000000000';
  String get getDefaultTagUID => defaultTagUID;

  TagRepository() {
    _ensureSystemTagExists();
  }

  void _ensureSystemTagExists() {
    final exists = _tags.any((t) => t.uID == defaultTagUID);
    if (!exists) {
      _tags.add(Tag(uID: defaultTagUID, title: 'All Tasks', taskList: []));
    }
  }

  final List<Tag> _tags = [];

  @override
  Future<List<Tag>> getAll() async {
    _ensureSystemTagExists();
    return _tags;
  }

  @override
  Future<void> add(Tag tag) async {
    _tags.add(tag);
  }

  @override
  Future<void> update(Tag updatedTag) async {
    final index = _tags.indexWhere((t) => t.uID == updatedTag.uID);
    if (index != -1) {
      _tags[index] = updatedTag;
    } else {
      return;
    }
  }

  @override
  Future<void> delete(String uID) async {
    if (uID == defaultTagUID) {
      throw Exception("The Main-Tag can't be deleted");
    }
    _tags.removeWhere((t) => t.uID == uID);
  }
}
