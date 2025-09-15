/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider;

/*  Tag - Logik  */
import 'package:todopomodoro/src/core/data/data.dart' show Tag, Task;

/* Page - Import */
import 'package:todopomodoro/src/view/view.dart' show TaskPage, TagSettingPage;

/// __TagCard__ - Class
/// <br> Beinhaltet den Aufbau der TaskCard. <br>
/// <br> __Required__:
/// * Der Tag, welcher für den Aufbau der TagCard benötigt wird __[Tag : tag]__
class TagCard extends StatelessWidget {
  const TagCard({super.key, required this.tag});
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: context.read<TaskProvider>().readAllTasks(tag: tag),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Fehler: ${snapshot.error}"));
        } else {
          // Calculate the total minutes from the tasks
          final tasks = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /* Header */
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.appStyle.gradient1,
                          context.appStyle.gradient2,
                          context.appStyle.gradient3,
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tag.title,
                          style: context.textStyles.light.labelLarge,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.format_list_bulleted,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${tasks.length.toString()} Entries",
                              style: context.textStyles.light.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /* Lower Header */
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: context.wgap2),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: context.appStyle.labelBackground,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: cardButton(
                            context,
                            Icons.list,
                            "Open",
                            () => taskButtonPress(context, tag),
                          ),
                        ),
                        SizedBox(width: context.wgap2),
                        Expanded(
                          child: cardButton(
                            context,
                            Icons.settings_outlined,
                            "Settings",
                            () => settingButtonPress(context, tag),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  //  ----------------  Widgets  ---------------- //

  /// __cardButton__ - Widget
  ///<br> Stellt die Buttons für die Bottom Card her. <br>
  ///<br> __Benötigt__:
  ///* __[IconData : iconData]__ - Das Icon für den Button
  ///* __[Text : label]__ - Der Text für den Button
  ///* __[VoidCallBack]__ - Die Funktion des Button
  Widget cardButton(
    BuildContext context,
    IconData iconData,
    String label,
    VoidCallback callBack,
  ) {
    return ElevatedButton(
      style: context.buttonStyles.card,
      onPressed: callBack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 20, color: context.appStyle.writingHighlight),
          SizedBox(width: 4),
          Text(label, style: context.textStyles.highlight.bodyMedium),
        ],
      ),
    );
  }

  //  ----------------  Funktionen  ---------------- //

  void taskButtonPress(BuildContext context, Tag tag) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage(tag: tag)),
    );
  }

  void settingButtonPress(BuildContext context, Tag tag) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TagSettingPage(tag: tag)),
    );
  }
}
