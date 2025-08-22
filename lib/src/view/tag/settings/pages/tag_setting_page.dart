// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/app_provider.dart';

/* Custom Widget's - Import */
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/view/tag/settings/widgets/task_selection.dialog.dart';

/* Tag / Task - Import */
import 'package:todopomodoro/src/core/data/data.dart';

class TagSettingPage extends StatefulWidget {
  const TagSettingPage({super.key, this.tag});

  final Tag? tag;

  @override
  State<TagSettingPage> createState() => _TagSettingPageState();
}

class _TagSettingPageState extends State<TagSettingPage> {
  Tag? tag;
  List<Task> allTasks = [];
  List<Task> selectedTasks = [];

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  late AppProvider controller;

  @override
  void initState() {
    super.initState();
    tag = widget.tag ?? Tag(uID: '', title: '');
    _textController.text = tag!.title;
    _loadData();
  }

  Future<void> _loadData() async {
    controller = context.read<AppProvider>();
    allTasks = controller.tasks;

    if (tag!.uID.isNotEmpty) {
      selectedTasks = await controller.readAllTasks(tag: tag!);
    } else {
      selectedTasks = [];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    controller = context.watch<AppProvider>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppHeaderWidget(
        title: widget.tag != null ? "Tag - Adjustment" : "Tag - Creation",
        subtitle: widget.tag?.title,
        returnButton: true,
        callBack: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      body: Column(
        children: [
          _tagNaming(),
          SizedBox(height: context.hgap5),
          _taskListing(),
          SizedBox(height: context.hgap5),
          _tagOptions(tag: tag),
          SizedBox(height: context.hgap5),
        ],
      ),
    );
  }

  Widget _tagNaming() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: context.hgap5,
            left: context.wgap5,
            bottom: context.hgap1,
          ),
          child: Text("Tag", style: context.textStyles.dark.labelSmall),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: context.hgap2,
            left: context.wgap5,
            right: context.wgap5,
          ),
          child: CustomContainer(
            childWidget: CustomTextField(
              topic: "Enter a Tag name",
              textController: _textController,
              focusNode: _focusNode,
              isPassword: false,
              onChanged: (value) {
                setState(() {
                  tag!.title = value.trim();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.wgap5),
          child: Text("Tasks", style: context.textStyles.dark.labelSmall),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: context.hgap2,
            left: context.wgap5,
            right: context.wgap5,
          ),
          child: CustomContainer(
            hightLimit: 0.25,
            childWidget: Container(
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
                  itemCount: selectedTasks.length,
                  itemBuilder: (context, index) {
                    final task = selectedTasks[index];
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
                                  task.title,
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
                                  onPressed: () {
                                    setState(() {
                                      selectedTasks.removeAt(index);
                                    });
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
          ),
        ),
      ],
    );
  }

  Widget _tagOptions({required Tag? tag}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.hgap2,
        horizontal: context.wgap5,
      ),
      child: Column(
        children: [
          Row(
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
                    textAlign: TextAlign.center,
                    style: context.textStyles.light.bodyMedium,
                  ),
                ),
              ),
              SizedBox(
                width: context.screenWidth * 0.30,
                height: context.screenHeight * 0.04,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await _saveTagData();
                    if (!mounted) return;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tag name can't be empty!")),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Tag successfully saved!")),
                      );

                      Navigator.popUntil(context, (route) => route.isFirst);
                    });
                  },

                  style: context.buttonStyles.secondary,
                  child: Text(
                    "Save",
                    textAlign: TextAlign.center,
                    style: context.textStyles.dark.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.hgap2),
          if (tag!.uID != controller.getDefaultTagUID && tag.uID != "") ...[
            SizedBox(
              width: context.screenWidth * 0.75,
              child: ElevatedButton(
                style: context.buttonStyles.primary,
                onPressed: () {
                  if (tag.uID == controller.getDefaultTagUID) return;

                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    if (!mounted) return;

                    await controller.deleteTag(tag.uID);

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Tag successfully deleted!",
                          style: context.textStyles.highlight.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                        duration: const Duration(milliseconds: 1045),
                      ),
                    );

                    if (!mounted) return;
                    Navigator.pop(context);
                  });
                },
                child: Text('Delete Tag'),
              ),
            ),
            SizedBox(height: context.hgap2),
          ],
        ],
      ),
    );
  }

  Future<void> _openTaskSelectionDialog(BuildContext context) async {
    final tasks = controller.tasks;
    final currentSelection = selectedTasks.map((t) => t.uID).toSet();

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TaskSelectionDialog(
        allTasks: tasks,
        initiallySelected: currentSelection,
        onSave: (selectedIds) {
          setState(() {
            selectedTasks = tasks
                .where((t) => selectedIds.contains(t.uID))
                .toList();
          });
        },
      ),
    );
  }

  Future<bool> _saveTagData() async {
    if (tag == null || tag!.title.trim().isEmpty) return false;

    if (tag!.uID.isNotEmpty) {
      await controller.updateTag(tag!);
    } else {
      final newId = const Uuid().v4();
      tag = Tag(uID: newId, title: tag!.title, updatedAt: DateTime.now());
      await controller.addTag(tag!);
    }

    for (Task task in selectedTasks) {
      await controller.addTaskToTag(tagUID: tag!.uID, taskUID: task.uID);
    }

    return true;
  }
}
