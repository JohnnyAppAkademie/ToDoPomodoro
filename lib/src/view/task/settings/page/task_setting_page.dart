// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/core/util/snackbar.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/view/task/settings/widgets/task_setting_widgets.dart';

/* Model View - Import */
import 'package:todopomodoro/src/view/task/settings/logic/task_setting_view_model.dart';

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart';

class TaskSettingPage extends StatelessWidget {
  final Task? task;
  final Tag? tag;

  const TaskSettingPage({super.key, this.task, this.tag});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskSettingViewModel(
        appProvider: context.read<TaskProvider>(),
        initialTask: task,
        tag: tag,
      ),
      child: Consumer<TaskSettingViewModel>(
        builder: (context, viewModel, _) {
          viewModel.eventNotifier.addListener(() {
            final wrapper = viewModel.eventNotifier.value;
            final event = wrapper?.consume();
            if (event == null) return;

            switch (event.type) {
              case TaskSettingEventType.showSnackBar:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showAppSnackBar(context: context, message: event.message!);
                });
                break;

              case TaskSettingEventType.navigateBack:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                });
                break;

              case TaskSettingEventType.showDeleteDialog:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showDeleteDialog(context, viewModel);
                });
                break;
            }
          });

          if (viewModel.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppHeaderWidget(
              title: task != null ? "Task - Adjustment" : "Task - Creation",
              subtitle: task?.title,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: context.hgap5),
              child: Column(
                spacing: context.hgap2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskNameInput(
                    textController: TextEditingController(
                      text: viewModel.task.title,
                    ),
                    focusNode: FocusNode(),
                    onChanged: viewModel.updateTitle,
                  ),
                  TagButtonListing(
                    allTags: viewModel.allTags,
                    selectedTags: viewModel.selectedTagIds,
                    onTagPressed: viewModel.toggleTagSelection,
                  ),
                  TaskDurationPicker(
                    duration: viewModel.task.duration,
                    onChanged: viewModel.updateDuration,
                  ),
                  TaskSaveButton(onPressed: () => viewModel.saveTask()),
                  if (viewModel.task.uID.isNotEmpty)
                    TaskDeleteButton(onPressed: viewModel.requestDeleteDialog),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TaskSettingViewModel viewModel) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomDialoge(
        dialogeText: 'Do you really want to delete the Task?',
        leftButtonText: 'Yes',
        leftButtonFunc: () async {
          await viewModel.deleteTask();
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        rightButtonText: 'No',
        rightButtonFunc: () => Navigator.pop(context),
      ),
    );
  }
}
