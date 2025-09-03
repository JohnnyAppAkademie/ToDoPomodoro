/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

class PomodoroInteractionButton extends StatelessWidget {
  const PomodoroInteractionButton({
    super.key,
    required this.funct,
    required this.txt,
    required this.icon,
  });

  final VoidCallback funct;
  final String txt;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: funct,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          context.appStyle.buttonBackgroundprimary,
        ),
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: context.appStyle.writingLight),
          const SizedBox(width: 5),
          Text(txt, style: context.textStyles.light.labelSmall),
        ],
      ),
    );
  }
}
