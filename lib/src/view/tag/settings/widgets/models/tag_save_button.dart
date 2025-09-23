// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Model View - Import */
import 'package:todopomodoro/src/view/tag/settings/logic/tag_setting_view_model.dart';

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

class SaveTagButton extends StatelessWidget {
  final TagSettingViewModel viewModel;

  const SaveTagButton({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.4,
      height: context.screenHeight * 0.04,
      child: WhiteButton(
        func: () async {
          await viewModel.saveTag();
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        label: S.of(context).save,
      ),
    );
  }
}
