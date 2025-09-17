// lib/src/services/user_service.dart
import 'package:todopomodoro/src/core/data/data.dart' show User, AuthRepository;
import 'package:todopomodoro/src/core/repositories/repositories.dart'
    show UserRepository;

class UserService {
  final UserRepository repository;
  final AuthRepository auth;

  UserService(this.repository, this.auth);

  /// Registrierung: Auth + lokales Speichern
  Future<User> register({
    required String username,
    required String email,
    required String password,
    required String profilePath,
  }) async {
    final cred = await auth.registerWithEmail(email, password);

    final user = User(
      uID: cred.user!.uid,
      username: username,
      password: password,
      email: email,
      profilePath: profilePath,
    );

    await repository.addUser(user);
    return user;
  }

  /// Login: Auth + lokalen User laden
  Future<User?> login(String email, String password) async {
    await auth.signInWithEmail(email, password);
    return await repository.getByEmail(email);
  }

  Future<void> logout() async => await auth.signOut();

  Future<void> changePassword(String userId, String newPassword) async {
    await auth.changePassword(newPassword);
    await repository.updatePassword(userId, newPassword);
  }

  Future<User?> getById(String userId) async =>
      await repository.getById(userId);

  Future<void> updateProfilePicture(
    String userId,
    String newProfilePath,
  ) async => await repository.updateProfilePath(userId, newProfilePath);

  Future<void> updateUsername(String userId, String newUsername) async =>
      await repository.updateName(userId, newUsername);
}
