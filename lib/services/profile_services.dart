import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/player_profile.dart';
import 'guild_service.dart';

class ProfileService {
  ProfileService._();
  static final ProfileService instance = ProfileService._();

  final _db = FirebaseFirestore.instance;

  /// Fetch user profile
  Future<PlayerProfile?> getProfile(String uid) async {
    final ref = _db.collection("users").doc(uid);
    final doc = await ref.get();

    if (!doc.exists) return null;
    return PlayerProfile.fromDoc(uid, doc);
  }

  /// 🔥 Create character (name, class, color)
  Future<void> createCharacter({
    required String displayName,
    required String heroClass,
    required int colorIndex,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _db.collection("users").doc(uid).set({
      "displayName": displayName,
      "heroClass": heroClass,
      "colorIndex": colorIndex,
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
    }, SetOptions(merge: true));
  }

  /// 🔥 Assign a guild to the user
  Future<void> assignGuild(String guildId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _db.collection("users").doc(uid).update({
      "guildId": guildId,
    });

    // Add user to guild member list
    await GuildService.instance.joinGuild(guildId);
  }

  /// 🔥 Add steps + XP + level progression
  Future<PlayerProfile> addFakeSteps({required int amount}) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = _db.collection("users").doc(uid);

    final doc = await ref.get();
    final profile = PlayerProfile.fromDoc(uid, doc);

    int today = profile.todaySteps + amount;
    int total = profile.totalSteps + amount;
    int encounterSteps = profile.stepsUntilNextEncounter - amount;

    int xp = profile.xp + (amount ~/ 10); // 1 XP per 10 steps
    int level = profile.level;
    int needed = profile.xpNeededForNextLevel;

    // RPG exponential leveling
    while (xp >= needed) {
      xp -= needed;
      level += 1;
      needed = (100 * (level * 1.5)).toInt();
    }

    int dqProgress = profile.dailyQuestProgress + amount;
    bool dqCompleted = dqProgress >= profile.dailyQuestGoal;

    if (encounterSteps < 0) encounterSteps = 0;

    await ref.update({
      "todaySteps": today,
      "totalSteps": total,
      "stepsUntilNextEncounter": encounterSteps,

      "xp": xp,
      "level": level,
      "xpNeededForNextLevel": needed,

      "dailyQuestProgress": dqProgress,
      "dailyQuestCompleted": dqCompleted,
    });

    // Guild XP contribution
    if (profile.guildId != null) {
      await GuildService.instance.addGuildSteps(profile.guildId!, amount);
    }

    final updated = await ref.get();
    return PlayerProfile.fromDoc(uid, updated);
  }

  /// 🔥 Encounter reward
  Future<PlayerProfile> completeEncounter() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = _db.collection("users").doc(uid);

    final doc = await ref.get();
    final profile = PlayerProfile.fromDoc(uid, doc);

    int xp = profile.xp + 120;
    int level = profile.level;
    int needed = profile.xpNeededForNextLevel;

    while (xp >= needed) {
      xp -= needed;
      level += 1;
      needed = (100 * (level * 1.5)).toInt();
    }

    await ref.update({
      "xp": xp,
      "level": level,
      "xpNeededForNextLevel": needed,
      "stepsUntilNextEncounter": 1000,
    });

    final updated = await ref.get();
    return PlayerProfile.fromDoc(uid, updated);
  }
}
