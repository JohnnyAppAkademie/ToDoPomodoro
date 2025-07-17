/*  Basic Import  */
import 'package:flutter/material.dart';
/*  Tag / TaskCard - Logik and Design */
import 'package:todopomodoro/logic/tag.dart';
import 'package:todopomodoro/widgets/task_card.dart';
/*  General - Design  */
import 'package:todopomodoro/style.dart';
/* Generic Widgets - Import */
import 'package:todopomodoro/widgets/generic_widgets.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.tag});
  final TagTask tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      body: Center(
        child: Column(
          children: [
            GenericWidgets.appHeader(context, "Task-Management", "#Haus"),
            Expanded(
              child: ListView.builder(
                itemCount: tag.taskList.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskCard(t: tag.getTask(index));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
