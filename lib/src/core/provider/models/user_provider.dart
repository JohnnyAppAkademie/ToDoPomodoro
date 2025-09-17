// lib/src/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import 'package:todopomodoro/src/core/data/data.dart' show User;
import 'package:todopomodoro/src/core/database/database.dart';
import 'package:todopomodoro/src/core/repositories/repositories.dart'
    show UserRepository, FirebaseAuthRepository;

import 'package:todopomodoro/src/services/user_service.dart';
import 'package:todopomodoro/src/services/session_service.dart';

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

    final db = await DatabaseHelper.instance.database;
    service = UserService(UserRepository(db), FirebaseAuthRepository());

    await loadCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

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
      if (kDebugMode) print('Registration error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password, {Duration? delay}) async {
    if (delay != null) await Future.delayed(delay);
    try {
      final user = await service.login(email, password);
      if (user != null) {
        _currentUser = user;
        await SessionManager.saveUserId(user.uID);
        notifyListeners();
        return true;
      }
    } catch (e) {
      if (kDebugMode) print('Login error: $e');
    }
    return false;
  }

  Future<void> logout() async {
    await service.logout();
    _currentUser = null;
    await SessionManager.clearSession();
    notifyListeners();
  }

  Future<void> changePassword(String newPassword) async {
    if (_currentUser == null) return;
    await service.changePassword(_currentUser!.uID, newPassword);
  }

  Future<void> loadCurrentUser() async {
    final userId = await SessionManager.getUserId();
    if (userId != null) {
      _currentUser = await service.getById(userId);
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture(String newProfilePath) async {
    if (_currentUser == null) return;
    _currentUser!.profilePath = newProfilePath;
    await service.updateProfilePicture(_currentUser!.uID, newProfilePath);
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    if (_currentUser == null) return;
    _currentUser!.username = newUsername;
    await service.updateUsername(_currentUser!.uID, newUsername);
    notifyListeners();
  }

  Future<void> waitUntilLoaded() async {
    while (_isLoading) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
