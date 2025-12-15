import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuildService {
  GuildService._();
  static final GuildService instance = GuildService._();

  final _db = FirebaseFirestore.instance;

  /// ----------------------------------------------------
  /// CREATE A NEW CUSTOM GUILD
  /// ----------------------------------------------------
  Future<void> createGuild(String name) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final ref = _db.collection("guilds").doc(name);

    // Prevent overwriting another guild accidentally
    if ((await ref.get()).exists) {
      throw Exception("A guild with this name already exists.");
    }

    await ref.set({
      "name": name,
      "members": [uid],
      "level": 1,
      "xp": 0,
      "totalSteps": 0,
      "weeklySteps": 0,     // ⭐ for leaderboard
      "createdAt": DateTime.now(),
    });
  }

  /// ----------------------------------------------------
  /// JOIN EXISTING GUILD
  /// ----------------------------------------------------
  Future<void> joinGuild(String guildId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = _db.collection("guilds").doc(guildId);

    final doc = await ref.get();

    if (!doc.exists) {
      // Create a minimal guild if for some reason it doesn't exist
      await ref.set({
        "name": guildId,
        "members": [uid],
        "level": 1,
        "xp": 0,
        "totalSteps": 0,
        "weeklySteps": 0,
        "createdAt": DateTime.now(),
      });
      return;
    }

    await ref.update({
      "members": FieldValue.arrayUnion([uid])
    });
  }

  /// ----------------------------------------------------
  /// ADD STEPS TO GUILD
  /// Called whenever a member walks or uses +500 Steps
  /// ----------------------------------------------------
  Future<void> addGuildSteps(String guildId, int steps) async {
    final ref = _db.collection("guilds").doc(guildId);
    final doc = await ref.get();

    if (!doc.exists) return;

    final data = doc.data()!;
    int xp = data["xp"] ?? 0;
    int level = data["level"] ?? 1;
    int totalSteps = data["totalSteps"] ?? 0;
    int weeklySteps = data["weeklySteps"] ?? 0;

    xp += steps ~/ 20; // ⭐ XP formula for guilds
    totalSteps += steps;
    weeklySteps += steps;

    // Guild-leveling formula
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
      "weeklySteps": weeklySteps,
    });
  }

  /// ----------------------------------------------------
  /// GET LEADERBOARD DATA
  /// ----------------------------------------------------
  Future<List<Map<String, dynamic>>> getGuildLeaderboard() async {
    final snapshot = await _db
        .collection("guilds")
        .orderBy("weeklySteps", descending: true)
        .get();

    return snapshot.docs.map((d) {
      final data = d.data();
      data["id"] = d.id;
      return data;
    }).toList();
  }

  /// ----------------------------------------------------
  /// REWARD WINNING GUILD
  /// Give +2000 XP when hitting 50k weekly steps first
  /// ----------------------------------------------------
  Future<void> rewardTopGuild() async {
    final leaderboard = await getGuildLeaderboard();
    if (leaderboard.isEmpty) return;

    final top = leaderboard.first;
    if (top["weeklySteps"] < 50000) return; // Not reached the target yet

    final id = top["id"];
    final ref = _db.collection("guilds").doc(id);
    final doc = await ref.get();
    if (!doc.exists) return;

    int xp = doc.data()!["xp"] ?? 0;
    int level = doc.data()!["level"] ?? 1;

    xp += 2000; // ⭐ Reward boost

    // Handle level ups
    int needed = 200 * level;
    while (xp >= needed) {
      xp -= needed;
      level++;
      needed = 200 * level;
    }

    await ref.update({
      "xp": xp,
      "level": level,
    });
  }

  /// ----------------------------------------------------
  /// RESET WEEKLY STEPS
  /// (Call manually or with a Cloud Function every Monday)
  /// ----------------------------------------------------
  Future<void> resetWeeklySteps() async {
    final snapshot = await _db.collection("guilds").get();
    for (var doc in snapshot.docs) {
      await doc.reference.update({
        "weeklySteps": 0,
      });
    }
  }
}
