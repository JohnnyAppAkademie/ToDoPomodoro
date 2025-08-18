// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

import 'package:todopomodoro/src/core/data/tag.dart';
import 'package:todopomodoro/src/core/data/task.dart';

import 'package:todopomodoro/src/core/utils/repositories/tag_repository.dart';
import 'package:todopomodoro/src/core/utils/repositories/task_repository.dart';

class AppProvider with ChangeNotifier {
  final TaskRepository taskRepo;
  final TagRepository tagRepo;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  List<Tag> _tags = [];
  List<Tag> get tags => _tags;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String get getSystemTag => tagRepo.getDefaultTagUID;

  AppProvider({required this.taskRepo, required this.tagRepo}) {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await taskRepo.getAll();
    _tags = await tagRepo.getAll();

    _isLoading = false;
    notifyListeners();
  }

  // ---------- Tasks ---------- //

  Future<void> addTask(Task task) async {
    await taskRepo.add(task);
    _tasks = await taskRepo.getAll();

    final tags = await tagRepo.getAll();
    final allTag = tags.firstWhere(
      (t) => t.uID == tagRepo.getDefaultTagUID,
      orElse: () {
        final newTag = Tag(
          uID: tagRepo.getDefaultTagUID,
          title: 'All Tasks',
          taskList: [],
        );
        tagRepo.add(newTag);
        return newTag;
      },
    );

    if (!allTag.taskList.contains(task.uID)) {
      allTag.taskList.add(task.uID);
      await tagRepo.update(allTag);
    }

    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await taskRepo.update(task);
    _tasks = await taskRepo.getAll();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await taskRepo.delete(id);
    _tasks = await taskRepo.getAll();
    notifyListeners();
  }

  Future<void> removeTaskFromTag({
    required String tagUID,
    required String taskUID,
  }) async {
    final allTags = await tagRepo.getAll();
    final tag = allTags.firstWhere((t) => t.uID == tagUID);
    tag.taskList.remove(taskUID);
    await tagRepo.update(tag);

    _tags = await tagRepo.getAll();

    notifyListeners();
  }

  Future<void> addTaskToTag({
    required String taskUID,
    required String tagUID,
  }) async {
    final tag = tags.firstWhere(
      (t) => t.uID == tagUID,
      orElse: () => throw Exception("Tag $tagUID nicht gefunden"),
    );

    if (tag.taskList.contains(taskUID)) return;

    tag.taskList.add(taskUID);

    _tags = await tagRepo.getAll();

    notifyListeners();
  }

  // ---------- Tags ---------- //

  Future<void> addTag(Tag tag) async {
    await tagRepo.add(tag);
    _tags = await tagRepo.getAll();
    notifyListeners();
  }

  Future<void> updateTag(Tag tag) async {
    await tagRepo.update(tag);
    _tags = await tagRepo.getAll();
    notifyListeners();
  }

  Future<void> deleteTag(String id) async {
    await tagRepo.delete(id);
    _tags = await tagRepo.getAll();
    notifyListeners();
  }

  List<Task> readAllTasks(Tag tag) {
    final List<Task> tagTasks = [];
    for (var tagtaskUID in tag.taskList) {
      for (var task in tasks) {
        if (task.uID == tagtaskUID) {
          tagTasks.add(task);
        }
      }
    }
    return tagTasks;
  }
}
