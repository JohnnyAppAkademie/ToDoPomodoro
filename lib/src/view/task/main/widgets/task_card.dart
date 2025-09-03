/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/*  Data - Import */
import 'package:todopomodoro/src/core/data/data.dart';

/* Page - Import */
import 'package:todopomodoro/src/view/view.dart'
    show TaskSettingPage, PomodoroTimerPage;

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.tag, required this.task});

  final Task task;
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.appStyle.gradient1,
                    context.appStyle.gradient2,
                    context.appStyle.gradient3,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(task.title, style: context.textStyles.light.labelLarge),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${task.duration.inMinutes} min',
                        style: context.textStyles.light.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: context.appStyle.labelBackground,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: cardButton(
                      context: context,
                      iconData: Icons.play_arrow_outlined,
                      label: "Start",
                      callBack: () => _taskButtonPress(context),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: cardButton(
                      context: context,
                      iconData: Icons.settings_outlined,
                      label: "Settings",
                      callBack: () => _settingButtonPress(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardButton({
    required BuildContext context,
    required IconData iconData,
    required String label,
    required VoidCallback callBack,
  }) {
    return ElevatedButton(
      style: context.buttonStyles.card,
      onPressed: callBack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 20, color: context.appStyle.writingHighlight),
          const SizedBox(width: 4),
          Text(label, style: context.textStyles.highlight.bodyMedium),
        ],
      ),
    );
  }

  void _taskButtonPress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PomodoroTimerPage(task: task)),
    );
  }

  void _settingButtonPress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskSettingPage(task: task, tag: tag),
      ),
    );
  }
}
