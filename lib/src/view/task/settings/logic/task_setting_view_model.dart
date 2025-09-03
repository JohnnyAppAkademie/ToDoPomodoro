/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/services/session_service.dart';
import 'package:uuid/uuid.dart';
import 'package:todopomodoro/src/core/util/one_time_event.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider;

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart';

enum TaskSettingEventType { showSnackBar, navigateBack, showDeleteDialog }

class TaskSettingEvent {
  final TaskSettingEventType type;
  final String? message;
  const TaskSettingEvent(this.type, {this.message});
}

class TaskSettingViewModel extends ChangeNotifier {
  final TaskProvider appProvider;

  Task task;
  Tag? tag;
  List<Tag> allTags = [];
  List<String> selectedTagIds = [];
  bool isLoading = false;

  final ValueNotifier<OneTimeEvent<TaskSettingEvent>?> eventNotifier =
      ValueNotifier(null);

  TaskSettingViewModel({required this.appProvider, Task? initialTask, this.tag})
    : task =
          initialTask ??
          Task(
            uID: '',
            title: '',
            duration: const Duration(minutes: 5),
            userID: '',
          ) {
    _loadUserId();

    _init();
  }

  Future<void> _loadUserId() async {
    final userId = await SessionManager.getUserId() ?? '';
    task = Task(
      uID: task.uID,
      title: task.title,
      duration: task.duration,
      userID: userId,
    );
  }

  Future<void> _init() async {
    isLoading = true;
    notifyListeners();

    allTags = appProvider.tags;
    if (task.uID.isNotEmpty) {
      final tags = await appProvider.readAllTagsfromTask(task: task);
      selectedTagIds = tags.map((tag) => tag.uID).toList();
    }

    isLoading = false;
    notifyListeners();
  }

  void updateTitle(String value) {
    task.title = value.trim();
    notifyListeners();
  }

  void toggleTagSelection(String tagId) {
    selectedTagIds.contains(tagId)
        ? selectedTagIds.remove(tagId)
        : selectedTagIds.add(tagId);
    notifyListeners();
  }

  void updateDuration(Duration duration) {
    task.duration = duration;
    notifyListeners();
  }

  Future<void> saveTask() async {
    if (task.title.trim().isEmpty) {
      eventNotifier.value = OneTimeEvent(
        const TaskSettingEvent(
          TaskSettingEventType.showSnackBar,
          message: "Task name can't be empty!",
        ),
      );
      return;
    }

    if (task.uID.isNotEmpty) {
      await appProvider.updateTask(task);
    } else {
      task.uID = const Uuid().v4();
      await appProvider.addTask(
        Task(
          uID: task.uID,
          title: task.title,
          duration: task.duration,
          userID: task.userID,
        ),
      );
    }

    await Future.wait(
      selectedTagIds.map(
        (tag) => appProvider.addTaskToTag(taskUID: task.uID, tagUID: tag),
      ),
    );

    eventNotifier.value = OneTimeEvent(
      const TaskSettingEvent(
        TaskSettingEventType.showSnackBar,
        message: "Task successfully saved!",
      ),
    );
  }

  void requestDeleteDialog() {
    eventNotifier.value = OneTimeEvent(
      TaskSettingEvent(TaskSettingEventType.showDeleteDialog),
    );
  }

  Future<void> deleteTask() async {
    if (tag == null) return;

    if (tag!.uID == appProvider.getDefaultTagUID) {
      await appProvider.deleteTask(task.uID);
      eventNotifier.value = OneTimeEvent(
        TaskSettingEvent(
          TaskSettingEventType.showSnackBar,
          message: "Task permanently deleted!",
        ),
      );
    } else {
      await appProvider.removeTaskFromTag(taskUID: task.uID, tagUID: tag!.uID);
      eventNotifier.value = OneTimeEvent(
        TaskSettingEvent(
          TaskSettingEventType.showSnackBar,
          message: "Task removed from tag!",
        ),
      );
    }
  }
}
