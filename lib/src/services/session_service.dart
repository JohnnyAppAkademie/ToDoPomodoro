import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyUserId = 'currentUserId';
  static const _keyLocale = 'currentLocale';

  static String? _currentUserId;
  static String? get currentUserId => _currentUserId;

  static String? _currentLocale;
  static String? get currentLocale => _currentLocale;

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

  static Future<void> saveLocale(String localeCode) async {
    _currentLocale = localeCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, localeCode);
  }

  static Future<String?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLocale);
  }
}
