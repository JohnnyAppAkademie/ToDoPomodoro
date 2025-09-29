/*  Basic - Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider;

/* Custom Widget's - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

/* Pages - Import */
import 'package:todopomodoro/src/view/view.dart';

/*  Data - Import  */
import 'package:todopomodoro/src/core/data/data.dart' show Tag;

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.pageNo});

  final int pageNo;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedPage;

  @override
  void initState() {
    _selectedPage = widget.pageNo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TaskProvider>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final defaultTag = controller.tags.firstWhere(
      (tag) => tag.uID == controller.getDefaultTagUID,
      orElse: () => controller.tags.isNotEmpty
          ? controller.tags.first
          : Tag(
              uID: controller.getDefaultTagUID,
              title: 'All Tasks',
              updatedAt: DateTime.now(),
              userID: '',
            ),
    );

    List<Widget> pages = [
      HomePage(),
      TagPage(),
      TaskPage(tag: defaultTag),
      HistoryPage(),
    ];

    final navTheme = Theme.of(context).navigationBarTheme;

    return Scaffold(
      body: Stack(children: [pages[_selectedPage]]),
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
            destinationButton(iconData: Icons.list, pagePosition: 2),
            destinationButton(iconData: Icons.history, pagePosition: 3),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.appStyle.buttonBackgroundprimary,
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CustomDialoge(
              dialogeLabel: S.of(context).add_header,
              dialogeText: S.of(context).add_text,
              leftButtonText: S.of(context).tag,
              leftButtonFunc: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TagSettingPage()),
                );
                setState(() => _selectedPage = 1);
              },
              rightButtonText: S.of(context).task,
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
        child: Icon(Icons.add, color: context.appStyle.writingLight),
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
