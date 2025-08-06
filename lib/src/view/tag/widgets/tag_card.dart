/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/utils/extensions/context_extension.dart';
/*  Tag - Logik  */
import 'package:todopomodoro/src/data/tag.dart';
/* Page - Import */
import 'package:todopomodoro/src/view/task/pages/task_page.dart';
import 'package:todopomodoro/src/view/tag/pages/tag_setting_page.dart';

/// __TagCard__ - Class
/// <br> Beinhaltet den Aufbau der TaskCard. <br>
/// <br> __Required__:
/// * Der Tag, welcher für den Aufbau der TagCard benötigt wird __[Tag : tag]__
/// * Ein Flag, ob Settings für die TagCard vorhanden sein soll oder nicht __[bool : settingEnabled]__
class TagCard extends StatelessWidget {
  const TagCard({super.key, required this.tag, required this.settingEnabled});
  final Tag tag;
  final bool settingEnabled;

  @override
  Widget build(BuildContext context) {
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tag.name, style: context.textStyles.light.labelLarge),
                ],
              ),
            ),
            /* Lower Header */
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                      Icons.checklist_outlined,
                      "Open",
                      () => taskButtonPress(context, tag),
                    ),
                  ),
                  if (settingEnabled) ...[
                    const SizedBox(width: 6),
                    Expanded(
                      child: cardButton(
                        context,
                        Icons.settings_outlined,
                        "Settings",
                        () => settingButtonPress(context, tag),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
