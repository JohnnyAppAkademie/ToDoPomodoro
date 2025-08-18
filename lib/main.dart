import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/utils/repositories/tag_repository.dart';
import 'package:todopomodoro/src/core/utils/repositories/task_repository.dart';
import 'package:todopomodoro/src/core/theme/themes.dart';
import 'package:todopomodoro/src/core/utils/provider/app_provider.dart';
import 'package:todopomodoro/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  TagRepository tagRepo = TagRepository();
  TaskRepository taskRepo = TaskRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(tagRepo: tagRepo, taskRepo: taskRepo),
        ),
      ],
      child: MyApp(),
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
      home: MyMainPage(),
    );
  }
}
