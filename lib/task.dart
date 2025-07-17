// ignore_for_file: slash_for_doc_comments
import 'package:flutter/material.dart';
import 'package:todopomodoro/style.dart';

class TagTask {
  // Attribute  //

  // Tab-Name //
  String tagName = "";
  //  Task-Liste //
  List<Task> taskList = [];

  /**
   * Constructor TagTask -
   * <br> Required: 
   * * Name des Tags (__[tagName]__)
   * * Liste aller Tasks (__[taskList]__)
   */
  TagTask(String tag, List<Task> tList) {
    tagName = "#$tag";
    taskList = tList;
  }

  // Get / Set //

  set setTaskList(taskList) => this.taskList = taskList;

  set setTabName(tagName) => this.tagName = tagName;

  get getTaskList => taskList;

  get getTabName => tagName;

  // Methoden //

  /**
   * Changes the name of the Tab
   * <br />Requires: __[newTabName]__
   */
  void changeTabName(String newTagName) {
    tagName = newTagName;
  }

  /**
   * Adds a Task to the Tasklist
   * <br />Requires: __[task]__
   */
  void addTask(Task task) {
    taskList.add(task);
  }

  /**
   * Deletes a Task on the given Position
   * <br />Requires: Taskposition (__[position]__)
   */
  void deleteTask(int position) {
    taskList.removeAt(position);
  }
}

class Task {
  //  Attributes  //

  //  Task-Name //
  String name;
  // Task-Duration //
  Duration duration;

  //  Constructor  //
  /**
   * Task-Constructor:
   * <br />Requires:
   * <br> * Task-name (__[name]__) 
   * <br> * Task-duratation (__[duration]__)
   */
  Task({required this.name, required this.duration});

  //  Get / Set //
  set setName(name) => this.name = name;

  set setDuration(duration) => this.duration = duration;

  get getName => name;

  get getDuration => duration;

  //  Methodes  //

  /**
   * brief: Changes the Task-Name
   * <br />Requires: __[newTaskName]__
   */
  void changeTaskName(String newTaskName) {
    name = newTaskName;
  }

  /**
   * Changes the duration of the Task
   * <br />Requires: __[newTaskDuration]__
   */
  void changeDuration(Duration newTaskDuration) {
    duration = newTaskDuration;
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  static const Color cardBackground = AppColours.primaryDark;
  static const Color cardFrontground = AppColours.primary;
  static const Color textColor = AppColours.lightText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            height: 127,
            width: 372,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cardBackground, cardFrontground],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                height: 58,
                width: 372,
                color: cardBackground,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        task.name,
                        style: const TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        softWrap: true,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _iconText(Icons.alarm, '${task.duration.inMinutes}"'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 58,
                width: 372,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _customButton(icon: Icons.delete_outlined, label: "Delete"),
                    _customButton(icon: Icons.play_arrow, label: "Start"),
                    _customButton(
                      icon: Icons.settings_outlined,
                      label: "Settings",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: textColor, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: textColor,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _customButton({required IconData icon, required String label}) {
    return SizedBox(
      width: 100,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18, color: AppColours.buttonPressed),
        label: Text(
          label,
          style: const TextStyle(color: AppColours.buttonPressed),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}

/*
    Code-Abschnitt:

    Task task1 = Task(
      name: "Müll rausbringen",
      duration: Duration(minutes: 15),
    );
    Task task2 = Task(name: "Pflanzen gießen", duration: Duration(minutes: 25));
    Task task3 = Task(name: "Einkaufen", duration: Duration(hours: 1));
    TagTask tag = TagTask("Haus", [task3, task1, task2]);

    child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tag.taskList.length,
        itemBuilder: (context, index) {
          final Task t = tag.taskList[index];
          return TaskCard(tcTask: t);
        },
      ),
    ),

*/
