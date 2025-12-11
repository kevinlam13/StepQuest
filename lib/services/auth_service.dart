import 'package:firebase_auth/firebase_auth.dart';

/// Simple wrapper around FirebaseAuth for StepQuest.
/// Handles login, registration, and sign out.
class AuthService {
  AuthService._internal();

  static final AuthService instance = AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Stream of auth state changes (signed in / signed out).
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  /// Currently signed-in user (or null).
  User? get currentUser => _firebaseAuth.currentUser;

  /// Register a new user with email + password.
  /// Throws a string message on error (for easy UI display).
  Future<User?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (_) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Sign in with email + password.
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (_) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Password is too weak (min 6 characters).';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      default:
        return e.message ?? 'Authentication error. Please try again.';
    }
  }
}
