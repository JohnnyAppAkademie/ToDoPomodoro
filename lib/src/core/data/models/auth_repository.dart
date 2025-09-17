// lib/src/core/repositories/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart' as fb;

abstract class AuthRepository {
  Future<fb.UserCredential> registerWithEmail(String email, String password);
  Future<fb.UserCredential> signInWithEmail(String email, String password);
  Future<void> signOut();
  fb.User? get currentUser;
  Future<void> changePassword(String newPassword);
}
