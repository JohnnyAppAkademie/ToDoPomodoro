/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* View Model - Import */
import 'package:todopomodoro/src/view/pomodoro/logic/pomodoro_logic.dart';

class PomodoroTimeProgress extends StatelessWidget {
  const PomodoroTimeProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PomodoroViewModel>();
    final remaining = vm.remainingSessionTime;
    final totalRemaining = vm.remainingTaskTime;

    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _timeBox(context, minutes),
            const SizedBox(width: 15),
            Text(":", style: context.textStyles.dark.titleMedium),
            const SizedBox(width: 15),
            _timeBox(context, seconds),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "Gesamtzeit verbleibend: ${_formatDuration(totalRemaining)}",
          style: context.textStyles.dark.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _timeBox(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: BoxDecoration(
        color: context.appStyle.labelBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: context.textStyles.light.titleSmall),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }
}
