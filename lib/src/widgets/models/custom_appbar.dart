/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show UserProvider;

/* Page - Import */
import 'package:todopomodoro/src/view/setting/page/setting_page.dart';

/* Custom Appbar */
class AppHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppHeaderWidget({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final userController = Provider.of<UserProvider>(context);

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      backgroundColor: context.appBarTheme.backgroundColor,
      centerTitle: true,
      title: Text(title, style: context.textStyles.light.labelLarge),

      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            )
          : null,

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<int>(
            onSelected: (value) async {
              if (value == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              } else if (value == 2) {
                await context.read<UserProvider>().logout();
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
                  leading: Icon(Icons.settings, color: Colors.black),
                  title: Text(
                    "Settings",
                    style: context.textStyles.highlight.labelSmall,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.black),
                  title: Text(
                    "Logout",
                    style: context.textStyles.highlight.labelSmall,
                  ),
                ),
              ),
            ],
            child: SizedBox(
              width: 50,
              height: 50,
              child: ClipOval(
                child: Image.asset(
                  userController.currentUser!.profilePath,
                  fit: BoxFit.cover,
                ),
              ),
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
            color: appBarTheme.backgroundColor,
            border: Border(
              top: BorderSide(color: Colors.black, width: 1.0),
              bottom: BorderSide(color: Colors.black, width: 1.0),
            ),
          ),
          alignment: Alignment.center,
          child: subtitle != null
              ? Text(
                  subtitle!,
                  style: context.textStyles.light.labelSmall,
                  textAlign: TextAlign.center,
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
