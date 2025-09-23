import 'package:flutter/material.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

class AddTasksButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddTasksButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.4,
      height: context.screenHeight * 0.04,
      child: WhiteButton(
        func: onPressed,
        label: S.of(context).tag_setting_add_task,
      ),
    );
  }
}
