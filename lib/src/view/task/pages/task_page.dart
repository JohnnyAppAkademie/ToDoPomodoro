/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/utils/extensions/context_extension.dart';

/*  Provider - Import */
import 'package:todopomodoro/src/core/utils/task/task_provider.dart';

/*  Tag / Task - Logik  */
import 'package:todopomodoro/src/data/tag.dart';
import 'package:todopomodoro/src/data/task.dart';

/*  TaskCard - Design */
import 'package:todopomodoro/src/view/task/widgets/task_card.dart';

/* Generic Widgets - Import */
import 'package:todopomodoro/src/core/widgets/custom_app_bar.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key, required this.tag});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TaskProvider>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Task> tasks = controller.readAllTasks(tag);

    return Scaffold(
      appBar: AppHeaderWidget(
        title: "Tasks",
        subtitle: tag.name,
        returnButton: true,
        callBack: () => Navigator.pop(context),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  if (controller.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (controller.tasks.isEmpty) {
                    return Center(
                      child: Text(
                        "Keine Tasks",
                        style: context.textStyles.dark.titleSmall,
                      ),
                    );
                  } else {
                    return TaskCard(tag: tag, task: tasks[index]);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
