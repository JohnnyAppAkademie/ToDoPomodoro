/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider, UserProvider;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/view/setting/widget/setting_widgets.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});
  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskProvider>(context);
    final userController = Provider.of<UserProvider>(context);

    if (userController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (taskController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppHeaderWidget(title: "Settings"),
      body: Column(
        spacing: context.wgap5,
        children: [
          SizedBox(height: context.hgap1),

          SettingUserProfile(),

          SettingLogoutButton(),

          SettingResetButton(
            taskController: taskController,
            userController: userController,
          ),
        ],
      ),
    );
  }
}
