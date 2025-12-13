import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuildService {
  GuildService._();
  static final GuildService instance = GuildService._();

  final _db = FirebaseFirestore.instance;

  /// Create a new guild
  Future<void> createGuild({
    required String guildId,
    required String displayName,
    required dynamic color,
  }) async {
    final ref = _db.collection("guilds").doc(guildId);

    final exists = await ref.get();
    if (exists.exists) {
      throw Exception("Guild name already taken.");
    }

    await ref.set({
      "name": displayName,
      "color": color.toString(),
      "weeklySteps": 0,
      "members": [],
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Add user to guild
  Future<void> joinGuild(String guildId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _db.collection("guilds").doc(guildId).update({
      "members": FieldValue.arrayUnion([uid]),
    });
  }

  /// Update guild steps (called when user gains steps)
  Future<void> addGuildSteps(String guildId, int amount) async {
    await _db.collection("guilds").doc(guildId).update({
      "weeklySteps": FieldValue.increment(amount),
    });
  }

  /// Leaderboard ranking
  Future<List<Map<String, dynamic>>> getGuildLeaderboard() async {
    final snapshot = await _db
        .collection("guilds")
        .orderBy("weeklySteps", descending: true)
        .get();

    return snapshot.docs.map((d) {
      return {
        "id": d.id,
        "name": d["name"],
        "steps": d["weeklySteps"],
      };
    }).toList();
  }
}
