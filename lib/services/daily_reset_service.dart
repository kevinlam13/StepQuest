import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_quest.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailyQuestService {
  static final DailyQuestService instance = DailyQuestService._();
  DailyQuestService._();

  final _db = FirebaseFirestore.instance;

  Future<void> generateDailyQuests() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await _db.collection("dailyQuests").doc(uid).get();

    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (doc.exists && doc.data()!["date"] == today) return;

    await _db.collection("dailyQuests").doc(uid).set({
      "date": today,
      "quests": [
        {
          "id": "q1",
          "description": "Walk 1,000 steps",
          "requiredSteps": 1000,
          "completed": false,
        },
        {
          "id": "q2",
          "description": "Gain 200 XP",
          "requiredSteps": 200,
          "completed": false,
        },
        {
          "id": "q3",
          "description": "Complete 1 encounter",
          "requiredSteps": 1,
          "completed": false,
        }
      ]
    });
  }

  Future<List<DailyQuest>> getQuests() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await _db.collection("dailyQuests").doc(uid).get();
    if (!doc.exists) return [];

    final data = doc.data()!;
    final list = data["quests"] as List;

    return list
        .map((q) => DailyQuest.fromMap(q as Map<String, dynamic>))
        .toList();
  }

  Future<void> completeQuest(String questId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await _db.collection("dailyQuests").doc(uid).get();
    final List quests = doc["quests"];

    final updated = quests.map((q) {
      if (q["id"] == questId) {
        q["completed"] = true;
      }
      return q;
    }).toList();

    await _db.collection("dailyQuests").doc(uid).update({
      "quests": updated,
    });
  }
}
