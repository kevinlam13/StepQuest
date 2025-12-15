import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /// ------------------------------
  /// Register new user
  /// ------------------------------
  Future<User?> register({
    required String email,
    required String password,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user == null) return null;

    // ---------------------------------------
    // 🔥 CREATE EMPTY PROFILE FOR NEW USERS
    // Prevents auto-signout and routing issues
    // ---------------------------------------
    await _db.collection("users").doc(user.uid).set({
      "displayName": null,
      "heroClass": null,
      "colorIndex": null,
      "guildId": null,

      // Starting stats
      "level": 1,
      "xp": 0,
      "xpNeededForNextLevel": 100,

      "todaySteps": 0,
      "totalSteps": 0,
      "stepsUntilNextEncounter": 1000,

      "dailyQuestGoal": 2500,
      "dailyQuestProgress": 0,
      "dailyQuestCompleted": false,

      // Cosmetics default
      "hairstyle": "none",
      "hairColorIndex": 0,
      "hatType": "none",
      "facialHair": "none",
    }, SetOptions(merge: true));

    return user;
  }

  /// ------------------------------
  /// Login
  /// ------------------------------
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  /// ------------------------------
  /// Logout
  /// ------------------------------
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// ------------------------------
  /// Auth Stream
  /// ------------------------------
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
