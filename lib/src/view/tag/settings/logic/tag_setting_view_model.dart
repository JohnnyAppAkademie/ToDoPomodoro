// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/services/session_service.dart';
import 'package:todopomodoro/src/core/util/one_time_event.dart';
import 'package:uuid/uuid.dart';

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart' show Tag, Task;

/* App Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider;

enum TagSettingEventType { showSnackBar, navigateBack }

class TagSettingEvent {
  final TagSettingEventType type;
  final String? message;

  TagSettingEvent({required this.type, this.message});
}

class TagSettingViewModel extends ChangeNotifier {
  final TaskProvider appProvider;
  Tag tag;
  List<Task> allTasks = [];
  List<Task> selectedTasks = [];
  bool isLoading = true;

  final ValueNotifier<OneTimeEvent<TagSettingEvent>?> eventNotifier =
      ValueNotifier(null);

  TagSettingViewModel({required this.appProvider, Tag? initialTag})
    : tag = initialTag ?? Tag(uID: '', title: '', userID: '') {
    _loadUserId();

    _init();
  }

  Future<void> _loadUserId() async {
    final userId = await SessionManager.getUserId() ?? '';
    tag = Tag(uID: tag.uID, title: tag.title, userID: userId);
  }

  void _init() async {
    allTasks = appProvider.tasks;

    if (tag.uID.isNotEmpty) {
      selectedTasks = await appProvider.readAllTasks(tag: tag);
    }

    isLoading = false;
    notifyListeners();
  }

  void updateTitle(String value) {
    tag.title = value.trim();
    notifyListeners();
  }

  void toggleTaskSelection(Task task) {
    if (selectedTasks.any((t) => t.uID == task.uID)) {
      selectedTasks.removeWhere((t) => t.uID == task.uID);
    } else {
      selectedTasks.add(task);
    }
    notifyListeners();
  }

  Future<void> saveTag() async {
    if (tag.title.isEmpty) {
      eventNotifier.value = OneTimeEvent(
        TagSettingEvent(
          type: TagSettingEventType.showSnackBar,
          message: "Tag name can't be empty!",
        ),
      );
      return;
    }

    if (tag.uID.isNotEmpty) {
      await appProvider.updateTag(tag);
    } else {
      tag = Tag(
        uID: const Uuid().v4(),
        title: tag.title,
        userID: tag.userID,
        updatedAt: DateTime.now(),
      );
      await appProvider.addTag(tag);
    }

    for (Task task in selectedTasks) {
      await appProvider.addTaskToTag(tagUID: tag.uID, taskUID: task.uID);
    }

    eventNotifier.value = OneTimeEvent(
      TagSettingEvent(
        type: TagSettingEventType.showSnackBar,
        message: "Tag successfully saved!",
      ),
    );

    eventNotifier.value = OneTimeEvent(
      TagSettingEvent(type: TagSettingEventType.navigateBack),
    );
  }

  Future<void> deleteTag() async {
    if (tag.uID == appProvider.getDefaultTagUID) return;

    await appProvider.deleteTag(tag.uID);
    eventNotifier.value = OneTimeEvent(
      TagSettingEvent(
        type: TagSettingEventType.showSnackBar,
        message: "Tag successfully deleted!",
      ),
    );
    eventNotifier.value = OneTimeEvent(
      TagSettingEvent(type: TagSettingEventType.navigateBack),
    );
  }

  void updateSelectedTasks(List<Task> tasks) {
    selectedTasks = tasks;
    notifyListeners();
  }
}
