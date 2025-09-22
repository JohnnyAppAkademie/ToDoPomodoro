/* General Import */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* Theme Import */
import 'package:todopomodoro/src/core/theme/themes.dart';

/* Provider Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider, UserProvider, HistoryProvider;

/* Service Import */
import 'package:todopomodoro/src/services/history_service.dart';

/* Start Page - Import */
import 'package:todopomodoro/src/view/view.dart'
    show AuthWrapper, MainPage, LoginPage;

/* SQLite Helper Import */
import 'src/core/database/database.dart';

/* Firebase - Import */
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  await HistoryService.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  } else {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProxyProvider<UserProvider, TaskProvider>(
          create: (_) => TaskProvider(null),
          update: (_, userProvider, previousTaskProvider) {
            return TaskProvider(userProvider);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: standardTheme(AppStyle.standard()),
      debugShowCheckedModeBanner: false,
      title: 'ToDo & Pomodoro',
      home: const AuthWrapper(),
      routes: {
        '/main': (context) => MainPage(pageNo: 0),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
