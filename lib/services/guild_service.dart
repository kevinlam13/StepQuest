import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuildService {
  GuildService._();
  static final GuildService instance = GuildService._();

  final _db = FirebaseFirestore.instance;

  /// Join a guild, auto-create if missing
  Future<void> joinGuild(String guildId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = _db.collection("guilds").doc(guildId);

    final doc = await ref.get();

    if (!doc.exists) {
      // Create the guild document first
      await ref.set({
        "name": guildId,
        "members": [uid],
        "level": 1,
        "xp": 0,
        "totalSteps": 0,
      });
      return;
    }

    // If guild exists, update normally
    await ref.update({
      "members": FieldValue.arrayUnion([uid])
    });
  }

  /// Add XP/Steps to the guild
  Future<void> addGuildSteps(String guildId, int steps) async {
    final ref = _db.collection("guilds").doc(guildId);

    final doc = await ref.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    int xp = data["xp"] ?? 0;
    int level = data["level"] ?? 1;
    int totalSteps = data["totalSteps"] ?? 0;

    xp += steps ~/ 20; // example guild XP formula
    totalSteps += steps;

    // Level up
    int needed = 200 * level;
    while (xp >= needed) {
      xp -= needed;
      level++;
      needed = 200 * level;
    }

    await ref.update({
      "xp": xp,
      "level": level,
      "totalSteps": totalSteps,
    });
  }
}
