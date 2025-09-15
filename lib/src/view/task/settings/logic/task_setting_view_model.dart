/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/services/session_service.dart';
import 'package:uuid/uuid.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider;

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart';

/// `TaskSettingViewModel` - Class <br>
/// <br>  __Info:__
/// <br>  A View Model for the Task-Setting-Page <br>
/// <br>  __Required:__ <br>
/// * [ __TaskProvider : taskProvider__ ] - A TaskProvider to control Task / Tag - Managment
///
/// <br>  __Optional:__ <br>
/// * [ __Task : initialTask__ ] - A inital Task for Editting / otherwise a new Task gets created
/// * [ __Tag : tag__ ] - A Tag, if the option was called within a Tag ( necessary if Task gets deleted )
class TaskSettingViewModel extends ChangeNotifier {
  /*  TaskProvider    */
  final TaskProvider taskProvider;

  /*  Editable Task   */
  Task task;

  /* Origin of the Task, from where the Task-Setting's Option has been called */
  Tag? tag;

  /* List of all Tags */
  List<Tag> allTags = [];

  /* List of selected Tag, in which the Task shall be added */
  List<String> selectedTagIds = [];

  /* ViewModel - Load-Flag */
  bool isLoading = false;

  /// `TaskSettingViewModel - Constructor` <br>
  /// <br>  __Info:__
  /// <br>  Creates a `TaskSettingViewModel` - Object.  <br>
  /// <br>  __Required:__
  /// * [ __TaskProvider : TaskProvider__ ] - Provider for Task-Controller
  ///
  /// <br>  __Optional:__
  /// *  [ __Task : initialTask__ ] - If a task needs to be edited
  /// *  [ __Tag : tag__ ] - The Origin of the Task, if task is not newly created
  TaskSettingViewModel({
    required this.taskProvider,
    Task? initialTask,
    this.tag,
  }) : task =
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

  /// `TaskSettingViewModel - _loadUserId()` <br>
  /// <br>  __Info:__
  /// <br>  Adds the current User to the task <br>
  Future<void> _loadUserId() async {
    final userId = await SessionManager.getUserId() ?? '';
    task = Task(
      uID: task.uID,
      title: task.title,
      duration: task.duration,
      userID: userId,
    );
  }

  /// `TaskSettingViewModel - _init()` <br>
  /// <br>  __Info:__
  /// <br>  Initialize the View Model <br>
  Future<void> _init() async {
    isLoading = true;
    notifyListeners();

    /*  Get all User - Tags */
    allTags = await taskProvider.getAllTags();
    if (task.uID.isNotEmpty) {
      final tags = await taskProvider.readAllTagsfromTask(task: task);
      selectedTagIds = tags.map((tag) => tag.uID).toList();
    }

    isLoading = false;
    notifyListeners();
  }

  /// `TaskSettingViewModel - updateTitle()` <br>
  /// <br>  __Info:__
  /// <br>  Updating the title of the task <br>
  /// <br>  __Required:__
  /// * [ __String : value__ ] - The new name of the task
  void updateTitle(String value) {
    task.title = value.trim();
    notifyListeners();
  }

  /// `TaskSettingViewModel - toggleTagSelection()` <br>
  /// <br>  __Info:__
  /// <br>  Updating the title of the task <br>
  /// <br>  __Required:__
  /// * [ __String : tagID__ ] - The tagID to be added to the list
  void toggleTagSelection(String tagID) {
    selectedTagIds.contains(tagID)
        ? selectedTagIds.remove(tagID)
        : selectedTagIds.add(tagID);
    notifyListeners();
  }

  /// `TaskSettingViewModel - updateDuration()` <br>
  /// <br>  __Info:__
  /// <br>  Updating the duration of the task <br>
  /// <br>  __Required:__
  /// * [ __Duration : duration__ ] - The new duration of the task
  void updateDuration(Duration duration) {
    task.duration = duration;
    notifyListeners();
  }

  /// `TaskSettingViewModel - saveTask()` <br>
  /// <br>  __Info:__
  /// <br>  Saves the new built task <br>
  Future<void> saveTask() async {
    if (task.uID.isNotEmpty) {
      await taskProvider.updateTask(task);
    } else {
      task.uID = const Uuid().v4();
      await taskProvider.addTask(
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
        (tag) => taskProvider.addTaskToTag(taskUID: task.uID, tagUID: tag),
      ),
    );
  }

  /// `TaskSettingViewModel - deleteTask()` <br>
  /// <br>  __Info:__
  /// <br>  Deletes the task from the tag.
  /// <br>  If the task was called from the default Tag, it will be deleted everywhere. <br>
  Future<void> deleteTask() async {
    if (tag == null) return;

    if (tag!.uID == taskProvider.getDefaultTagUID) {
      await taskProvider.deleteTask(task.uID);
    } else {
      await taskProvider.removeTaskFromTag(taskUID: task.uID, tagUID: tag!.uID);
    }
  }
}
