/*  Basic - Import  */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/view/history/pages/history_page.dart';
import 'package:todopomodoro/src/view/setting/setting_page.dart';
/*  Pages - Import  */
import 'package:todopomodoro/src/view/tag/pages/tag_page.dart';
import 'package:todopomodoro/src/view/app_shell/pages/home_page.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      //  Screens   //

      /* Main - Screen */
      HomePage(),

      /* Task - Screen */
      TagPage(),

      /* History - Screen */
      HistoryPage(),

      /* Settings - Screen */
      SettingPage(),
    ];

    return Scaffold(
      body: pages[_selectedPage],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2),
            label: 'Tasks',
          ),
          NavigationDestination(icon: Icon(Icons.list), label: 'History'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}
