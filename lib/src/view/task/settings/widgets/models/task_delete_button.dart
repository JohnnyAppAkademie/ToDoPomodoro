// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/generated/l10n.dart';
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

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.appStyle.columnBackground.withValues(
            alpha: 0.85,
          ),
          title: Text(
            viewModel.tag!.uID == viewModel.taskProvider.defaultTagUID
                ? S.of(context).delete_task_header
                : S.of(context).remove_task_header,
            style: context.textStyles.light.labelLarge,
            textAlign: TextAlign.center,
          ),
          content: Text(
            viewModel.tag!.uID == viewModel.taskProvider.defaultTagUID
                ? "${S.of(context).delete_task_text_1}\n\n${S.of(context).delete_task_text_2}"
                : S.of(context).remove_task_text_1,
            style: context.textStyles.light.bodyMedium,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.wgap2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appStyle.buttonBackgroundLight
                          .withValues(alpha: 0.95),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      S.of(context).cancel,
                      style: context.textStyles.highlight.bodySmall,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appStyle.buttonBackgroundprimary
                          .withValues(alpha: 0.85),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      viewModel.tag!.uID == viewModel.taskProvider.defaultTagUID
                          ? S.of(context).delete_task_confirm
                          : S.of(context).remove_task_confirm,
                      style: context.textStyles.light.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await viewModel.deleteTask();
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.task.uID.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: context.hgap2),
      child: SizedBox(
        width: context.screenWidth * 0.75,
        child: PinkButton(
          func: () => _showDeleteConfirmationDialog(context),
          icon: Icons.delete_outline,
          label: viewModel.tag!.uID == viewModel.taskProvider.defaultTagUID
              ? S.of(context).delete_task
              : S.of(context).remove_task,
        ),
      ),
    );
  }
}
