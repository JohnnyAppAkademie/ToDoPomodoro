/* General Import */
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:todopomodoro/src/core/data/data.dart'
    show Task, TimeUnitMode, HistoryEntry;
import 'package:todopomodoro/src/core/provider/providers.dart';

enum PomodoroPhase { idle, pomodoro, shortBreak, longBreak, paused, finished }

class PomodoroViewModel extends ChangeNotifier {
  final Task task;
  late String userID;
  final TimeUnitMode mode;

  late Duration sessionLength;
  late Duration remainingSessionTime;
  late Duration remainingTaskTime;

  PomodoroPhase phase = PomodoroPhase.idle;
  Timer? _timer;
  bool isPaused = false;
  bool isRunning = false;

  int completedPomodoros = 0;

  final HistoryProvider historyProvider;
  late HistoryEntry _historyEntry;

  PomodoroViewModel({
    required this.task,
    required this.userID,
    required this.historyProvider,
    this.mode = TimeUnitMode.minutes,
  }) {
    sessionLength = _scaleTime(25);
    remainingSessionTime = sessionLength;
    remainingTaskTime = task.duration;

    _historyEntry = HistoryEntry.newHistoryEntry(
      userID: userID,
      taskName: task.title,
      finished: false,
      startedAt: DateTime.now(),
    );

    historyProvider.addHistory(_historyEntry);
  }

  Duration _scaleTime(int value) => mode == TimeUnitMode.seconds
      ? Duration(seconds: value)
      : Duration(minutes: value);

  void startPomodoro() {
    if (isRunning) return;
    isRunning = true;
    phase = PomodoroPhase.pomodoro;
    _startSession(sessionLength);
    notifyListeners();
  }

  void _startSession(Duration duration) {
    if (remainingTaskTime < duration) {
      remainingSessionTime = remainingTaskTime;
    } else {
      remainingSessionTime = duration;
    }

    phase = PomodoroPhase.pomodoro;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSessionTime.inSeconds > 0) {
        remainingSessionTime -= const Duration(seconds: 1);
        remainingTaskTime -= const Duration(seconds: 1);
      } else {
        t.cancel();
        completedPomodoros++;

        if (remainingTaskTime <= Duration.zero) {
          _finishPomodoro();
        } else {
          if (completedPomodoros % 4 == 0) {
            _startBreak(_scaleTime(15), PomodoroPhase.longBreak);
          } else {
            _startBreak(_scaleTime(5), PomodoroPhase.shortBreak);
          }
        }
      }
      notifyListeners();
    });
  }

  void _startBreak(Duration duration, PomodoroPhase breakPhase) {
    phase = breakPhase;
    remainingSessionTime = duration;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSessionTime.inSeconds > 0) {
        remainingSessionTime -= const Duration(seconds: 1);
      } else {
        t.cancel();
        startPomodoro();
      }
      notifyListeners();
    });
  }

  void pausePomodoro() {
    if (!isRunning || isPaused) return;
    isPaused = true;
    _timer?.cancel();
    phase = PomodoroPhase.paused;
    notifyListeners();
  }

  void resumePomodoro() {
    if (!isPaused) return;
    isPaused = false;
    _startSession(remainingSessionTime);
    notifyListeners();
  }

  void cancelPomodoro() {
    _timer?.cancel();
    isRunning = false;
    isPaused = false;
    phase = PomodoroPhase.idle;
    remainingSessionTime = sessionLength;
    remainingTaskTime = task.duration;
    notifyListeners();
  }

  void _finishPomodoro() {
    _timer?.cancel();
    isRunning = false;
    phase = PomodoroPhase.finished;
    _historyEntry.finished = true;
    _historyEntry.endedAt = DateTime.now();
    historyProvider.updateHistory(_historyEntry);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
