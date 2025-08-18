/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';

/*  Provider - Import */
import 'package:todopomodoro/src/core/utils/provider/app_provider.dart';

/*  Tag / Task - Logik  */
import 'package:todopomodoro/src/core/data/tag.dart';
import 'package:todopomodoro/src/core/data/task.dart';

/*  TaskCard - Design */
import 'package:todopomodoro/src/view/task/main/widgets/task_card.dart';

/* Generic Widgets - Import */
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key, required this.tag});
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<AppProvider>();

    if (taskController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    List<Task> tasks = taskController.readAllTasks(tag);

    return Scaffold(
      appBar: AppHeaderWidget(
        title: "Tasks",
        subtitle: tag.title,
        returnButton: true,
        callBack: () => Navigator.pop(context),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Text(
                        "Keine Tasks",
                        style: context.textStyles.dark.titleSmall,
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskCard(tag: tag, task: tasks[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
