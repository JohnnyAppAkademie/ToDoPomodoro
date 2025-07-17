/*  Basic Import  */
import 'package:flutter/material.dart';
/*  General - Design  */
import 'package:todopomodoro/style.dart';
/*  Pomodoro - Logik and Design */
import 'package:todopomodoro/Widgets/pomodoro_timer.dart';
import 'package:todopomodoro/logic/pomodoro_timer.dart';
/* Generic Widgets - Import */
import 'package:todopomodoro/widgets/generic_widgets.dart';

class PomodoroTimerPage extends StatelessWidget {
  const PomodoroTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      body: Center(
        child: Column(
          children: [
            GenericWidgets.appHeader(context, "Task", "Boden wischen"),
            SizedBox(height: 25),
            PomodoroWidget(
              taskDuration: Duration(seconds: 45),
              mode: TimeUnitMode.seconds,
            ),
          ],
        ),
      ),
    );
  }
}
