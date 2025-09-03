import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

void showAppSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: context.textStyles.highlight.labelSmall,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(milliseconds: 800),
    ),
  );
}
