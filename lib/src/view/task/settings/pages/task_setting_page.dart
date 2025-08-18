import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';
import 'package:todopomodoro/src/core/utils/provider/app_provider.dart';
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/core/data/tag.dart';

/* Task-Logik - Importert */
import 'package:todopomodoro/src/core/data/task.dart';
import 'package:uuid/uuid.dart';

class TaskSettingPage extends StatefulWidget {
  const TaskSettingPage({super.key, this.task});

  final Task? task;

  @override
  State<TaskSettingPage> createState() => _TaskSettingPageState();
}

class _TaskSettingPageState extends State<TaskSettingPage> {
  /* Für denn Fall, dass ein Task übergeben wird */
  Task? task;

  /* Liste aller Tags */
  late List<Tag> tags = [];

  /*  Liste ausgewählte Tags  */
  late List<String> tagIds = [];

  /* Text - Controller */
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  late AppProvider controller;

  @override
  void initState() {
    super.initState();

    task =
        widget.task ?? Task(uID: '', title: '', duration: Duration(minutes: 5));
    _textController.text = task!.title;

    tagIds = context
        .read<AppProvider>()
        .tags
        .where((tag) => tag.taskList.contains(task!.uID))
        .map((tag) => tag.uID)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    controller = context.watch<AppProvider>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    tags = controller.tags;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppHeaderWidget(
        title: widget.task != null ? "Task - Adjustment" : "Task - Creation",
        subtitle: widget.task?.title,
        returnButton: true,
        callBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: context.hgap5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*  Task-Name  */
            _taskNaming(),
            SizedBox(height: context.hgap5),

            /*  Tag-Liste */
            _tagListing(),
            SizedBox(height: context.hgap5),

            /* Task-Dauer */
            _taskDuration(),
            SizedBox(height: context.hgap5),

            /* Task-Save  */
            _taskSave(),
            SizedBox(height: context.hgap2),
          ],
        ),
      ),
    );
  }

  /* Widgets */

  Widget _taskNaming() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: context.hgap5,
            left: context.wgap5,
            bottom: context.hgap2,
          ),
          child: Text("Task", style: context.textStyles.dark.labelSmall),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: context.hgap2,
            left: context.wgap5,
            right: context.wgap5,
          ),
          child: CustomContainer(
            childWidget: CustomTextField(
              topic: "Enter a Taskname",
              textController: _textController,
              focusNode: _focusNode,
              isPassword: false,
              onChanged: (value) {
                setState(() {
                  task!.title = value.trim();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _tagListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.wgap5, bottom: context.hgap2),
          child: Text(
            "Associated Tags",
            style: context.textStyles.dark.labelSmall,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.wgap5),
          child: CustomContainer(
            hightLimit: 0.10,
            childWidget: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: tags.length - 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final Tag tag = tags[index + 1];
                final bool taskInTag = tagIds.contains(tag.uID);

                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      taskInTag
                          ? context.appStyle.buttonBackgroundLight.withValues(
                              alpha: 0.25,
                            )
                          : context.appStyle.buttonBackgroundLight,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (taskInTag) {
                        tagIds.remove(tag.uID);
                      } else {
                        tagIds.add(tag.uID);
                      }
                    });
                  },
                  child: Text(
                    tag.title,
                    style: TextStyle(color: context.appStyle.writingHighlight),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskDuration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.wgap5, bottom: context.hgap2),
          child: Text(
            "Duration of the Task - ${task!.duration.inMinutes} min",
            style: context.textStyles.dark.labelSmall,
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.wgap5),
          child: CustomContainer(
            hightLimit: 0.15,
            childWidget: Scrollbar(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 45,
                perspective: 0.002,
                diameterRatio: 1.5,
                onSelectedItemChanged: (index) {
                  setState(() {
                    task!.duration = Duration(minutes: index);
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) => Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: context.textStyles.highlight.labelLarge,
                    ),
                  ),
                  childCount: 91,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskSave() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.hgap2,
            horizontal: context.wgap5,
          ),
          child: SizedBox(
            width: context.screenWidth * 0.30,
            height: context.screenHeight * 0.04,
            child: ElevatedButton(
              onPressed: () async {
                if (task!.title.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Task name can't be empty!",
                        style: context.textStyles.highlight.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                  return;
                }
                if (task!.uID != '') {
                  await controller.updateTask(task!);
                } else {
                  task!.uID = const Uuid().v4();

                  await controller.addTask(
                    Task(
                      uID: task!.uID,
                      title: task!.title,
                      duration: task!.duration,
                    ),
                  );
                }

                for (String tag in tagIds) {
                  await controller.addTaskToTag(
                    taskUID: task!.uID,
                    tagUID: tag,
                  );
                }

                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Task successfully saved!",
                      // ignore: use_build_context_synchronously
                      style: context.textStyles.highlight.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              style: context.buttonStyles.secondary,
              child: Text(
                "Save",
                style: context.textStyles.highlight.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
