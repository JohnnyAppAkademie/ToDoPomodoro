import 'package:flutter/material.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/view/tag/settings/logic/tag_setting_view_model.dart';

class TaskListingWidget extends StatelessWidget {
  final TagSettingViewModel viewModel;
  final VoidCallback onTaskDeleted;

  const TaskListingWidget({
    super.key,
    required this.viewModel,
    required this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.wgap5),
          child: Text(
            S.of(context).tag_setting_add_task,
            style: context.textStyles.dark.labelSmall,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.wgap5,
            vertical: context.hgap2,
          ),
          child: Container(
            height: context.screenHeight * 0.45,
            decoration: BoxDecoration(
              color: const Color(0xFF3D2645).withAlpha(30),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color(0xFF3D2645).withAlpha(50),
                width: 0.75,
              ),
            ),
            child: Scrollbar(
              child: ListView.builder(
                itemCount: viewModel.selectedTasks.length,
                itemBuilder: (_, index) {
                  final task = viewModel.selectedTasks[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.hgap1),
                    child: Container(
                      height: context.screenHeight * 0.05,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D2645),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.wgap5,
                              ),
                              child: Text(
                                task.title,
                                style: context.textStyles.light.labelSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            style: context.buttonStyles.primary.copyWith(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            iconSize: 24,
                            padding: EdgeInsets.zero,

                            onPressed: () {
                              viewModel.toggleTaskSelection(task);
                              onTaskDeleted();
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: context.appStyle.writingLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
