/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/*  Data - Import */
import 'package:todopomodoro/src/core/data/data.dart';

/* Page - Import */
import 'package:todopomodoro/src/view/view.dart'
    show TaskSettingPage, PomodoroTimerPage;

/// `TaskCard - Class` <br>
/// <br>  __Info:__
/// <br>  Creates a Card-Widget for Tasks.  <br>
/// <br>  __Required:__
/// * [ __Task : task__ ] - Given task for the card
/// * [ __Tag : tag__ ] - Origin of the task
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.tag, required this.task});

  final Task task;
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final breakCount = (task.duration.inMinutes / 25).floor();
    final longBreaks = (breakCount / 4).floor();
    final shortBreaks = breakCount - longBreaks;

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
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${task.duration.inMinutes} min',
                            style: context.textStyles.light.labelSmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          /* Short Breaks */
                          Icon(
                            Icons.free_breakfast_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: context.wgap2),
                          Text(
                            shortBreaks.toString(),
                            style: context.textStyles.light.labelSmall,
                          ),
                          SizedBox(width: context.wgap2),

                          /* Long Breaks */
                          Icon(
                            Icons.free_breakfast_sharp,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: context.wgap2),
                          Text(
                            longBreaks.toString(),
                            style: context.textStyles.light.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: context.wgap2),
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
                    child: CardButton(
                      iconData: Icons.play_arrow_outlined,
                      label: S.of(context).start,
                      callBack: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PomodoroTimerPage(task: task),
                          ),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: CardButton(
                      iconData: Icons.settings_outlined,
                      label: S.of(context).settings,
                      callBack: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TaskSettingPage(task: task, tag: tag),
                        ),
                      ),
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
}

/// `CardButton - Class` <br>
/// <br>  __Info:__
/// <br>  Creates a Button-Widget for the card.  <br>
/// <br>  __Required:__
/// * [ __IconData : iconData__ ] - A icon for the button
/// * [ __String : label__ ] - The label for the button
/// * [ __VoidCallback : callBack__ ] - OnPress function
class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.iconData,
    required this.label,
    required this.callBack,
  });

  final IconData iconData;
  final String label;
  final VoidCallback callBack;

  @override
  Widget build(BuildContext context) {
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
}
