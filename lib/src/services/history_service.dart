import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todopomodoro/src/core/data/data.dart' show HistoryEntry;

class HistoryService {
  static const _historyKey = 'history';
  static SharedPreferences? _prefs;

  /// Initialisierung einmal beim App-Start
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<List<HistoryEntry>> load() async {
    await initialize();
    final List<String> rawHistory = _prefs?.getStringList(_historyKey) ?? [];
    return rawHistory.map((e) => HistoryEntry.fromJson(jsonDecode(e))).toList();
  }

  static Future<List<HistoryEntry>> loadForUser(String userID) async {
    final allHistory = await load();
    return allHistory.where((entry) => entry.userID == userID).toList();
  }

  static Future<void> save(List<HistoryEntry> history) async {
    await initialize();
    final List<String> rawHistory = history
        .map((e) => jsonEncode(e.toJson()))
        .toList();
    await _prefs?.setStringList(_historyKey, rawHistory);
  }

  static Future<void> clear() async {
    await initialize();
    await _prefs?.remove(_historyKey);
  }
}
