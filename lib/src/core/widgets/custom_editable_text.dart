import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/theme/themes.dart';
import 'package:todopomodoro/src/core/utils/extensions/context_extension.dart';

class CustomEditableText extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const CustomEditableText({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<CustomEditableText> createState() => _CustomEditableTextState();
}

class _CustomEditableTextState extends State<CustomEditableText> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appStyle = Theme.of(context).extension<AppStyle>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wgap5),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.wgap5,
          vertical: context.hgap2,
        ),
        decoration: BoxDecoration(
          color: appStyle.labelBackground.withAlpha(30),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: appStyle.labelBackground.withAlpha(50),
            width: 0.75,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: EditableText(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          style: TextStyle(color: appStyle.labelBackground),
          cursorColor: appStyle.labelBackground,
          backgroundCursorColor: appStyle.labelBackground,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }
}
