import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';

class PinkButton extends StatelessWidget {
  const PinkButton({super.key, required this.func, required this.label});

  final VoidCallback func;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      style: context.buttonStyles.primary,
      child: Text(label, style: context.textStyles.highlight.labelSmall),
    );
  }
}

class WhiteButton extends StatelessWidget {
  const WhiteButton({super.key, required this.func, required this.label});

  final VoidCallback func;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      style: context.buttonStyles.secondary,
      child: Text(label, style: context.textStyles.highlight.labelSmall),
    );
  }
}
