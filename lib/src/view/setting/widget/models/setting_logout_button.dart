// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show UserProvider;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/core/util/snackbar.dart';
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

class SettingLogoutButton extends StatelessWidget {
  const SettingLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wgap5),
      child: PinkButton(
        label: 'Logout',
        icon: Icons.logout_outlined,
        func: () async {
          await context.read<UserProvider>().logout();
          showAppSnackBar(context: context, message: "Logged out");
          Restart.restartApp();
        },
      ),
    );
  }
}
