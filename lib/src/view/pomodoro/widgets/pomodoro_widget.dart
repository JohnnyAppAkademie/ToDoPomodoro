/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* View Model - Import */
import 'package:todopomodoro/src/view/pomodoro/logic/pomodoro_logic.dart';

/* Custom Widgets - Import */
import 'package:todopomodoro/src/view/pomodoro/widgets/models/pomodoro_circular_progress.dart';
import 'package:todopomodoro/src/view/pomodoro/widgets/models/pomodoro_time_progress.dart';
import 'package:todopomodoro/src/view/pomodoro/widgets/models/pomodoro_interaction_button.dart';

class PomodoroWidget extends StatefulWidget {
  const PomodoroWidget({super.key});

  @override
  State<PomodoroWidget> createState() => _PomodoroWidgetState();
}

class _PomodoroWidgetState extends State<PomodoroWidget> {
  String _viewMode = 'Progress';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PomodoroViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: context.hgap5),

        // Umschalten zwischen Progress & Time
        SegmentedButton<String>(
          style: context.buttonStyles.primary,
          segments: const [
            ButtonSegment<String>(
              value: "Progress",
              icon: Icon(Icons.data_usage),
            ),
            ButtonSegment<String>(value: "Time", icon: Icon(Icons.alarm)),
          ],
          selected: {_viewMode},
          onSelectionChanged: (s) => setState(() => _viewMode = s.first),
        ),
        SizedBox(height: context.hgap5),

        // Phase-Anzeige
        Text(
          "${S.of(context).pomodoro_phase}: ${vm.phase.displayName(context)}",
          style: context.textStyles.dark.titleSmall,
        ),
        SizedBox(height: context.hgap5),

        // Timer-Darstellung
        if (_viewMode == 'Time')
          PomodoroTimeProgress()
        else
          SizedBox(height: 150, width: 150, child: PomodoroCircularProgress()),

        SizedBox(height: context.hgap10),

        // Buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.wgap10),
          child: Column(
            children: [
              PomodoroInteractionButton(
                funct: vm.isRunning ? vm.cancelPomodoro : vm.startPomodoro,
                txt: vm.isRunning ? S.of(context).cancel : S.of(context).start,
                icon: vm.isRunning ? Icons.clear : Icons.schedule,
              ),
              SizedBox(height: context.hgap2),
              PomodoroInteractionButton(
                funct: vm.isPaused ? vm.resumePomodoro : vm.pausePomodoro,
                txt: vm.isPaused
                    ? S.of(context).pomodoro_resume
                    : S.of(context).pomodoro_pause,
                icon: vm.isPaused ? Icons.play_arrow : Icons.pause,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
