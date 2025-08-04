import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/utils/extensions/context_extension.dart';

class CustomEditableText extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const CustomEditableText({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wgap5),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.wgap5,
          vertical: context.hgap2,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF3D2645).withAlpha(30),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFF3D2645).withAlpha(50),
            width: 0.75,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: EditableText(
          controller: controller,
          focusNode: focusNode,
          style: const TextStyle(color: Color(0XFF3D2645)),
          cursorColor: const Color(0XFF3D2645),
          backgroundCursorColor: const Color(0XFF3D2645),
        ),
      ),
    );
  }
}
