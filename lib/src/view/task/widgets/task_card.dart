/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*  Tag - Logik  */
import 'package:todopomodoro/src/data/tag.dart';

/*  TaskPage - Logik  */
import 'package:todopomodoro/src/data/task.dart';
import 'package:todopomodoro/src/view/pomodoro/pages/pomodoro_page.dart';
import 'package:todopomodoro/src/view/task/pages/task_setting_page.dart';

/*  Provider - Import  */
import 'package:todopomodoro/src/core/utils/task/task_provider.dart';

/*  General - Design  */
import 'package:todopomodoro/style.dart';

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
    return taskCard(tag, task, context);
  }

  //  ----------------  Widgets  ---------------- //

  /// __TaskCard__ - Widget
  ///<br> Baut eine Task-Card samt Optionen auf. <br>
  ///<br> __Benötigt__:
  ///* Die Aufgabe die abgebildet werden soll __[Task : t]__
  Widget taskCard(Tag tag, Task task, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [cardTopTheme(task), cardBottomTheme(tag, task, context)],
        ),
      ),
    );
  }

  ///  __cardTopTheme__ - Widget
  ///<br> Baut den oberen Teil der Task-Card auf. <br>
  ///<br> __Benötigt__:
  ///* Die Aufgabe die ausgelesen werden soll __[Task : t]__
  Widget cardTopTheme(Task t) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColours.primaryLight,
            AppColours.primaryDark,
            AppColours.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(t.title, style: AppTextStyles.normalText),
              Row(
                children: [
                  SizedBox(width: 60),
                  Icon(Icons.timer, color: Colors.white, size: 16),
                  SizedBox(width: 10),
                  Text(
                    '${t.duration.inMinutes.toString()} min',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// __cardBottomTheme__ - Widget
  ///<br> Baut die untere Hälfte der Task-Card auf. <br>
  Widget cardBottomTheme(Tag tag, Task task, BuildContext context) {
    final controller = context.watch<TaskProvider>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: AppColours.primaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: cardButton(
              Icons.delete_outline_outlined,
              "Delete",
              deleteButtonPress(tag, task, context),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: cardButton(
              Icons.play_arrow_outlined,
              "Start",
              taskButtonPress(context, task),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: cardButton(
              Icons.settings_outlined,
              "Settings",
              settingButtonPress(context, task),
            ),
          ),
        ],
      ),
    );
  }

  /// __cardButton__ - Widget
  ///<br> Stellt die Buttons für die Bottom Card her. <br>
  ///<br> __Benötigt__:
  ///* Das Icon für den Button __[IconData : iconData]__
  ///* Der Text für den Button __[Text : label]__
  Widget cardButton(IconData iconData, String label, VoidCallback callBack) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 35),
        backgroundColor: AppColours.buttonUnpressed,
      ),
      onPressed: callBack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, size: 20, color: AppColours.buttonPressed),
          SizedBox(width: 4),
          Text(label, style: AppTextStyles.iconText),
        ],
      ),
    );
  }

  //  ----------------  Funktionen  ---------------- //

  VoidCallback taskButtonPress(BuildContext context, Task task) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PomodoroTimerPage(task: task)),
      );
    };
  }

  VoidCallback settingButtonPress(BuildContext context, Task task) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskSettingPage(task: task)),
      );
    };
  }

  VoidCallback deleteButtonPress(Tag tag, Task task, BuildContext context) {
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
