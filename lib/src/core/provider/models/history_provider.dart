/* General Import */
import 'package:flutter/material.dart';

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart' show HistoryEntry;

/* History Service */
import 'package:todopomodoro/src/services/history_service.dart';

class HistoryProvider with ChangeNotifier {
  List<HistoryEntry> _history = [];

  /// Jetzt geben wir direkt die veränderbare Liste zurück
  List<HistoryEntry> get history => _history;

  /// Lade History aus SharedPreferences
  Future<void> loadHistory(String userID) async {
    _history = await HistoryService.loadForUser(userID);
    notifyListeners();
  }

  Future<List<HistoryEntry>> fetchHistory(String userID) async {
    await loadHistory(userID);
    return _history;
  }

  Future<void> addHistory(HistoryEntry entry) async {
    _history.add(entry);
    await _deleteOlderThan(30);
    await HistoryService.save(_history);
    notifyListeners();
  }

  /// Eintrag aktualisieren (z.B. wenn Pomodoro endet)
  Future<void> updateHistory(HistoryEntry updatedEntry) async {
    final index = _history.indexWhere((e) => e.uID == updatedEntry.uID);
    if (index == -1) {
      return;
    }

    _history[index] = updatedEntry;

    await HistoryService.save(_history);
    notifyListeners();
  }

  /// Eintrag löschen
  Future<void> deleteHistory(String uID) async {
    _history.removeWhere((e) => e.uID == uID);
    await HistoryService.save(_history);
    notifyListeners();
  }

  /// Komplette History löschen
  Future<void> clearHistory() async {
    _history.clear();
    await HistoryService.clear();
    notifyListeners();
  }

  /// Ältere Einträge automatisch entfernen
  Future<void> _deleteOlderThan(int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    _history.removeWhere((e) => e.startedAt.isBefore(cutoff));
    await HistoryService.save(_history);
  }
}
