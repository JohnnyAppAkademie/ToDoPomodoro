// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

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

/// `TaskSettingPage` - Class <br>
/// <br>  __Info:__
/// <br>  The Main-Page for Editing and Creating Tasks <br>
/// <br>  __Optional:__
/// * [ __Task : task__ ] - If a Task needs to be edited
/// * [ __Tag : tag__ ] - If the Task has a specifc Origin
class TaskSettingPage extends StatelessWidget {
  final Task? task;
  final Tag? tag;

  const TaskSettingPage({super.key, this.task, this.tag});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskSettingViewModel(
        taskProvider: context.read<TaskProvider>(),
        initialTask: task,
        tag: tag,
      ),
      child: Consumer<TaskSettingViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              title: task != null
                  ? S.of(context).task_setting_adjust
                  : S.of(context).task_setting_create,
              subtitle: task?.title,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: context.hgap5),
              child: Column(
                children: [
                  TaskNameInput(viewModel: viewModel),
                  SizedBox(height: context.hgap2),
                  TagButtonListing(viewModel: viewModel),
                  TaskDurationPicker(viewModel: viewModel),
                  TaskSaveButton(viewModel: viewModel),
                  if (viewModel.task.uID.isNotEmpty)
                    TaskDeleteButton(viewModel: viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
