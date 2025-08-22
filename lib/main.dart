/* General Import */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/* Theme Import */
import 'package:todopomodoro/src/core/theme/themes.dart';

/* Provider Import */
import 'package:todopomodoro/src/core/provider/app_provider.dart';

/* Main Page - Import */
import 'package:todopomodoro/src/view/app_shell/pages/main_page.dart';

/* SQLite Helper Import */
import 'src/core/database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await DatabaseHelper.instance.database;

  runApp(const InitApp());
}

class InitApp extends StatelessWidget {
  const InitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: standardTheme(AppStyle.standard()),
      debugShowCheckedModeBanner: false,
      title: 'ToDo & Pomodoro',
      home: const MainPage(),
    );
  }
}
