import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/data/pomodoro_timer.dart';
import 'package:todopomodoro/style.dart';

/// __PomodoroWidget__ - Klasse
/// <br> Die Oberklasse für das Pomodoro-Widget, was aufgerufen werden kann. <br>
/// <br>__Required__:
/// * Die Dauer des Tasks [__Duration : taskDuration__]
/// * Der Modus des Widgets [__TimeUnitMode : mode__]
class PomodoroWidget extends StatefulWidget {
  final Duration taskDuration;
  final TimeUnitMode mode;

  const PomodoroWidget({
    super.key,
    required this.taskDuration,
    required this.mode,
  });

  @override
  State<PomodoroWidget> createState() => _PomodoroWidgetState();
}

/// __PomodoroWidgetState__ - Klasse
/// <br> Die Unterklasse für das Pomodoro-Widget, was den Aufbau des Widgets vorgibt. <br>
///
class _PomodoroWidgetState extends State<PomodoroWidget> {
  // Variabeln //

  /*  Die Pomodoro - Logik  */
  late final PomodoroTimer _pomodoroTimer;
  /*  Der Zeitmodus (Sekunden / Minuten ) */
  late TimeUnitMode timeUnitMode;
  String _viewMode = 'Progress'; // 'Progress' oder 'Time'

  @override
  /// __initState()__ - Funktion:
  /// <br> Initatiert, den Timer für die Aufgabe. <br>
  void initState() {
    super.initState();
    timeUnitMode = widget.mode;
    _pomodoroTimer = PomodoroTimer(
      taskDuration: widget.taskDuration,
      mode: timeUnitMode,
    );
  }

  @override
  /// __dispose()__ Funktion:
  /// <br> Zum sicher stellen, dass kein Instanz des Pomodoro-Timer nachher noch übrigbleibt. <br>
  void dispose() {
    /*  sicherstellen, dass Timer gestoppt wird  */
    _pomodoroTimer.cancelTask();
    super.dispose();
  }

  //  Build //

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SegmentedButton<String>(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColours.buttonUnpressed,
            ),
          ),
          segments: [
            pomodoroOption("Progress", Icons.data_usage),
            pomodoroOption("Time", Icons.alarm),
          ],
          selected: {_viewMode},
          onSelectionChanged: (s) {
            setState(() => _viewMode = s.first);
          },
        ),
        const SizedBox(height: 25),
        pomodoroPhaseBuilder(),
        if (_viewMode == 'Time') ...[
          const SizedBox(height: 25),
          pomodoroTimeBuilder(),
        ] else ...[
          const SizedBox(height: 25),
          SizedBox(height: 150, width: 150, child: pomodoroProgressBuilder()),
        ],
        SizedBox(height: 50),
        SizedBox(
          width: (MediaQuery.of(context).size.width * 0.8),
          child: Column(
            spacing: 25,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pomodoroInteraction(
                pomodoroStartCancel,
                !_pomodoroTimer.taskRunning ? "Start" : "Cancel",
                !_pomodoroTimer.taskRunning ? Icons.schedule : Icons.clear,
              ),
              pomodoroInteraction(
                pomodoroPauseResume,
                _pomodoroTimer.isPaused ? "Resume" : "Pause",
                _pomodoroTimer.isPaused ? Icons.play_arrow : Icons.pause,
              ),
            ],
          ),
        ),
      ],
    );
  }

  //  ----------------  Widgets  ---------------- //

  /// __pomodoroPhaseBuilder__ - Widget:
  /// <br> Erstellt einen Textfeld,
  /// indem die Phase des Pomodoro's angezeigt werden. <br>
  ValueListenableBuilder pomodoroPhaseBuilder() {
    return ValueListenableBuilder<String>(
      valueListenable: _pomodoroTimer.currentPhaseVN,
      builder: (_, phase, _) =>
          Text("Phase: $phase", style: const TextStyle(fontSize: 24)),
    );
  }

  /// __pomodoroProgressBuilder__ - Widget:
  /// <br> Erstellt eine Progressbar, in der der Fortschritt der Phase angezeigt wird. <br>
  ValueListenableBuilder pomodoroProgressBuilder() {
    return ValueListenableBuilder<Duration>(
      valueListenable: _pomodoroTimer.totalElapsedTaskTimeVN,
      builder: (context, remaining, _) {
        final totalTaskSeconds = _pomodoroTimer.taskDuration!.inSeconds;
        final elapsedSeconds = _pomodoroTimer.elapsedTaskTime.inSeconds;
        final progress = totalTaskSeconds > 0
            ? (elapsedSeconds / totalTaskSeconds).clamp(0.0, 1.0)
            : 0.0;

        return Center(
          // optional, aber hilfreich bei zentrierter Darstellung
          child: SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              color: AppColours.buttonPressed,
              backgroundColor: AppColours.buttonUnpressed,
              value: progress,
              strokeWidth: 16,
            ),
          ),
        );
      },
    );
  }

  /// __pomodoroPhaseBuilder__ - Widget:
  /// <br> Erstellt einen Textfeld,
  /// indem die Zeit für die Phase und
  /// die Zeit für die jeweilge Phase angezeigt wird. <br>
  ValueListenableBuilder pomodoroTimeBuilder() {
    return ValueListenableBuilder<Duration>(
      valueListenable: _pomodoroTimer.remainingSessionTimeVN,
      builder: (context, remaining, _) {
        final minutes = remaining.inMinutes
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        final seconds = remaining.inSeconds
            .remainder(60)
            .toString()
            .padLeft(2, '0');

        return Column(
          spacing: 15,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: 25,
                    right: 25,
                  ),
                  decoration: BoxDecoration(
                    color: AppColours.label,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    minutes,
                    style: const TextStyle(
                      fontSize: 48,
                      color: AppColours.lightText,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  ":",
                  style: TextStyle(fontSize: 48, color: AppColours.primary),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: 25,
                    right: 25,
                  ),
                  decoration: BoxDecoration(
                    color: AppColours.label,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    seconds,
                    style: const TextStyle(
                      fontSize: 48,
                      color: AppColours.lightText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "Gesamtzeit verbleibend: ${_formatDuration(_pomodoroTimer.remainingTaskTimeVN.value)}",
              style: const TextStyle(
                fontSize: 18,
                color: AppColours.label,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  /// __pomodoroInteraction__ - Widget:
  /// <br> Erstellt einen Button, die einer Funktion und ein Text übergeben wird. <br>
  /// * <br>__Benötigt:__
  /// * Die Funktion, welcher der Button onPress bekommen soll __[Function : funct]__
  /// * Der Text, welcher der Button bekommen soll __[Text : txt]__
  ElevatedButton pomodoroInteraction(
    VoidCallback funct,
    String txt,
    IconData icon,
  ) {
    return ElevatedButton(
      onPressed: funct,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColours.buttonPressed),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Icon(icon, color: AppColours.lightText),
          Text(txt, style: TextStyle(color: AppColours.lightText)),
        ],
      ),
    );
  }

  /// __pomodoroOption__ - Widget:
  /// <br> Erstellt einen ButtonSegment, der für SegmentedButtons benötigt werden. <br>
  /// * <br>__Benötigt:__
  /// * Der Label für den Button __[String : label]__
  /// * Der Icon für den Button __[IconData : icon]__
  ButtonSegment<String> pomodoroOption(String label, IconData icon) {
    return ButtonSegment<String>(
      value: label,
      label: Text(label, style: TextStyle(color: AppColours.buttonPressed)),
      icon: Icon(icon, color: AppColours.buttonPressed),
    );
  }

  //  ----------------  Methoden  ---------------- //

  /// __formatDuration__ - Funktion:
  /// <br> Formatiert Eine Zeit in ein "mm:ss" - Format. <br>
  /// <br>__Benötigt:__
  /// * Die Zeit welche dargestellt werden soll __[Duration : taskDuration]__
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  /// pomodoroPauseResume - Funktion:
  /// <br> Dies regelt die Pause / Resume Steuerung des Timers
  void pomodoroPauseResume() {
    if (_pomodoroTimer.isPaused) {
      if (kDebugMode) {
        print("🔁 Resume gedrückt");
      }
      _pomodoroTimer.resumeTask();
    } else {
      if (kDebugMode) {
        print("⏸️ Pause gedrückt");
      }
      _pomodoroTimer.pauseTask();
    }
    setState(() {});
  }

  /// __pomodoroStartCancel__  - Funktion:
  /// <br> Dies regelt die Start / Cancel Steuerung des Timers. <br>
  void pomodoroStartCancel() {
    if (_pomodoroTimer.taskRunning == false) {
      if (kDebugMode) {
        print("Task gestartet");
      }
      _pomodoroTimer.startSession();
    } else {
      if (kDebugMode) {
        print("Task gecancelled");
      }
      _pomodoroTimer.cancelTask();
    }
    setState(() {});
  }
}
