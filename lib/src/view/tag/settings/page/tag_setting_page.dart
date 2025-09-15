// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart' show Tag;

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider;

/* View Model - Import */
import 'package:todopomodoro/src/view/tag/settings/logic/tag_setting_view_model.dart';

/* Custom Widgets - Import */
import 'package:todopomodoro/src/view/tag/settings/widgets/tag_setting_widgets.dart';
import 'package:todopomodoro/src/core/util/snackbar.dart';
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

class TagSettingPage extends StatelessWidget {
  final Tag? tag;

  const TagSettingPage({super.key, this.tag});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TagSettingViewModel(
        appProvider: context.read<TaskProvider>(),
        initialTag: tag,
      ),
      child: Consumer<TagSettingViewModel>(
        builder: (context, viewModel, _) {
          viewModel.eventNotifier.addListener(() {
            final wrapper = viewModel.eventNotifier.value;
            final event = wrapper?.consume();
            if (event == null) return;

            switch (event.type) {
              case TagSettingEventType.showSnackBar:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showAppSnackBar(context: context, message: event.message!);
                });
                break;
              case TagSettingEventType.navigateBack:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.popUntil(context, (route) => route.isFirst);
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
            appBar: CustomAppBar(
              title: tag != null ? "Tag - Adjustment" : "Tag - Creation",
              subtitle: tag?.title,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: context.hgap2),
                  TagNameInput(viewModel: viewModel),
                  SizedBox(height: context.hgap2),
                  TaskListingWidget(
                    viewModel: viewModel,
                    onTaskDeleted: () => {},
                  ),
                  SizedBox(height: context.hgap1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AddTasksButton(
                        onPressed: () async {
                          await _openTaskSelectionDialog(context, viewModel);
                        },
                      ),
                      SaveTagButton(viewModel: viewModel),
                    ],
                  ),
                  SizedBox(height: context.hgap2),
                  DeleteTagButton(viewModel: viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openTaskSelectionDialog(
    BuildContext context,
    TagSettingViewModel viewModel,
  ) async {
    final currentSelection = viewModel.selectedTasks.map((t) => t.uID).toSet();
    await showDialog(
      context: context,
      builder: (_) => TaskSelectionDialog(
        allTasks: viewModel.allTasks,
        initiallySelected: currentSelection,
        onSave: (selectedIds) {
          viewModel.updateSelectedTasks(
            viewModel.allTasks
                .where((t) => selectedIds.contains(t.uID))
                .toList(),
          );
        },
      ),
    );
  }
}
