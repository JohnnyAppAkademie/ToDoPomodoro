import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

class TaskDeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TaskDeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.hgap2,
        horizontal: context.wgap5,
      ),
      child: SizedBox(
        width: context.screenWidth * 0.90,
        height: context.screenHeight * 0.05,
        child: PinkButton(
          func: onPressed,
          label: "Delete",
          icon: Icons.delete_outlined,
        ),
      ),
    );
  }
}
