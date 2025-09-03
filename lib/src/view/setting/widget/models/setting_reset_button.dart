// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider, UserProvider;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/core/util/snackbar.dart';

class SettingResetButton extends StatelessWidget {
  const SettingResetButton({
    super.key,
    required this.taskController,
    required this.userController,
  });

  final TaskProvider taskController;
  final UserProvider userController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wgap5),
      child: PinkButton(
        label: 'App-Daten zurücksetzen',
        icon: Icons.clear_all_outlined,
        func: () async {
          await taskController.fullReset();
          showAppSnackBar(context: context, message: "Data reset");
          Restart.restartApp();
        },
      ),
    );
  }
}
