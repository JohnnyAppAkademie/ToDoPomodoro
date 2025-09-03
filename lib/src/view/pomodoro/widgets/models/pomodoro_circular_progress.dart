/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* View Model - Import */
import 'package:todopomodoro/src/view/pomodoro/logic/pomodoro_logic.dart';

class PomodoroCircularProgress extends StatelessWidget {
  const PomodoroCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PomodoroViewModel>();
    final totalTaskSeconds = vm.task.duration.inSeconds;
    final elapsedSeconds = totalTaskSeconds - vm.remainingTaskTime.inSeconds;
    final progress = totalTaskSeconds > 0
        ? (elapsedSeconds / totalTaskSeconds).clamp(0.0, 1.0)
        : 0.0;

    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: CircularProgressIndicator(
          color: context.appStyle.buttonBackgroundprimary,
          backgroundColor: context.appStyle.buttonBackgroundLight,
          value: progress,
          strokeWidth: 16,
        ),
      ),
    );
  }
}
