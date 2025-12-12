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
      stepsToday: 0,
      encountersCompleted: 0,
      colorIndex: colorIndex,
    );

    await _profilesRef.doc(user.uid).set(profile.toJson());
  }

  // ----------------- Week 2: Steps, XP, and Encounters -----------------

  Future<PlayerProfile> _getCurrentProfileOrThrow() async {
    final user = _auth.currentUser;
    if (user == null) throw 'Not signed in';

    final snap = await _profilesRef.doc(user.uid).get();
    if (!snap.exists || snap.data() == null) {
      // If for some reason there is no profile, create a default one
      final profile = PlayerProfile.initial(user.uid);
      await _profilesRef.doc(user.uid).set(profile.toJson());
      return profile;
    }

    return PlayerProfile.fromJson(snap.data()!, snap.id);
  }

  int _xpNeededForLevel(int level) {
    // Simple level curve: 100 XP for level 1, +50 per level
    return 100 + (level - 1) * 50;
  }

  PlayerProfile _applyXp(PlayerProfile profile, int xpGain) {
    int xp = profile.xp + xpGain;
    int level = profile.level;

    while (xp >= _xpNeededForLevel(level)) {
      xp -= _xpNeededForLevel(level);
      level++;
    }

    return profile.copyWith(
      xp: xp,
      level: level,
    );
  }

  /// Adds steps to the current user, converts them to XP and updates progress.
  ///
  /// This is a mock/demo step integrator. In a future sprint, you would
  /// replace the delta with real Google Fit / Apple Health sync.
  Future<PlayerProfile> addSteps(int delta) async {
    if (delta <= 0) {
      return _getCurrentProfileOrThrow();
    }

    var profile = await _getCurrentProfileOrThrow();

    final newStepsToday = profile.stepsToday + delta;
    final newStepsLifetime = profile.stepsLifetime + delta;

    // Simple formula: 1 XP per 20 steps
    final xpGain = delta ~/ 20;

    profile = profile.copyWith(
      stepsToday: newStepsToday,
      stepsLifetime: newStepsLifetime,
    );

    profile = _applyXp(profile, xpGain);

    await _profilesRef
        .doc(profile.id)
        .set(profile.toJson(), SetOptions(merge: true));

    return profile;
  }

  /// How many steps remain until the next encounter milestone.
  ///
  /// Milestones: 1000, 2000, 3000 lifetime steps, etc.
  int stepsToNextEncounter(PlayerProfile profile) {
    final nextMilestone = (profile.encountersCompleted + 1) * 1000;
    final remaining = nextMilestone - profile.stepsLifetime;
    if (remaining <= 0) return 0;
    return remaining;
  }

  /// Completes an encounter if the player has reached the step milestone.
  ///
  /// Grants bonus XP and increments encountersCompleted.
  Future<PlayerProfile> completeEncounter() async {
    var profile = await _getCurrentProfileOrThrow();

    final remaining = stepsToNextEncounter(profile);
    if (remaining > 0) {
      // Not yet eligible; just return profile unchanged.
      return profile;
    }

    // Reward XP for winning the encounter
    const int encounterXp = 50;
    profile = profile.copyWith(
      encountersCompleted: profile.encountersCompleted + 1,
    );
    profile = _applyXp(profile, encounterXp);

    await _profilesRef
        .doc(profile.id)
        .set(profile.toJson(), SetOptions(merge: true));

    // You could also log encounters in a subcollection here if desired:
    // await _profilesRef.doc(profile.id).collection('encounters').add({...});

    return profile;
  }
}
