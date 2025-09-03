import 'package:todopomodoro/src/core/data/data.dart' show User;
import 'package:todopomodoro/src/core/repositories/repositories.dart'
    show UserRepository;

class UserService {
  final UserRepository repository;

  UserService(this.repository);

  Future<User> register({
    required String username,
    required String email,
    required String password,
    required String profilePath,
  }) async {
    final existing = await repository.getByEmail(email);
    if (existing != null) {
      throw Exception('User with this email already exists');
    }

    final user = User.newUser(username, email, password, profilePath);
    await repository.addUser(user);
    return user;
  }

  Future<User?> login(String email, String password, {Duration? delay}) async {
    if (delay != null) {
      await Future.delayed(delay);
    }
    return repository.login(email, password);
  }

  Future<void> changePassword(String userId, String newPassword) async {
    await repository.updatePassword(userId, newPassword);
  }

  Future<User?> getById(String userId) async {
    return repository.getById(userId);
  }

  Future<void> logout() async {}

  Future<void> updateProfilePicture(String uID, String newProfilePath) async {
    await repository.updateProfilePath(uID, newProfilePath);
  }

  Future<void> updateUsername(String uID, String newUsername) async {
    await repository.updateName(uID, newUsername);
  }
}
