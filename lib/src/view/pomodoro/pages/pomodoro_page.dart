/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show UserProvider, HistoryProvider;

/* View Model - Import */
import 'package:todopomodoro/src/view/pomodoro/logic/pomodoro_logic.dart';

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart' show Task;

/* Custom-Widget - Import */
import 'package:todopomodoro/src/view/pomodoro/widgets/pomodoro_widget.dart';
import 'package:todopomodoro/src/widgets/custom_widgets.dart' show CustomAppBar;

class PomodoroTimerPage extends StatelessWidget {
  final Task task;

  const PomodoroTimerPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final userID = context.read<UserProvider>().currentUser!.uID;
    final HistoryProvider historyProvider = context.watch<HistoryProvider>();

    return ChangeNotifierProvider(
      create: (_) => PomodoroViewModel(
        userID: userID,
        task: task,
        historyProvider: historyProvider,
      ),
      child: Scaffold(
        appBar: CustomAppBar(
          title: task.title,
          subtitle: "${task.duration.inMinutes.toString()} min",
        ),
        body: PomodoroWidget(),
      ),
    );
  }
}
