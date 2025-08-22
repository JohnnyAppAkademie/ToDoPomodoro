/*  Basic - Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/data/data.dart' show Tag;
import 'package:todopomodoro/src/core/extensions/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/app_provider.dart';

/* Custom Widget's - Import */
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';

/* Pages - Import */
import 'package:todopomodoro/src/view/view.dart';

/*  Pages - Import  */

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final appController = context.watch<AppProvider>();

    List<Widget> pages = [
      /* Main - Screen */
      HomePage(),

      /* Tag - Screen */
      TagPage(),

      /* Task - Screen (SystemTag) */
      TaskPage(
        tag: appController.tags.firstWhere(
          (tag) => tag.uID == appController.getDefaultTagUID,
          orElse: () => Tag(uID: '', title: 'Default'),
        ),
      ),

      /* Settings - Screen */
      HistoryPage(),
    ];

    final navTheme = Theme.of(context).navigationBarTheme;

    return Scaffold(
      body: pages[_selectedPage],
      bottomNavigationBar: BottomAppBar(
        color:
            navTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            destinationButton(iconData: Icons.home, pagePosition: 0),
            destinationButton(iconData: Icons.folder, pagePosition: 1),
            const SizedBox(width: 48),
            /* Platz für den Add-Button */
            destinationButton(iconData: Icons.list, pagePosition: 2),
            destinationButton(iconData: Icons.settings, pagePosition: 3),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CustomDialoge(
              dialogeText: 'What do you want to add?',
              leftButtonText: 'Tag',
              leftButtonFunc: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TagSettingPage()),
                );
                setState(() => _selectedPage = 1);
              },
              rightButtonText: 'Task',
              rightButtonFunc: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskSettingPage()),
                );
                setState(() => _selectedPage = 2);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget destinationButton({
    required IconData iconData,
    required int pagePosition,
  }) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _selectedPage == pagePosition
            ? context.appStyle.buttonBackgroundLight
            : Colors.transparent,
      ),
      child: IconButton(
        icon: Icon(
          iconData,
          color: _selectedPage == pagePosition
              ? context.appStyle.writingHighlight
              : context.appStyle.writingLight,
        ),
        onPressed: () => setState(() => _selectedPage = pagePosition),
      ),
    );
  }
}
