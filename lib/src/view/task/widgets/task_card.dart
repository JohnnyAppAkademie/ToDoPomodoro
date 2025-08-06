/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/utils/extensions/context_extension.dart';

/*  Tag - Logik  */
import 'package:todopomodoro/src/data/tag.dart';

/*  Task - Logik  */
import 'package:todopomodoro/src/data/task.dart';

/* Page - Import */
import 'package:todopomodoro/src/view/pomodoro/pages/pomodoro_page.dart';
import 'package:todopomodoro/src/view/task/pages/task_setting_page.dart';

/*  Provider - Import  */
import 'package:todopomodoro/src/core/utils/task/task_provider.dart';

/// __TaskCard__ - Class
/// <br> Beinhaltet den Aufbau der TaskCard. <br>
/// <br> __Required__:
/// * Der Task, welcher für die TaskCard benötigt werden soll __[Task : t]__
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.tag, required this.task});

  final Task task;
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return taskCard(context: context, tag: tag, task: task);
  }

  //  ----------------  Widgets  ---------------- //

  /// __TaskCard__ - Widget
  ///<br> Baut eine Task-Card samt Optionen auf. <br>
  ///<br> __Benötigt__:
  ///* Die Aufgabe die abgebildet werden soll __[Task : t]__
  Widget taskCard({
    required BuildContext context,
    required Tag tag,
    required Task task,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.appStyle.gradient1,
                    context.appStyle.gradient2,
                    context.appStyle.gradient3,
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        task.title,
                        style: context.textStyles.light.labelLarge,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 60),
                          Icon(Icons.timer, color: Colors.white, size: 16),
                          SizedBox(width: 10),
                          Text(
                            '${task.duration.inMinutes.toString()} min',
                            style: context.textStyles.light.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: context.appStyle.labelBackground,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: cardButton(
                      context: context,
                      iconData: Icons.delete_outline_outlined,
                      label: "Delete",
                      callBack: () => deleteButtonPress(
                        context: context,
                        tag: tag,
                        task: task,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: cardButton(
                      context: context,
                      iconData: Icons.play_arrow_outlined,
                      label: "Start",
                      callBack: () =>
                          taskButtonPress(context: context, task: task),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: cardButton(
                      context: context,
                      iconData: Icons.settings_outlined,
                      label: "Settings",
                      callBack: () =>
                          settingButtonPress(context: context, task: task),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// __cardButton__ - Widget
  ///<br> Stellt die Buttons für die Bottom Card her. <br>
  ///<br> __Benötigt__:
  ///* Das Icon für den Button __[IconData : iconData]__
  ///* Der Text für den Button __[Text : label]__
  Widget cardButton({
    required BuildContext context,
    required IconData iconData,
    required String label,
    required VoidCallback callBack,
  }) {
    return ElevatedButton(
      style: context.buttonStyles.card,
      onPressed: callBack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, size: 20, color: context.appStyle.writingHighlight),
          SizedBox(width: 4),
          Text(label, style: context.textStyles.highlight.bodyMedium),
        ],
      ),
    );
  }

  //  ----------------  Funktionen  ---------------- //

  VoidCallback taskButtonPress({
    required BuildContext context,
    required Task task,
  }) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PomodoroTimerPage(task: task)),
      );
    };
  }

  VoidCallback settingButtonPress({
    required BuildContext context,
    required Task task,
  }) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskSettingPage(task: task)),
      );
    };
  }

  VoidCallback deleteButtonPress({
    required BuildContext context,
    required Tag tag,
    required Task task,
  }) {
    return () {
      if (tag.id == TaskProvider.systemTagId) {
        context.read<TaskProvider>().deleteTask(task);
      } else {
        context.read<TaskProvider>().removeTaskFromTag(
          taskId: task.id,
          tagId: tag.id,
        );
      }
    };
  }
}
