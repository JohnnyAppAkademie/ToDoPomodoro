/*  Basic - Import  */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';
import 'package:todopomodoro/src/view/history/pages/history_page.dart';
import 'package:todopomodoro/src/view/setting/page/setting_page.dart';
/*  Pages - Import  */
import 'package:todopomodoro/src/view/tag/main/pages/tag_page.dart';
import 'package:todopomodoro/src/view/home/pages/home_page.dart';
import 'package:todopomodoro/src/view/tag/settings/pages/tag_setting_page.dart';
import 'package:todopomodoro/src/view/task/settings/pages/task_setting_page.dart';

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

      /*  Main - Screen */
      HomePage(),

      /* History - Screen */
      HistoryPage(),

      /* Settings - Screen */
      SettingPage(),
    ];

    final navTheme = Theme.of(context).navigationBarTheme;

    return Scaffold(
      body: pages[_selectedPage],
      bottomNavigationBar: NavigationBar(
        backgroundColor: navTheme.backgroundColor,
        indicatorColor: navTheme.indicatorColor,
        selectedIndex: _selectedPage,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2),
            label: 'Tasks',
          ),
          NavigationDestination(icon: Icon(Icons.add), label: 'Add'),
          NavigationDestination(icon: Icon(Icons.list), label: 'History'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _selectedPage = index;
            if (index == 2) {
              addFunction();
            }
          });
        },
      ),
    );
  }

  /* Dialoge */

  Future<dynamic> addFunction() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Stack(
        children: [
          /* Hintergrund */
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),

          /*  Dialoge */
          Positioned(
            top: context.screenHeight * 0.25,
            left: 50,
            child: Container(
              width: context.screenWidth * 0.75,
              height: context.screenHeight * 0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.appStyle.gradient1,
                    context.appStyle.gradient2,
                    context.appStyle.gradient3,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: context.appStyle.buttonBackgroundprimary,
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*  Dialoge - Text  */
                  SizedBox(height: context.screenHeight * 0.05),
                  Expanded(
                    child: Text(
                      "What do you want to add?",
                      style: context.textStyles.light.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /*  Tag - Option  */
                      Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: context.appStyle.buttonBackgroundLight,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: context.appStyle.buttonBackgroundLight,
                            width: 0.5,
                          ),
                        ),

                        child: TextButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TagSettingPage(),
                              ),
                            ),
                          },
                          child: Text(
                            "Tag",
                            style: context.textStyles.highlight.bodySmall,
                          ),
                        ),
                      ),

                      /*  Task - Option  */
                      Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: context.appStyle.buttonBackgroundLight,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: context.appStyle.buttonBackgroundLight,
                            width: 0.5,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskSettingPage(),
                              ),
                            ),
                          },
                          child: Text(
                            "Task",
                            style: context.textStyles.highlight.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.screenHeight * 0.02),
                ],
              ),
            ),
          ),

          /*  Exit  */
          Positioned(
            top: context.screenHeight * 0.25,
            left: context.screenWidth * 0.75,
            child: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(Icons.cancel_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
