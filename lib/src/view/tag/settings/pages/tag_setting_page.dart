// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';
import 'package:todopomodoro/src/core/utils/provider/app_provider.dart';
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';

/*  Custom Widgets - Import */
import 'package:todopomodoro/src/view/tag/settings/widgets/task_selection.dialog.dart';

/* Tag / Task - Import */
import 'package:todopomodoro/src/core/data/tag.dart';
import 'package:todopomodoro/src/core/data/task.dart';
import 'package:uuid/uuid.dart';

class TagSettingPage extends StatefulWidget {
  const TagSettingPage({super.key, this.tag});

  final Tag? tag;

  @override
  State<TagSettingPage> createState() => _TagSettingPageState();
}

class _TagSettingPageState extends State<TagSettingPage> {
  /* Für denn Fall, dass ein Task übergeben wird */
  Tag? tag;

  /* Liste aller Tasks */
  late List<Task> tasks = [];

  /*  Set der Tasks in diesem Tag */
  late Set<String> taskSet;

  /* Text - Controller */
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  /* Controller */
  late AppProvider controller;

  @override
  void initState() {
    super.initState();
    tag = widget.tag ?? Tag(uID: '', title: '', taskList: []);
    taskSet = tag!.taskList.toSet();
    _textController.text = tag!.title;

    tasks = context
        .read<AppProvider>()
        .tasks
        .where((task) => tag!.taskList.contains(task.uID))
        .toList();
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
        callBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          /*  Tag-Name */
          _tagNaming(),
          SizedBox(height: context.hgap5),

          /*  Task-List */
          _taskListing(),
          SizedBox(height: context.hgap5),

          /*  Tag - Optionen  */
          _tagOptions(tag: tag),
          SizedBox(height: context.hgap5),
        ],
      ),
    );
  }

  /*  Widgets */
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
        /*  Label  */
        Padding(
          padding: EdgeInsets.only(left: context.wgap5),
          child: Text("Tasks", style: context.textStyles.dark.labelSmall),
        ),
        /*  Task - Liste */
        Padding(
          padding: EdgeInsets.only(
            top: context.hgap2,
            left: context.wgap5,
            right: context.wgap5,
          ),
          /*  Container */
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
                  itemCount: tag!.taskList.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasks.firstWhere(
                      (t) => t.uID == tag!.taskList[index],
                      orElse: () => Task(
                        uID: "INVALID",
                        title: "Task not found",
                        duration: Duration.zero,
                      ),
                    );

                    if (task.uID == "INVALID") {
                      return SizedBox.shrink();
                    }

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
                                      tag!.taskList.removeAt(index);
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
                    style: context.textStyles.light.bodyMedium,
                  ),
                ),
              ),
              SizedBox(
                width: context.screenWidth * 0.30,
                height: context.screenHeight * 0.04,
                child: ElevatedButton(
                  onPressed: _saveTag,
                  style: context.buttonStyles.secondary,
                  child: Text(
                    "Save",
                    style: context.textStyles.dark.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.hgap2),

          /*  Delete Tag */
          if (tag!.uID != controller.getSystemTag) ...[
            SizedBox(
              width: context.screenWidth * 0.75,
              child: ElevatedButton(
                style: context.buttonStyles.primary,
                onPressed: () {
                  if (tag.uID != controller.getSystemTag) {
                    controller.deleteTag(tag.uID);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Tag successfully deleted!",
                          style: context.textStyles.highlight.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 1, milliseconds: 45),
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Delete Tag",
                  style: context.textStyles.light.labelLarge,
                ),
              ),
            ),
            SizedBox(height: context.hgap2),
          ],
        ],
      ),
    );
  }

  /*  Dialoge */
  Future<void> _openTaskSelectionDialog(BuildContext context) async {
    final tasks = controller.tasks;
    final currentSelection = tag!.taskList.toSet();

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TaskSelectionDialog(
        allTasks: tasks,
        initiallySelected: currentSelection,
        onSave: (selectedIds) {
          setState(() {
            tag!.taskList = selectedIds.toList();
          });
        },
      ),
    );
  }

  /*  Funktionen  */
  Future<void> _saveTag() async {
    if (tag == null) return;

    if (tag!.title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Tag name can't be empty!",
            style: context.textStyles.highlight.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    if (tag!.uID != "") {
      await controller.updateTag(tag!);
    } else {
      final newUID = const Uuid().v4();

      await controller.addTag(
        Tag(uID: newUID, title: tag!.title, taskList: tag!.taskList),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tag successfully saved!",
          style: context.textStyles.highlight.labelSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );

    Navigator.pop(context);
  }
}
