/*  Basic Import  */
import 'package:flutter/material.dart';
/*  Tag - Logik  */
import 'package:todopomodoro/src/data/tag.dart';
import 'package:todopomodoro/src/view/task/pages/task_page.dart';
import 'package:todopomodoro/src/view/tag/pages/tag_setting_page.dart';
/*  General - Design  */
import 'package:todopomodoro/style.dart';

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
    return tagCard(tag: tag, settingEnabled: settingEnabled, context: context);
  }

  //  ----------------  Widgets  ---------------- //

  /// __TagCard__ - Widget
  ///<br> Baut eine Tag-Card samt Optionen auf. <br>
  ///<br> __Benötigt__:
  /// * Die Aufgabe die abgebildet werden soll __[List<Tag> : tagList]__
  /// * Ein Bool-Wert, ob Settings hinzugefügt werden soll oder nicht __[bool : settingEnabled]__
  ///<br> (__True__ - _Setting vorhanden_ / __False__ _Setting wird nicht erstellt_)
  Widget tagCard({
    required Tag tag,
    bool settingEnabled = true,
    required BuildContext context,
  }) {
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
            cardTopTheme(tag),
            cardBottomTheme(settingEnabled, context, tag),
          ],
        ),
      ),
    );
  }

  /// __cardTopTheme__ - Widget
  ///<br> Baut den oberen Teil der Tag-Card auf. <br>
  ///<br> __Benötigt__:
  ///* Der Tag, der ausgelesen werden soll __[Tag : tag]__
  Widget cardTopTheme(Tag tag) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColours.primaryLight,
            AppColours.primaryDark,
            AppColours.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(tag.name, style: AppTextStyles.normalText)],
      ),
    );
  }

  /// __cardBottomTheme__ - Widget
  ///<br> Baut die untere Hälfte der Task-Card auf. <br>
  ///*  Eine Flag die entscheidet, ob einen Tag Settings haben soll __[bool : settingEnabled]__
  Widget cardBottomTheme(bool settingEnabled, BuildContext context, Tag tag) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: AppColours.primaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: cardButton(
              Icons.checklist_outlined,
              "Open",
              () => taskButtonPress(context, tag),
            ),
          ),
          if (settingEnabled) ...[
            const SizedBox(width: 6),
            Expanded(
              child: cardButton(
                Icons.settings_outlined,
                "Settings",
                () => settingButtonPress(context, tag),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// __cardButton__ - Widget
  ///<br> Stellt die Buttons für die Bottom Card her. <br>
  ///<br> __Benötigt__:
  ///* Das Icon für den Button __[IconData : iconData]__
  ///* Der Text für den Button __[Text : label]__
  Widget cardButton(IconData iconData, String label, VoidCallback callBack) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 35),
        backgroundColor: AppColours.buttonUnpressed,
      ),
      onPressed: callBack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, size: 20, color: AppColours.buttonPressed),
          SizedBox(width: 4),
          Text(label, style: AppTextStyles.iconText),
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
