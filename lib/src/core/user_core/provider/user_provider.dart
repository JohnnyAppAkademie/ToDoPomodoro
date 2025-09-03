/* General Import */
import 'package:flutter/foundation.dart';

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart' show User;

/* Database - Import */
import 'package:todopomodoro/src/core/database/database.dart';

/* Repository - Import */
import 'package:todopomodoro/src/core/repositories/repositories.dart'
    show UserRepository;

/* Service - Import */
import 'package:todopomodoro/src/services/session_service.dart';
import 'package:todopomodoro/src/services/user_service.dart';

class UserProvider with ChangeNotifier {
  late final UserService service;
  User? _currentUser;
  bool _isLoading = false;

  UserProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    // DB initialisieren
    final db = await DatabaseHelper.instance.database;

    // Service mit Repository erstellen
    service = UserService(UserRepository(db));

    // Optional: aktuellen User aus Session laden
    await loadCurrentUser();

    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Registrierung
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String profilePath,
  }) async {
    try {
      final user = await service.register(
        username: username,
        email: email,
        password: password,
        profilePath: profilePath,
      );
      _currentUser = user;
      await SessionManager.saveUserId(user.uID);
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Registration error: $e');
      }
      return false;
    }
  }

  /// Login
  Future<bool> login(String email, String password, {Duration? delay}) async {
    if (delay != null) {
      await Future.delayed(delay);
    }

    final user = await service.login(email, password);
    if (user != null) {
      _currentUser = user;
      await SessionManager.saveUserId(user.uID);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Logout
  Future<void> logout() async {
    _currentUser = null;
    await SessionManager.clearSession();
    notifyListeners();
  }

  /// Passwort ändern
  Future<void> changePassword(String newPassword) async {
    if (_currentUser == null) return;
    await service.changePassword(_currentUser!.uID, newPassword);
  }

  /// Lade aktuellen User aus Session
  Future<void> loadCurrentUser() async {
    final userId = await SessionManager.getUserId();
    if (userId != null) {
      _currentUser = await service.getById(userId);
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture(String newProfilePath) async {
    if (_currentUser == null) return;

    // Lokales Update
    _currentUser!.profilePath = newProfilePath;

    // Datenbank aktualisieren
    await service.updateProfilePicture(_currentUser!.uID, newProfilePath);

    notifyListeners();
  }
}
