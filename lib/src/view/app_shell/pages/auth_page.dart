import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider, UserProvider;
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Page - Import */
import 'package:todopomodoro/src/view/view.dart' show LoginPage, MainPage;

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final taskProvider = context.watch<TaskProvider>();

    if (userProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: context.appStyle.writingHighlight,
              ),
              SizedBox(height: context.hgap5),
              Text(
                "User wird geladen",
                style: context.textStyles.dark.labelSmall,
              ),
            ],
          ),
        ),
      );
    }

    if (!userProvider.isLoggedIn) {
      return const LoginPage();
    }

    if (taskProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: context.appStyle.writingHighlight,
              ),
              SizedBox(height: context.hgap5),
              Text(
                "Tasks werden geladen",
                style: context.textStyles.dark.labelSmall,
              ),
            ],
          ),
        ),
      );
    }

    return const MainPage(pageNo: 0);
  }
}
