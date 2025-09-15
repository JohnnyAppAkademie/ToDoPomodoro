/*  General Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/*  Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider;

/*  Data - Import  */
import 'package:todopomodoro/src/core/data/data.dart' show Tag, Task;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/view/task/main/widgets/task_card.dart';

/// `TaskPage - Class` <br>
/// <br>  __Info:__
/// <br>  The Main-Page for choosing Tasks <br>
/// <br>  __Required:__
/// * [ __Tag : tag__ ] - The tag with the tasks
class TaskPage extends StatelessWidget {
  const TaskPage({super.key, required this.tag});
  final Tag? tag;

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskProvider>();
    if (taskController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final displayTag = tag ?? taskController.getDefaultTag;

    return Scaffold(
      appBar: CustomAppBar(title: "Tasks", subtitle: displayTag.title),
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
