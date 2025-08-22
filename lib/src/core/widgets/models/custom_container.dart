import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';

/* Custom Container */

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.childWidget,
    this.hightLimit,
  });
  final Widget childWidget;
  final double? hightLimit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hightLimit != null ? context.screenHeight * hightLimit! : null,
      decoration: BoxDecoration(
        color: context.appStyle.labelBackground.withAlpha(30),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: context.appStyle.labelBackground.withAlpha(50),
          width: 0.75,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: childWidget,
    );
  }
}
