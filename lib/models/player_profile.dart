import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerProfile {
  final String uid;

  final String? displayName;
  final String? heroClass;
  final int? colorIndex;

  final String? guildId;

  // Progression
  final int level;
  final int xp;
  final int xpNeededForNextLevel;

  final int todaySteps;
  final int totalSteps;
  final int stepsUntilNextEncounter;

  // Daily Quest
  final int dailyQuestGoal;
  final int dailyQuestProgress;
  final bool dailyQuestCompleted;

  // Cosmetics
  final String hairstyle;
  final int hairColorValue;     // ← stored numeric color
  final String hatType;
  final String facialHair;
  final int cosmeticsClaimed;   // ← number of rewards claimed

  PlayerProfile({
    required this.uid,
    required this.displayName,
    required this.heroClass,
    required this.colorIndex,
    required this.guildId,
    required this.level,
    required this.xp,
    required this.xpNeededForNextLevel,
    required this.todaySteps,
    required this.totalSteps,
    required this.stepsUntilNextEncounter,
    required this.dailyQuestGoal,
    required this.dailyQuestProgress,
    required this.dailyQuestCompleted,
    required this.hairstyle,
    required this.hairColorValue,
    required this.hatType,
    required this.facialHair,
    required this.cosmeticsClaimed,
  });

  // -----------------------------
  // COMPATIBILITY HELPERS
  // -----------------------------

  /// Some older parts of your code expect hairColorIndex instead of value.
  int get hairColorIndex => hairColorValue;

  /// Determines if user already created a character
  bool hasCharacterData() {
    return displayName != null &&
        displayName!.isNotEmpty &&
        heroClass != null &&
        colorIndex != null;
  }

  /// Returns true if a cosmetic reward is waiting to be claimed
  bool get pendingReward {
    if (level < 5) return false;
    return (level ~/ 5) > cosmeticsClaimed;
  }

  // -----------------------------
  // From Firestore
  // -----------------------------
  factory PlayerProfile.fromDoc(String uid, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PlayerProfile(
      uid: uid,
      displayName: data["displayName"],
      heroClass: data["heroClass"],
      colorIndex: data["colorIndex"],
      guildId: data["guildId"],
      level: data["level"] ?? 1,
      xp: data["xp"] ?? 0,
      xpNeededForNextLevel: data["xpNeededForNextLevel"] ?? 100,
      todaySteps: data["todaySteps"] ?? 0,
      totalSteps: data["totalSteps"] ?? 0,
      stepsUntilNextEncounter: data["stepsUntilNextEncounter"] ?? 1000,
      dailyQuestGoal: data["dailyQuestGoal"] ?? 2500,
      dailyQuestProgress: data["dailyQuestProgress"] ?? 0,
      dailyQuestCompleted: data["dailyQuestCompleted"] ?? false,

      // Cosmetics
      hairstyle: data["hairstyle"] ?? "none",
      hairColorValue: data["hairColorValue"] ?? 0,
      hatType: data["hatType"] ?? "none",
      facialHair: data["facialHair"] ?? "none",
      cosmeticsClaimed: data["cosmeticsClaimed"] ?? 0,
    );
  }
}
