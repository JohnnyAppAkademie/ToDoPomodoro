/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/utils/extensions/context_extension.dart';
import 'package:todopomodoro/src/core/utils/task/task_provider.dart';

/*  Custom Widgets - Import */
import 'package:todopomodoro/src/core/widgets/custom_app_bar.dart';
import 'package:todopomodoro/src/core/widgets/custom_editable_text.dart';
import 'package:todopomodoro/src/view/task/widgets/task_selection.dialog.dart';

/* Tag / Task - Import */
import 'package:todopomodoro/src/data/tag.dart';
import 'package:todopomodoro/src/data/task.dart';

class TagSettingPage extends StatefulWidget {
  const TagSettingPage({super.key, this.tag});

  final Tag? tag;

  @override
  State<TagSettingPage> createState() => _TagSettingPageState();
}

class _TagSettingPageState extends State<TagSettingPage> {
  late TaskProvider taskController;
  late Tag? tag;
  late List<Task> tasks = [];

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController(
    text: "Initialer Text",
  );

  // ignore: prefer_final_fields
  Set<int> _tempTaskIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.tag != null) {
      tag = widget.tag;
      _textController.text = widget.tag!.name;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    taskController = context.watch<TaskProvider>();

    if (taskController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (widget.tag != null) {
      tag = widget.tag;
      tasks = taskController.readAllTasks(tag!);
    } else {
      tasks = taskController.tasks
          .where((task) => _tempTaskIds.contains(task.id))
          .toList();
    }

    return Scaffold(
      appBar: AppHeaderWidget(
        title: widget.tag != null ? "Tag - Adjustment" : "Tag - Creation",
        subtitle: widget.tag?.name,
        returnButton: true,
        callBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: context.hgap5,
                  left: context.wgap5,
                  bottom: context.hgap2,
                ),
                child: Text("Tag", style: context.textStyles.dark.labelSmall),
              ),
              CustomEditableText(
                controller: _textController,
                focusNode: _focusNode,
              ),
            ],
          ),
          SizedBox(height: context.hgap5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: context.wgap5),
                child: Text("Tasks", style: context.textStyles.dark.labelSmall),
              ),
              _taskList(
                context: context,
                taskController: taskController,
                tag: tag,
                tasks: tasks,
              ),
            ],
          ),
          _optionField(context, tag: tag, taskController: taskController),
        ],
      ),
    );
  }

  Widget _taskList({
    required BuildContext context,
    required TaskProvider taskController,
    required Tag? tag,
    required List<Task> tasks,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.hgap2,
        left: context.wgap5,
        right: context.wgap5,
      ),
      child: Container(
        height: context.screenHeight * 0.45,
        decoration: BoxDecoration(
          color: const Color(0xFF3D2645).withAlpha(30),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFF3D2645).withAlpha(50),
            width: 0.75,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.hgap1),
                child: Container(
                  height: context.screenHeight * 0.05,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D2645),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF3D2645),
                      width: 0.75,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.wgap5,
                          ),
                          child: Text(
                            tasks[index].title,
                            style: context.textStyles.light.labelSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: context.screenWidth * 0.15,
                          child: ElevatedButton(
                            style: context.buttonStyles.secondary,
                            onPressed: () => {
                              setState(() {
                                if (tag != null) {
                                  taskController.removeTaskFromTag(
                                    taskId: tasks[index].id,
                                    tagId: tag.id,
                                  );
                                } else {
                                  _tempTaskIds.remove(tasks[index].id);
                                }
                              }),
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: context.appStyle.writingHighlight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _optionField(
    BuildContext context, {
    required TaskProvider taskController,
    required Tag? tag,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.hgap2,
        horizontal: context.wgap5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: context.screenWidth * 0.30,
            height: context.screenHeight * 0.04,
            child: ElevatedButton(
              onPressed: () => _openTaskSelectionDialog(context),
              style: context.buttonStyles.primary,
              child: Text(
                "Add Tasks",
                style: context.textStyles.light.bodySmall,
              ),
            ),
          ),
          SizedBox(
            width: context.screenWidth * 0.30,
            height: context.screenHeight * 0.04,
            child: ElevatedButton(
              onPressed: () async {
                final tagName = _textController.text.trim();
                if (tagName.isEmpty) return;

                if (tag == null) {
                  final newId = DateTime.now().millisecondsSinceEpoch;
                  final newTag = Tag(
                    id: newId,
                    name: tagName,
                    taskIds: _tempTaskIds.toList(),
                  );
                  await taskController.addTag(tag: newTag);
                } else {
                  await taskController.renameTag(
                    tagID: tag.id,
                    newName: tagName,
                  );
                }

                // ignore: use_build_context_synchronously
                if (mounted) Navigator.pop(context);
              },
              style: context.buttonStyles.secondary,
              child: Text("Save", style: context.textStyles.dark.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openTaskSelectionDialog(BuildContext context) async {
    final allTasks = taskController.tasks;
    final currentSelection = tag?.taskIds.toSet() ?? _tempTaskIds;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TaskSelectionDialog(
        allTasks: allTasks,
        initiallySelected: currentSelection,
        onSave: (selectedIds) {
          setState(() {
            if (tag != null) {
              final tagId = tag!.id;
              final oldIds = Set<int>.from(tag!.taskIds);

              for (final id in selectedIds.difference(oldIds)) {
                taskController.addTaskToTag(taskId: id, tagId: tagId);
              }
              for (final id in oldIds.difference(selectedIds)) {
                taskController.removeTaskFromTag(taskId: id, tagId: tagId);
              }
            } else {
              _tempTaskIds
                ..clear()
                ..addAll(selectedIds);
            }
          });
        },
      ),
    );
  }
}
