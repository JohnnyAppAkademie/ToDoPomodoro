/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* View Model - Import*/
import 'package:todopomodoro/src/view/task/settings/logic/task_setting_view_model.dart';

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

/// `TaskDeleteButton` - Class <br>
/// <br>  __Info:__
/// <br>  Creates a Button to delete a Task.  <br>
/// <br>  __Required:__ <br>
/// * [ __TaskSettingViewModel : viewModel__ ] - A ViewModel for Logic-Functions
class TaskDeleteButton extends StatelessWidget {
  final TaskSettingViewModel viewModel;
  const TaskDeleteButton({super.key, required this.viewModel});

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
          func: () {
            CustomDialoge(
              dialogeLabel: "Delete Task",
              dialogeText:
                  'Do you really want to delete this task?\n\nThis Action can not be undone.',
              leftButtonText: 'Cancel',
              leftButtonFunc: () {
                Navigator.pop(context);
              },
              rightButtonText: 'Delete Task',
              rightButtonFunc: () async {
                await viewModel.deleteTask();
              },
            );
          },
          label: "Delete",
          icon: Icons.delete_outlined,
        ),
      ),
    );
  }
}
