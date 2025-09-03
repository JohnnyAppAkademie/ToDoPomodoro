import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

class TaskNameInput extends StatefulWidget {
  const TaskNameInput({
    super.key,
    required this.textController,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController textController;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  State<TaskNameInput> createState() => _TaskNameInputState();
}

class _TaskNameInputState extends State<TaskNameInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.hgap5,
        left: context.wgap5,
        right: context.wgap5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Task", style: context.textStyles.dark.labelSmall),
          SizedBox(height: context.hgap2),
          CustomContainer(
            childWidget: CustomTextField(
              topic: "Enter a Taskname",
              textController: widget.textController,
              focusNode: widget.focusNode,
              isPassword: false,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
