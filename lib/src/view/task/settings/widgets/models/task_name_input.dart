/*  General Import  */
import 'package:flutter/material.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/*  View Model - Import */
import 'package:todopomodoro/src/view/task/settings/logic/task_setting_view_model.dart';

/*  Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

/// `TaskNameInput` - Class <br>
/// <br>  __Info:__
/// <br>  Creates a TextField to choose a name for the Task <br>
/// <br>  __Required:__ <br>
/// * [ __TaskSettingViewModel : viewModel__ ] - A ViewModel for Logic-Functions
class TaskNameInput extends StatefulWidget {
  const TaskNameInput({super.key, required this.viewModel});

  final TaskSettingViewModel viewModel;

  @override
  State<TaskNameInput> createState() => _TaskNameInputState();
}

class _TaskNameInputState extends State<TaskNameInput> {
  late TextEditingController taskNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.viewModel.task.title;
  }

  @override
  void dispose() {
    taskNameController.dispose();
    super.dispose();
  }

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
          Text(S.of(context).task, style: context.textStyles.dark.labelSmall),
          SizedBox(height: context.hgap2),
          CustomContainer(
            childWidget: CustomTextField(
              topic: S.of(context).task_setting_task,
              textController: taskNameController,
              onChanged: widget.viewModel.updateTitle,
            ),
          ),
        ],
      ),
    );
  }
}
