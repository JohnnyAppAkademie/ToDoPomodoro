/*  Basic Import  */
import 'package:flutter/material.dart';
/*  General - Design  */
import 'package:todopomodoro/style.dart';
/*  Pomodoro - Logik und Design */
/*
import 'package:todopomodoro/Widgets/pomodoro_timer.dart';
import 'package:todopomodoro/logic/pomodoro_timer.dart';
*/
/*  Task  - Logik und Design */

import 'package:todopomodoro/Widgets/task_card.dart';

import 'package:todopomodoro/logic/task.dart';
/* Generic Widgets - Import */
import 'package:todopomodoro/widgets/generic_widgets.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    /* Tag / Task Vorbereitung */

    Task task1 = Task(
      name: "Müll rausbringen",
      duration: Duration(minutes: 15),
    );

    Task task2 = Task(name: "Pflanzen gießen", duration: Duration(minutes: 25));

    TagTask tag = TagTask("Haus", [task1]);
    tag.addTask(task2);
    /* Vorbereitung (Ende) */

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColours.background,
        body: Center(
          child: Column(
            children: [
              GenericWidgets.appHeader(context, "Task-Managment", "#Haus"),
              TaskCard(t: task1),
              TaskCard(t: task2),
            ],
          ),
        ),
      ),
    );
  }
}
