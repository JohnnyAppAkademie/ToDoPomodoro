/* General Import */
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:todopomodoro/src/core/data/data.dart' show User;
import 'package:todopomodoro/src/core/database/database.dart';
import 'package:todopomodoro/src/core/repositories/repositories.dart'
    show UserRepository, FirebaseAuthRepository;

/* Service - Import */
import 'package:todopomodoro/src/services/user_service.dart';
import 'package:todopomodoro/src/services/session_service.dart';

/* Firestore - Import */
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  late final UserService service;
  User? _currentUser;
  Locale? _currentLocale;
  Locale? get currentLocale => _currentLocale;
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotify() {
    if (!_disposed) notifyListeners();
  }

  UserProvider() {
    _initWithSync();
  }

  Future<void> _initWithSync() async {
    _isLoading = true;
    notifyListeners();

    final db = await DatabaseHelper.instance.database;
    service = UserService(UserRepository(db), FirebaseAuthRepository());

    await loadCurrentUser();

    final savedLocaleCode = await getUserLocale();
    if (savedLocaleCode != null) {
      _currentLocale = Locale(savedLocaleCode);
    }

    if (_currentUser != null) {
      await _syncUserFromFirestore(_currentUser!.uID);
      _startUserListener(_currentUser!.uID);
    }

    _isLoading = false;
    notifyListeners();
  }

  void _startUserListener(String userId) {
    _firestore.collection('users').doc(userId).snapshots().listen((doc) async {
      if (!doc.exists) return;

      _currentUser = User.fromJson(doc.data()!);
      notifyListeners();
    });
  }

  Future<void> _syncUserFromFirestore(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final backupUser = User.fromJson(doc.data()!);

        _currentUser!.username = backupUser.username;
        _currentUser!.profilePath = backupUser.profilePath;

        notifyListeners();
      } else {
        await addUserToFirestore(_currentUser!);
      }
    } catch (e) {
      if (kDebugMode) print('Firestore sync error: $e');
    }
  }

  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> addUserToFirestore(User user) async {
    await _firestore
        .collection('users')
        .doc(user.uID)
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future<void> updateUserInFirestore(User user) async {
    await _firestore.collection('users').doc(user.uID).update(user.toJson());
  }

  Future<User?> loadUserFromFirestore(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return User.fromJson(doc.data()!);
  }

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
      await addUserToFirestore(user);
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) print('Registration error: $e');
      return false;
    }
  }

  Future<bool> login(String emailOrUsername, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await service.login(emailOrUsername, password);

      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      await SessionManager.saveUserId(user.uID);

      await _syncUserFromFirestore(user.uID);
      _startUserListener(user.uID);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) print('Login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
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
    await updateUserInFirestore(_currentUser!);
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    if (_currentUser == null) return;
    _currentUser!.username = newUsername;
    await service.updateUsername(_currentUser!.uID, newUsername);
    await updateUserInFirestore(_currentUser!);
    notifyListeners();
  }

  Future<void> waitUntilLoaded() async {
    while (_isLoading) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> setUserLocale(String localeCode) async {
    if (_currentUser == null) return;

    await SessionManager.saveLocale(localeCode);

    await _firestore.collection('users').doc(_currentUser!.uID).set({
      'locale': localeCode,
    }, SetOptions(merge: true));

    _currentLocale = Locale(localeCode);

    notifyListeners();
  }

  Future<String?> getUserLocale() async {
    if (_currentUser == null) return SessionManager.getLocale();
    final doc = await _firestore
        .collection('users')
        .doc(_currentUser!.uID)
        .get();
    return (doc.data()?['locale'] as String?) ??
        await SessionManager.getLocale();
  }
}
