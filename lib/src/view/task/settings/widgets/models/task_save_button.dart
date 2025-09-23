/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Model View - Import */
import 'package:todopomodoro/src/view/task/settings/logic/task_setting_view_model.dart';

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

/// `TaskSaveButton` - Class <br>
/// <br>  __Info:__
/// <br>  Creates a Button to save the Task and leave the Task-Editor <br>
/// <br>  __Required:__ <br>
/// * [ __TaskSettingViewModel : viewModel__ ] - A ViewModel for Logic-Functions
class TaskSaveButton extends StatelessWidget {
  final TaskSettingViewModel viewModel;

  const TaskSaveButton({super.key, required this.viewModel});

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
        child: WhiteButton(
          label: S.of(context).save,
          func: () {
            viewModel.saveTask();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
