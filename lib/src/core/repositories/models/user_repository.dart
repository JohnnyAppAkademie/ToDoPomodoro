import 'package:sqflite/sqflite.dart';
import 'package:todopomodoro/src/core/data/data.dart' show User;

class UserRepository {
  final Database db;

  UserRepository(this.db);

  /// Neuen User speichern
  Future<void> addUser(User user) async {
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// User anhand der ID abrufen
  Future<User?> getById(String id) async {
    final maps = await db.query(
      'users',
      where: 'u_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return maps.isNotEmpty ? User.fromJson(maps.first) : null;
  }

  /// User anhand der E-Mail abrufen
  Future<User?> getByEmail(String email) async {
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return maps.isNotEmpty ? User.fromJson(maps.first) : null;
  }

  /// Sicherer Login mit bcrypt
  Future<User?> login(String identifier, String password) async {
    final isEmail = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(identifier);

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: isEmail ? 'email = ?' : 'username = ?',
      whereArgs: [identifier],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final user = User.fromJson(maps.first);

    // Passwort prüfen
    final isValid = user.checkPassword(password);
    if (!isValid) return null;

    // Letzten Login aktualisieren
    final now = DateTime.now();
    await db.update(
      'users',
      {'lastLogin': now.toIso8601String()},
      where: 'u_id = ?',
      whereArgs: [user.uID],
    );

    user.lastLogin = now;
    return user;
  }

  /// User löschen
  Future<void> deleteUser(String id) async {
    await db.delete('users', where: 'u_id = ?', whereArgs: [id]);
  }

  Future<void> updateProfilePath(String uID, String newProfilePath) async {
    await db.update(
      'users',
      {'profilePath': newProfilePath},
      where: 'u_id = ?',
      whereArgs: [uID],
    );
  }

  /// Passwort aktualisieren (mit Hashing)
  Future<void> updatePassword(String userId, String newPassword) async {
    final user = await getById(userId);
    if (user == null) return;

    user.updatePassword(newPassword);

    await db.update(
      'users',
      {'hashedPassword': user.toJson()['hashedPassword']},
      where: 'u_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> updateName(String userId, String newUsername) async {
    final user = await getById(userId);
    if (user == null) return;

    user.updateName(newUsername);

    await db.update(
      'users',
      {'username': user.toJson()['username']},
      where: 'u_id = ?',
      whereArgs: [userId],
    );
  }
}
