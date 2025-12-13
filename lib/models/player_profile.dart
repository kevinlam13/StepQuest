import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerProfile {
  final String uid;

  // Character
  final String? displayName;
  final String? heroClass;
  final int? colorIndex;

  // Guild
  final String? guildId;

  // Progression
  final int level;
  final int xp;
  final int xpNeededForNextLevel;

  // Steps
  final int todaySteps;
  final int totalSteps;

  // Encounter cooldown
  final int stepsUntilNextEncounter;

  // Daily Quest
  final int dailyQuestGoal;
  final int dailyQuestProgress;
  final bool dailyQuestCompleted;

  PlayerProfile({
    required this.uid,
    this.displayName,
    this.heroClass,
    this.colorIndex,
    this.guildId,
    required this.level,
    required this.xp,
    required this.xpNeededForNextLevel,
    required this.todaySteps,
    required this.totalSteps,
    required this.stepsUntilNextEncounter,
    required this.dailyQuestGoal,
    required this.dailyQuestProgress,
    required this.dailyQuestCompleted,
  });

  /// ✔ Used in RootRouter to check if character is created
  bool hasCharacterData() {
    return displayName != null &&
        heroClass != null &&
        colorIndex != null;
  }

  /// Create profile model from Firestore
  factory PlayerProfile.fromDoc(String uid, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PlayerProfile(
      uid: uid,
      displayName: data['displayName'],
      heroClass: data['heroClass'],
      colorIndex: data['colorIndex'],
      guildId: data['guildId'],

      level: data['level'] ?? 1,
      xp: data['xp'] ?? 0,
      xpNeededForNextLevel: data['xpNeededForNextLevel'] ?? 100,

      todaySteps: data['todaySteps'] ?? 0,
      totalSteps: data['totalSteps'] ?? 0,
      stepsUntilNextEncounter: data['stepsUntilNextEncounter'] ?? 1000,

      dailyQuestGoal: data['dailyQuestGoal'] ?? 2500,
      dailyQuestProgress: data['dailyQuestProgress'] ?? 0,
      dailyQuestCompleted: data['dailyQuestCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "displayName": displayName,
      "heroClass": heroClass,
      "colorIndex": colorIndex,
      "guildId": guildId,

      "level": level,
      "xp": xp,
      "xpNeededForNextLevel": xpNeededForNextLevel,

      "todaySteps": todaySteps,
      "totalSteps": totalSteps,
      "stepsUntilNextEncounter": stepsUntilNextEncounter,

      "dailyQuestGoal": dailyQuestGoal,
      "dailyQuestProgress": dailyQuestProgress,
      "dailyQuestCompleted": dailyQuestCompleted,
    };
  }
}
