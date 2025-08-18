/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';
import 'package:todopomodoro/src/core/data/task.dart';

/* Shared Widgets - Import  */
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';

/*  Pomodoro - Logik and Design */
import 'package:todopomodoro/src/core/data/pomodoro_timer.dart';
import 'package:todopomodoro/src/view/pomodoro/widgets/pomodoro_timer.dart';

class PomodoroTimerPage extends StatelessWidget {
  const PomodoroTimerPage({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appStyle.background,
      appBar: AppHeaderWidget(
        title: "Pomodoro-Task",
        subtitle: task.title,
        returnButton: true,
        callBack: () => Navigator.pop(context),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 25),
            PomodoroWidget(
              taskDuration: task.duration,
              mode: TimeUnitMode.minutes,
            ),
          ],
        ),
      ),
    );
  }
}
