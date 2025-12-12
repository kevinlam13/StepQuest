import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/player_profile.dart';

/// Handles reading/writing player profiles in Firestore.
///
/// Collection: `profiles`
/// Document id: Firebase Auth uid
class ProfileService {
  ProfileService._internal();

  static final ProfileService instance = ProfileService._internal();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _profilesRef =>
      _firestore.collection('profiles');

  /// Stream of the current user's profile, or null if none exists yet.
  Stream<PlayerProfile?> watchCurrentUserProfile() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _profilesRef.doc(user.uid).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return PlayerProfile.fromJson(snap.data()!, snap.id);
    });
  }

  /// Create or update the current user's profile.
  Future<void> upsertCurrentUserProfile(PlayerProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw 'Not signed in';
    }

    await _profilesRef
        .doc(user.uid)
        .set(profile.toJson(), SetOptions(merge: true));
  }

  /// Convenience method to create a fresh profile from raw fields.
  Future<void> createCharacter({
    required String displayName,
    required String heroClass,
    required int colorIndex,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Not signed in';

    final profile = PlayerProfile(
      id: user.uid,
      displayName: displayName,
      heroClass: heroClass,
      level: 1,
      xp: 0,
      stepsLifetime: 0,
      colorIndex: colorIndex,
    );

    await _profilesRef.doc(user.uid).set(profile.toJson());
  }
}
