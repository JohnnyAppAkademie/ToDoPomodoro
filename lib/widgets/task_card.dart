/*  Basic Import  */
import 'package:flutter/material.dart';
/*  Task - Logik  */
import 'package:todopomodoro/logic/task.dart';
/*  General - Design  */
import 'package:todopomodoro/style.dart';

/* UI - Class */
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.t});
  final Task t;

  @override
  Widget build(BuildContext context) {
    return taskCard(t);
  }

  //  ----------------  Widgets  ---------------- //

  ///Widget
  ///<br> __TaskCard__
  ///<br> Baut eine Task-Card samt Optionen auf
  ///<br> __Benötigt__:
  ///* Die Aufgabe die abgebildet werden soll __[Task : t]__
  Widget taskCard(Task t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [cardTopTheme(t), cardBottomTheme()],
        ),
      ),
    );
  }

  ///Widget
  ///<br> __cardTopTheme__
  ///<br> Baut den oberen Teil der Task-Card auf
  ///<br> __Benötigt__:
  ///* Die Aufgabe die ausgelesen werden soll __[Task : t]__
  Widget cardTopTheme(Task t) {
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(t.name, style: AppTextStyles.normalText),
              Row(
                children: [
                  SizedBox(width: 60),
                  Icon(Icons.timer, color: Colors.white, size: 16),
                  SizedBox(width: 10),
                  Text(
                    '${t.duration.inMinutes.toString()} min',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Widget
  ///<br> __cardBottomTheme__
  ///<br> Baut die untere Hälfte der Task-Card auf
  Widget cardBottomTheme() {
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
          Expanded(child: cardButton(Icons.delete_outline_outlined, "Delete")),
          const SizedBox(width: 6),
          Expanded(child: cardButton(Icons.play_arrow_outlined, "Start")),
          const SizedBox(width: 6),
          Expanded(child: cardButton(Icons.settings_outlined, "Settings")),
        ],
      ),
    );
  }

  ///Widget
  ///<br> __cardButton__
  ///<br> Stellt die Buttons für die Bottom Card her
  ///<br> __Benötigt__:
  ///* Das Icon für den Button __[IconData : iconData]__
  ///* Der Text für den Button __[Text : label]__
  Widget cardButton(IconData iconData, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 35),
        backgroundColor: AppColours.buttonUnpressed,
      ),
      onPressed: () {},
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
}
