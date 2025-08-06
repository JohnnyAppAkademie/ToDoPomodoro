/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/utils/extensions/context_extension.dart';

class AppHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.returnButton = false,
    this.callBack,
  });

  final String title;
  final String? subtitle;
  final bool returnButton;
  final VoidCallback? callBack;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      backgroundColor: context.appBarTheme.backgroundColor,
      centerTitle: true,
      title: Text(title, style: context.textStyles.light.labelLarge),

      leading: returnButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: callBack,
            )
          : null,

      actions: [
        IconButton(
          icon: Icon(Icons.person, color: Colors.white),
          onPressed: () => {},
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
