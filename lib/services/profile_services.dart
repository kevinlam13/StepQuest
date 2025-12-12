import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/player_profile.dart';

class ProfileService {
  static final ProfileService instance = ProfileService._();
  ProfileService._();

  final _users = FirebaseFirestore.instance.collection("users");

  Future<PlayerProfile?> getProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;

    return PlayerProfile.fromDoc(doc);
  }

  Future<void> createProfile({
    required String uid,
    required String email,
    required int bodyColor,
    required int eyeStyle,
    required int hairStyle,
    required String guild,
  }) async {
    await _users.doc(uid).set({
      "uid": uid,
      "email": email,
      "level": 1,
      "xp": 0,
      "weeklySteps": 0,
      "guild": guild,
      "bodyColor": bodyColor,
      "eyeStyle": eyeStyle,
      "hairStyle": hairStyle,
      "hatStyle": -1, // no cosmetic yet
    });
  }

  Future<void> addSteps(int steps) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await _users.doc(uid).get();
    final profile = PlayerProfile.fromDoc(doc);

    final int newXp = profile.xp + steps;
    final int xpNeeded = 500;

    int level = profile.level;
    int xp = newXp;

    while (xp >= xpNeeded) {
      xp -= xpNeeded;
      level++;
    }

    await _users.doc(uid).update({
      "xp": xp,
      "level": level,
      "weeklySteps": profile.weeklySteps + steps,
    });

    // Update guild weekly steps
    await FirebaseFirestore.instance
        .collection("guilds")
        .doc(profile.guild)
        .update({
      "weeklySteps": FieldValue.increment(steps),
    });
  }

  Future<void> equipHat(int index) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _users.doc(uid).update({"hatStyle": index});
  }
}
