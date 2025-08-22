/*  General Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';

/*  Provider - Import */
import 'package:todopomodoro/src/core/provider/app_provider.dart';

/*  Data Import  */
import 'package:todopomodoro/src/core/data/data.dart';

/* Custom Widgets - Import */
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/view/task/main/widgets/task_card.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key, required this.tag});
  final Tag? tag;

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<AppProvider>();
    if (taskController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final displayTag = tag ?? taskController.getDefaultTag;

    return Scaffold(
      appBar: AppHeaderWidget(
        title: "Tasks",
        subtitle: displayTag.title,
        returnButton: true,
        callBack: () => Navigator.pop(context),
      ),
      body: FutureBuilder<List<Task>>(
        future: taskController.readAllTasks(tag: displayTag),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return Center(
              child: Text(
                "Keine Tasks",
                style: context.textStyles.dark.titleSmall,
              ),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskCard(tag: displayTag, task: tasks[index]);
            },
          );
        },
      ),
    );
  }
}
