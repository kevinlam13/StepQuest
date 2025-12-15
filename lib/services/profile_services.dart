import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/player_profile.dart';
import 'guild_service.dart';

class ProfileService {
  ProfileService._();
  static final ProfileService instance = ProfileService._();

  final _db = FirebaseFirestore.instance;

  // -------------------------------------------------
  // Fetch Profile
  // -------------------------------------------------
  Future<PlayerProfile?> getProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    if (!doc.exists) return null;
    return PlayerProfile.fromDoc(uid, doc);
  }

  // -------------------------------------------------
  // Create Character (for new users)
  // -------------------------------------------------
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

      // Progression
      "level": 1,
      "xp": 0,
      "xpNeededForNextLevel": 100,
      "todaySteps": 0,
      "totalSteps": 0,
      "stepsUntilNextEncounter": 1000,

      // Daily Quest
      "dailyQuestGoal": 2500,
      "dailyQuestProgress": 0,
      "dailyQuestCompleted": false,

      // Cosmetics (defaults)
      "hairstyle": "none",
      "hairColorValue": 0,
      "hatType": "none",
      "facialHair": "none",
      "cosmeticsClaimed": 0,
    }, SetOptions(merge: true));
  }

  // -------------------------------------------------
  // Assign guild
  // -------------------------------------------------
  Future<void> assignGuild(String guildId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _db.collection("users").doc(uid).update({
      "guildId": guildId,
    });

    await GuildService.instance.joinGuild(guildId);
  }

  // -------------------------------------------------
  // Add Steps → XP → Leveling
  // -------------------------------------------------
  Future<PlayerProfile> addSteps({required int amount}) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = _db.collection("users").doc(uid);

    final doc = await ref.get();
    final p = PlayerProfile.fromDoc(uid, doc);

    int today = p.todaySteps + amount;
    int total = p.totalSteps + amount;
    int encounter = p.stepsUntilNextEncounter - amount;

    int xp = p.xp + (amount ~/ 10);
    int level = p.level;
    int needed = p.xpNeededForNextLevel;

    while (xp >= needed) {
      xp -= needed;
      level++;
      needed = (100 * (level * 1.5)).toInt();
    }

    int dq = p.dailyQuestProgress + amount;
    bool dqDone = dq >= p.dailyQuestGoal;

    if (encounter < 0) encounter = 0;

    await ref.update({
      "todaySteps": today,
      "totalSteps": total,
      "stepsUntilNextEncounter": encounter,
      "xp": xp,
      "level": level,
      "xpNeededForNextLevel": needed,
      "dailyQuestProgress": dq,
      "dailyQuestCompleted": dqDone,
    });

    // Guild updates
    if (p.guildId != null) {
      await GuildService.instance.addGuildSteps(p.guildId!, amount);
    }

    final updated = await ref.get();
    return PlayerProfile.fromDoc(uid, updated);
  }

  // -------------------------------------------------
  // Complete Encounter
  // -------------------------------------------------
  Future<PlayerProfile> completeEncounter() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = _db.collection("users").doc(uid);

    final doc = await ref.get();
    final p = PlayerProfile.fromDoc(uid, doc);

    int xp = p.xp + 120;
    int level = p.level;
    int needed = p.xpNeededForNextLevel;

    while (xp >= needed) {
      xp -= needed;
      level++;
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

  // -------------------------------------------------
  // Claim Daily Reward
  // -------------------------------------------------
  Future<PlayerProfile> claimDailyReward() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = _db.collection("users").doc(uid);

    final doc = await ref.get();
    final data = doc.data() ?? {};

    // Prevent claiming twice
    if (data["dailyRewardClaimed"] == true) {
      return PlayerProfile.fromDoc(uid, doc);
    }

    await ref.update({
      "xp": FieldValue.increment(200),
      "dailyQuestCompleted": false,
      "dailyQuestProgress": 0,
      "dailyRewardClaimed": true,     // ⭐ mark reward as claimed
    });

    final updated = await ref.get();
    return PlayerProfile.fromDoc(uid, updated);
  }
  // -------------------------------------------------
  // Save Cosmetic Selection
  // -------------------------------------------------
  Future<void> saveCosmetics({
    String? hairstyle,
    int? hairColorValue,
    String? hatType,
    String? facialHair,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final data = <String, dynamic>{};

    if (hairstyle != null) data["hairstyle"] = hairstyle;
    if (hairColorValue != null) data["hairColorValue"] = hairColorValue;
    if (hatType != null) data["hatType"] = hatType;
    if (facialHair != null) data["facialHair"] = facialHair;

    data["cosmeticsClaimed"] = FieldValue.increment(1);

    await _db.collection("users").doc(uid).update(data);
  }
}
Future<void> assignGuild(String guildId) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance.collection("users").doc(uid).update({
    "guildId": guildId,
  });
}