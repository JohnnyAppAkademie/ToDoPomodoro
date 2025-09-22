// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/widgets/models/custom_button.dart';
import 'package:todopomodoro/src/view/tag/settings/logic/tag_setting_view_model.dart';

class DeleteTagButton extends StatelessWidget {
  final TagSettingViewModel viewModel;
  const DeleteTagButton({super.key, required this.viewModel});

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.appStyle.columnBackground.withValues(
            alpha: 0.85,
          ),
          title: Text(
            "Delete Tag",
            style: context.textStyles.light.labelLarge,
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Are you sure, you want to delete this Tag?\n\nThis action can not be undone.",
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
                      "Cancel",
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
                      "Delete Tag",
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
      await viewModel.deleteTag();
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.tag.uID.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: context.hgap2),
      child: SizedBox(
        width: context.screenWidth * 0.75,
        child: PinkButton(
          func: () => _showDeleteConfirmationDialog(context),
          icon: Icons.delete_outline,
          label: "Delete Tag",
        ),
      ),
    );
  }
}
