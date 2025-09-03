import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

class PinkButton extends StatelessWidget {
  const PinkButton({
    super.key,
    required this.func,
    required this.label,
    this.icon,
  });

  final VoidCallback func;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      style: context.buttonStyles.primary,
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: context.appStyle.writingLight),
                SizedBox(width: context.wgap2),
                Text(label, style: context.textStyles.light.labelSmall),
              ],
            )
          : Text(label, style: context.textStyles.light.labelSmall),
    );
  }
}

class WhiteButton extends StatelessWidget {
  const WhiteButton({
    super.key,
    required this.func,
    required this.label,
    this.icon,
  });

  final VoidCallback func;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      style: context.buttonStyles.secondary,
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: context.appStyle.writingHighlight),
                SizedBox(width: context.wgap2),
                Text(label, style: context.textStyles.highlight.labelSmall),
              ],
            )
          : Text(label, style: context.textStyles.highlight.labelSmall),
    );
  }
}
