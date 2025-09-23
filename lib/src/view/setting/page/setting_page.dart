/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider, UserProvider;

/* Custom Widgets - Import */
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        backgroundColor: context.appBarTheme.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        title: Text(
          S.of(context).settings,
          style: context.textStyles.light.labelLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: PopupMenuButton<int>(
              onSelected: (value) async {
                if (value == 1) {
                  await context.read<UserProvider>().setUserLocale("de");
                } else if (value == 2) {
                  await context.read<UserProvider>().setUserLocale("en");
                }
              },
              offset: const Offset(0, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Text("🇩🇪"),
                    title: Text(
                      S.of(context).german,
                      style: context.textStyles.highlight.labelSmall,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: Text("🇬🇧"),
                    title: Text(
                      S.of(context).english,
                      style: context.textStyles.highlight.labelSmall,
                    ),
                  ),
                ),
              ],
              child: SizedBox(
                width: 50,
                height: 50,
                child: Icon(Icons.language),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(35),
          child: Container(
            width: double.infinity,
            height: 35,
            decoration: BoxDecoration(
              color: context.appBarTheme.backgroundColor,
              border: Border(
                top: BorderSide(color: Colors.black, width: 1.0),
                bottom: BorderSide(color: Colors.black, width: 1.0),
              ),
            ),
          ),
        ),
      ),
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
