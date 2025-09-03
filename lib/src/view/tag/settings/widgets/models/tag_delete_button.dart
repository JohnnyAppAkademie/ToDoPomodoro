import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/widgets/models/custom_button.dart';
import 'package:todopomodoro/src/view/tag/settings/logic/tag_setting_view_model.dart';

class DeleteTagButton extends StatelessWidget {
  final TagSettingViewModel viewModel;

  const DeleteTagButton({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.tag.uID.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: context.hgap2),
      child: SizedBox(
        width: context.screenWidth * 0.75,
        child: PinkButton(
          func: viewModel.deleteTag,
          icon: Icons.delete_outline,
          label: "Delete Tag",
        ),
      ),
    );
  }
}
