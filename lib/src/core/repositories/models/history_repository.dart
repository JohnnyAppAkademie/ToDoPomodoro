import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/data/data.dart' show HistoryEntry;
import 'package:todopomodoro/src/services/history_service.dart';

class HistoryProvider with ChangeNotifier {
  List<HistoryEntry> _history = [];

  List<HistoryEntry> get history => List.unmodifiable(_history);

  Future<void> loadHistory() async {
    _history = await HistoryService.load();
    await _deleteOlderThan(30);
    notifyListeners();
  }

  Future<void> addHistory(HistoryEntry entry) async {
    _history.add(entry);
    await HistoryService.save(_history);
    notifyListeners();
  }

  Future<void> deleteHistory(String uID) async {
    _history.removeWhere((e) => e.uID == uID);
    await HistoryService.save(_history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    await HistoryService.clear();
    notifyListeners();
  }

  Future<void> _deleteOlderThan(int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    _history.removeWhere((e) => e.startedAt.isBefore(cutoff));
    await HistoryService.save(_history);
    notifyListeners();
  }
}
