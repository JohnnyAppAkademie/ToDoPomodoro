import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/view/tag/settings/logic/tag_setting_view_model.dart';

class SaveTagButton extends StatelessWidget {
  final TagSettingViewModel viewModel;

  const SaveTagButton({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.4,
      height: context.screenHeight * 0.04,
      child: WhiteButton(func: viewModel.saveTag, label: "Save"),
    );
  }
}
