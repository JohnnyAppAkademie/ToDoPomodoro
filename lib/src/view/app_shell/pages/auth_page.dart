/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show UserProvider, TaskProvider;

/* Page - Import */
import 'package:todopomodoro/src/view/view.dart' show MainPage, LoginPage;

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final taskProvider = context.watch<TaskProvider>();

    // Ladezustand User
    if (userProvider.isLoading) {
      return _loadingScreen(context, S.of(context).user_load);
    }

    // Locale einmalig setzen, sobald User geladen ist
    if (userProvider.isLoggedIn && userProvider.currentLocale == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final savedLocale = userProvider.currentLocale ?? const Locale('en');
        context.read<UserProvider>().setUserLocale(savedLocale.languageCode);
      });
    }

    // User nicht eingeloggt
    if (!userProvider.isLoggedIn) return const LoginPage();

    // Ladezustand Tasks
    if (taskProvider.isLoading) {
      return _loadingScreen(context, S.of(context).task_load);
    }

    // Alles geladen
    return const MainPage(pageNo: 0);
  }

  Widget _loadingScreen(BuildContext context, String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: context.appStyle.writingHighlight),
            SizedBox(height: context.hgap5),
            Text(message, style: context.textStyles.dark.labelSmall),
          ],
        ),
      ),
    );
  }
}
