import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/view/tag/settings/logic/tag_setting_view_model.dart';

class TagNameInput extends StatelessWidget {
  final TagSettingViewModel viewModel;

  const TagNameInput({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: viewModel.tag.title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.wgap5),
          child: Text(
            "Tag",
            style: context.textStyles.dark.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.wgap5,
            vertical: context.hgap2,
          ),
          child: CustomContainer(
            childWidget: CustomTextField(
              topic: "Enter a Tag name",
              textController: controller,
              isPassword: false,
              onChanged: viewModel.updateTitle,
            ),
          ),
        ),
      ],
    );
  }
}
