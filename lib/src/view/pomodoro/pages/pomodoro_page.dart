/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/data/task.dart';

/* Shared Widgets - Import  */
import 'package:todopomodoro/src/core/widgets/app_header.dart';

/*  General - Design  */
import 'package:todopomodoro/style.dart';

/*  Pomodoro - Logik and Design */
import 'package:todopomodoro/src/data/pomodoro_timer.dart';
import 'package:todopomodoro/src/view/pomodoro/widgets/pomodoro_timer.dart';

class PomodoroTimerPage extends StatelessWidget {
  const PomodoroTimerPage({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      body: Center(
        child: Column(
          children: [
            AppHeaderWidget(title: task.title),
            SizedBox(height: 25),
            PomodoroWidget(
              taskDuration: task.duration,
              mode: TimeUnitMode.seconds,
            ),
          ],
        ),
      ),
    );
  }
}
