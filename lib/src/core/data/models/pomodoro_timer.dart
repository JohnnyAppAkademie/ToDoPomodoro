import 'dart:async';
import 'package:flutter/foundation.dart';

/*  Schalter für die Testung von Sekunden / Minuten */
enum TimeUnitMode { minutes, seconds }

/// __PomodoroTimer__ - Klasse
/// <br> Die Klasse für den Pomodoro - Timer
/// <br> Behandelt Timer und Pausen
class PomodoroTimer {
  //  Attribute //

  /*  Zeitschalter  */
  late final TimeUnitMode mode;
  /*  Task - Timer  */
  Timer? timer;
  /*  Flag - Laufender Pomodoro */
  bool taskRunning = false;

  /*  Task  - Gesamtlänge */
  Duration? taskDuration;
  /*  Task  - Vergangene Zeit */
  late Duration elapsedTaskTime = Duration(seconds: 0);
  /* Task - Übrige Task-Zeit */
  late Duration remainingTaskTime;
  /*  Session - Dauer */
  late Duration sessionLength;

  /*  Flag - Task pausiert  */
  bool isPaused = false;
  /*  Speicherung der pausierten Zeit */
  Duration pausedRemaining = Duration.zero;
  /*  Speicherung der gestopten Phase */
  String pausedPhase = "";
  /*  User bricht den Task ab */
  bool userCancelled = false;

  /*  Callbacks für Pausen  */
  VoidCallback? _pausedCallback;
  VoidCallback? _resumeCallback;

  /* Session - Attribute */
  int breakCounter = 0;
  int breakCount = 0;
  int longBreaks = 0;
  int shortBreaks = 0;

  Duration getSessionLength() => _scaleTime(25);
  Duration getShortBreak() => _scaleTime(5);
  Duration getLongBreak() => _scaleTime(15);

  /* ValueNotifier für UI */
  final ValueNotifier<Duration> remainingTaskTimeVN = ValueNotifier(
    Duration.zero,
  );
  final ValueNotifier<Duration> remainingSessionTimeVN = ValueNotifier(
    Duration.zero,
  );
  final ValueNotifier<Duration> totalElapsedTaskTimeVN = ValueNotifier(
    Duration.zero,
  );
  final ValueNotifier<String> currentPhaseVN = ValueNotifier("Idle");

  ///  __PomodoroTimer__ - Konstruktor:
  /// <br> Der Timer, welcher für Pausen und Timer benutzt wird <br>
  /// <br>__Benötigt:__
  /// * Die angegebene Zeit der Aufgabe __[Duration : taskDuration]__
  /// * Ein Flag, ob es sich um Tests handelt __[TimeUnitMode : mode]__ -> ( [TimeUnitMode: seconds, minutes ] )
  PomodoroTimer({required this.taskDuration, required this.mode}) {
    /* Je nach Modus kann sessionLength angepasst werden  */
    sessionLength = getSessionLength();

    /*  Berechnen der Anzahl von Pausen */
    if (taskDuration != Duration.zero) {
      if (mode == TimeUnitMode.seconds) {
        breakCount = (taskDuration!.inSeconds / getSessionLength().inSeconds)
            .floor();
      } else {
        breakCount = (taskDuration!.inMinutes / getSessionLength().inMinutes)
            .floor();
      }
      longBreaks = (breakCount / 4).floor();
      shortBreaks = breakCount - longBreaks;

      /*  Initalisierung der Taskzeit */
      remainingTaskTime = taskDuration!;

      /*  Initialisierung für die ValueListener */
      remainingTaskTimeVN.value = taskDuration!;
      remainingSessionTimeVN.value = sessionLength;
    }
    if (kDebugMode) {
      print("Task Duration: $taskDuration");
      print("Total Breaks: $breakCount");
      print("Long Breaks: $longBreaks");
      print("Short Breaks: $shortBreaks");
    }
  }

  /// __scaleTime()__ - Funktion:
  /// <br> Skaliert die Zeit auf Minuten oder Sekunden.
  /// <br>__Benötigt:__
  /// * Die Zahl, die es umzuwandeln gilt __[int: value]__
  Duration _scaleTime(int value) {
    return mode == TimeUnitMode.seconds
        ? Duration(seconds: value)
        : Duration(minutes: value);
  }

  /// __startSession()__ - Funktion:
  /// <br>Startet die Pomodoro-Session für die Aufgabe
  /// <br>__Wird nur einmal per Task ausgeführt!__
  void startSession() {
    /* Wenn die Task keine Dauer hat / Wenn ein Task schon läuft / wenn ein Timer schon läuft */
    if (taskDuration == Duration.zero ||
        taskRunning ||
        (timer?.isActive ?? false)) {
      if (kDebugMode) {
        print(
          "Session cannot start. Timer: ${timer?.isActive} | Task:$taskRunning",
        );
      }
      return;
    }

    taskRunning = true; //  Die Task ist nun am Laufen
    int completedPomodoros = 0; //  Anzahl der passierten Sessions
    userCancelled = false; //  Der User hat die Task noch nicht gestopt
    remainingSessionTimeVN.value =
        remainingTaskTime; //  Tasktime wird dem Listener übergeben

    /// __runPomodoroCycle()__ - Nested Funktion:
    /// Controlliert die Sessions
    /// (__Rekursiver Call__)
    void runPomodoroCycle() {
      /*  Wenn alle Pomodoros erfolgt sind  */
      if (completedPomodoros >= breakCount &&
          remainingTaskTime == Duration.zero) {
        if (kDebugMode) {
          print("Pomodoro session finished.");
        }
        taskRunning = false;
        currentPhaseVN.value = "Finished";
        remainingSessionTimeVN.value = Duration.zero;
        remainingTaskTimeVN.value = Duration.zero;
        return;
      }
      /*  Wenn die Task gecanceled wurde  */
      if (userCancelled) {
        if (kDebugMode) {
          print("Pomodoro session was canceled.");
        }
        taskRunning = false;
        currentPhaseVN.value = "Cancelled";
        remainingSessionTimeVN.value = sessionLength;
        remainingTaskTimeVN.value = taskDuration!;
        remainingTaskTime = taskDuration!;
      }

      /* Start Arbeits-Session  */
      _startTimer(getSessionLength(), "Pomodoro", () {
        completedPomodoros++;
        breakCounter++;

        /* Starte Pause-Session */
        bool isLongBreak = (breakCounter % 4 == 0);
        Duration breakDuration = isLongBreak ? getLongBreak() : getShortBreak();
        String breakType = isLongBreak ? "Long Break" : "Short Break";
        _startTimer(breakDuration, breakType, () {
          runPomodoroCycle();
        });
      });
    }

    runPomodoroCycle();
  }

  /// __startTimer()__ - Funktion:
  /// <br> Startet einen Timer auf begrenzte Zeit.
  /// <br>__Benötigt:__
  /// * Die Zeit für den Timer __[Duration : duration]__
  /// * Die Beschriftung der Phase __[String : label]__
  /// * Eine Null-Funktion __[void : onDone]__ -> (_Immer: "()"_)
  void _startTimer(Duration duration, String label, void Function() onDone) {
    if (kDebugMode) {
      if (mode == TimeUnitMode.seconds) {
        print(
          "⏱️ $label started for ${duration.inSeconds} seconds... (Total: $remainingTaskTime)",
        );
      } else {
        print(
          "⏱️ $label started for ${duration.inMinutes} minutes... (Total: $remainingTaskTime)",
        );
      }
    }

    /*  Merke den Callback, falls Pause gedrückt wird */
    _resumeCallback = onDone;
    currentPhaseVN.value = label;

    /*  Bestimme tatsächliche Dauer (z.B. bei letzter Pomodoro-Phase) */
    Duration actualDuration = duration < remainingTaskTime
        ? duration
        : remainingTaskTime;

    /*  UI updaten  */
    remainingSessionTimeVN.value = actualDuration;

    /* Nur bei Arbeitszeit (Pomodoro) Task-Zeit reduzieren  */
    if (label.toLowerCase() == "pomodoro") {
      remainingTaskTime -= actualDuration;
    }

    /*  Alten Timer abbrechen */
    timer?.cancel();
    Duration remaining = actualDuration;

    /* Neue Sitzung starten */
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      remaining -= const Duration(seconds: 1);
      if (remaining.inSeconds >= 0) {
        remainingSessionTimeVN.value = remaining;
        if (label.toLowerCase() == "pomodoro") {
          elapsedTaskTime += const Duration(seconds: 1);
          remainingTaskTimeVN.value -= const Duration(seconds: 1);
          totalElapsedTaskTimeVN.value += const Duration(seconds: 1);
        }
      }

      /*  Timer hat die Task-Dauer erreicht*/
      if (remaining <= Duration.zero) {
        t.cancel();
        if (kDebugMode) {
          print("✅ $label ended.");
          if (mode == TimeUnitMode.seconds) {
            print(
              "⏳ Remaining total task time: ${remainingTaskTime.inSeconds}s",
            );
          } else {
            print(
              "⏳ Remaining total task time: ${remainingTaskTime.inMinutes}s",
            );
          }
        }
        if (!userCancelled) {
          onDone();
        }
      }
      /* Task wurde während des Timers gestoppt */
      if (userCancelled) {
        timer!.cancel();
        if (kDebugMode) {
          print("User has cancelled Task during RunTime");
        }
      }
    });
  }

  /// Funktion:
  /// <br>__startCustomTimer()__
  /// <br> Startet einen Timer auf bestimmter Zeit. (_Benötigt für Pausen!_)
  /// <br>__Benötigt:__
  /// * Die Zeit für den Timer __[Duration : duration]__
  /// * Die Beschriftung der Phase __[String : label]__
  /// * Eine Null-Funktion __[void : onDone]__ -> (_Immer: "()"_)
  void _startCustomTimer(Duration duration, String label, VoidCallback onDone) {
    /* Übertrage die restliche Zeit an den Listener */
    remainingSessionTimeVN.value = duration;
    if (label.toLowerCase() == "pomodoro") {
      remainingTaskTime -= duration;
    }

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      duration -= const Duration(seconds: 1);

      if (duration.inSeconds >= 0) {
        remainingSessionTimeVN.value = duration;
        if (label.toLowerCase() == "pomodoro") {
          elapsedTaskTime += const Duration(seconds: 1);
          remainingTaskTimeVN.value -= Duration(seconds: 1);
          totalElapsedTaskTimeVN.value += const Duration(seconds: 1);
        }
      }

      /*  Die übrige Zeit wurde erreicht*/
      if (duration <= Duration.zero) {
        t.cancel();
        if (!userCancelled) {
          onDone();
        }
      }

      /* Task wurde während des Timers gestoppt */
      if (userCancelled) {
        timer!.cancel();
        if (kDebugMode) {
          print("User has cancelled Task during RunTime");
        }
      }
    });
  }

  /// __cancelTask()__ - Funktion:
  /// <br> Beendet den Task.
  void cancelTask() {
    timer?.cancel();
    timer = null;
    userCancelled = true;

    taskRunning = false;
    isPaused = false;

    // Setzt alle Zeitwerte zurück
    remainingTaskTimeVN.value = taskDuration!;
    remainingTaskTime = taskDuration!;
    remainingSessionTimeVN.value = taskDuration!;
    elapsedTaskTime = Duration.zero;
    totalElapsedTaskTimeVN.value = Duration.zero;

    // Setzt den Fortschritt zurück
    currentPhaseVN.value = "Idle";

    if (kDebugMode) {
      print("❌ Timer cancelled.");
    }
  }

  /// __pauseTask()__ - Funktion:
  /// <br> Pausiert den Task
  void pauseTask() {
    if (!taskRunning || timer == null || isPaused) return;

    isPaused = true;
    timer?.cancel();
    pausedRemaining = remainingSessionTimeVN.value;
    pausedPhase = currentPhaseVN.value;
    _pausedCallback = _resumeCallback;

    if (kDebugMode) {
      if (mode == TimeUnitMode.seconds) {
        print("⏸️ Timer paused at ${pausedRemaining.inSeconds} seconds.");
      } else {
        print("⏸️ Timer paused at ${pausedRemaining.inMinutes} minutes.");
      }
    }
    currentPhaseVN.value = "Paused";
  }

  /// __resumeTask()__ - Funktion:
  /// <br> Pausiert den Task
  void resumeTask() {
    if (!isPaused || pausedRemaining == Duration.zero) return;

    if (kDebugMode) {
      if (mode == TimeUnitMode.seconds) {
        print(
          "▶️ Resuming $pausedPhase for ${pausedRemaining.inSeconds} seconds...",
        );
      } else {
        print(
          "▶️ Resuming $pausedPhase for ${pausedRemaining.inMinutes} minutes...",
        );
      }

      isPaused = false;
      currentPhaseVN.value = pausedPhase;
      _startCustomTimer(pausedRemaining, pausedPhase, _pausedCallback!);
    }
  }
}
