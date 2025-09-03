import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';

class User {
  final String uID;
  final String username;
  final String email;
  String _hashedPassword;
  String profilePath;
  final DateTime createdAt;
  DateTime? lastLogin;
  bool isVerified;

  User({
    required this.uID,
    required this.username,
    required this.email,
    required String password,
    required this.profilePath,
    DateTime? createdAt,
    this.lastLogin,
    this.isVerified = false,
  }) : _hashedPassword = _hashPassword(password),
       createdAt = createdAt ?? DateTime.now();

  factory User.newUser(
    String username,
    String email,
    String password,
    String profilePath,
  ) {
    final uuid = Uuid().v4();
    return User(
      uID: uuid,
      username: username,
      email: email,
      password: password,
      profilePath: profilePath,
    );
  }

  bool checkPassword(String password) {
    return BCrypt.checkpw(password, _hashedPassword);
  }

  void updatePassword(String newPassword) {
    _hashedPassword = _hashPassword(newPassword);
  }

  static String _hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  bool isValidEmail() {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  Map<String, dynamic> toJson() {
    return {
      'u_id': uID,
      'username': username,
      'email': email,
      'hashedPassword': _hashedPassword,
      'profilePath': profilePath,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      uID: json['u_id'],
      username: json['username'],
      email: json['email'],
      password: '',
      profilePath: json['profilePath'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
    );
    user._hashedPassword = json['hashedPassword'];
    return user;
  }

  @override
  String toString() {
    return 'User(u_id: $uID, username: $username, email: $email, profilePath: $profilePath, createdAt: $createdAt, lastLogin: $lastLogin';
  }
}
