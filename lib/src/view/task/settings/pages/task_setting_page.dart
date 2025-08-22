// ignore_for_file: use_build_context_synchronously

/*  General Import */
import 'package:todopomodoro/src/core/widgets/models/custom_button.dart';
import 'package:todopomodoro/src/view/task/settings/widgets/tag_listing.dart';
import 'package:todopomodoro/src/view/task/settings/widgets/task_duration_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';
/*  Provider - Import */
import 'package:todopomodoro/src/core/provider/app_provider.dart';

/*  Data - Import */
import 'package:todopomodoro/src/core/data/data.dart' show Task, Tag;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';

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

    // Tags über den Provider laden
    if (task!.uID != '') {
      _loadTagsFromProvider();
    }
  }

  Future<void> _loadTagsFromProvider() async {
    final appProvider = context.read<AppProvider>();

    // Tags der Task laden
    final tags = await appProvider.readAllTagsfromTask(task: task!);

    setState(() {
      tagIds = tags.map((tag) => tag.uID).toList();
    });
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
        callBack: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: context.hgap5),
        child: Column(
          spacing: context.hgap2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*  Task-Name  */
            _taskNaming(),
            SizedBox(height: context.hgap5),

            /*  Tag-Liste */
            TagListing(
              allTags: tags,
              chosenTags: tagIds,
              onTagPressed: (tagId) {
                setState(() {
                  if (tagIds.contains(tagId)) {
                    tagIds.remove(tagId);
                  } else {
                    tagIds.add(tagId);
                  }
                });
              },
            ),
            SizedBox(height: context.hgap5),

            /* Task-Dauer */
            TaskDurationPicker(
              duration: task!.duration,
              onChanged: (duration) {
                setState(() {
                  task!.duration = duration;
                });
              },
            ),
            SizedBox(height: context.hgap5),

            /* Task-Save  */
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.hgap2,
                horizontal: context.wgap5,
              ),
              child: SizedBox(
                width: context.screenWidth * 0.30,
                height: context.screenHeight * 0.05,
                child: WhiteButton(label: "Save", func: _saveTask),
              ),
            ),
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
          padding: EdgeInsets.only(top: context.hgap5, left: context.wgap5),
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

  /*  Functions */
  Future<void> _saveTask() async {
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

    // Speichern oder Updaten
    if (task!.uID.isNotEmpty) {
      await controller.updateTask(task!);
    } else {
      final newId = const Uuid().v4();
      task!.uID = newId;

      await controller.addTask(
        Task(uID: task!.uID, title: task!.title, duration: task!.duration),
      );
    }

    // Tags speichern – jetzt als Batch
    await Future.wait([
      for (String tag in tagIds)
        controller.addTaskToTag(taskUID: task!.uID, tagUID: tag),
    ]);

    // Snackbar anzeigen
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Task successfully saved!",
            style: context.textStyles.highlight.labelSmall,
            textAlign: TextAlign.center,
          ),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }

    // Navigation ENTKOPPELT vom Frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }
}
