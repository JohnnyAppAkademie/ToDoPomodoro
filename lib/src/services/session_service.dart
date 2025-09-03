import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyUserId = 'currentUserId';
  static String? _currentUserId;
  static String? get currentUserId => _currentUserId;

  static Future<void> saveUserId(String userId) async {
    _currentUserId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<void> clearSession() async {
    _currentUserId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
  }
}
