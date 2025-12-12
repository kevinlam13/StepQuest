import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerProfile {
  final String uid;
  final String email;
  final int level;
  final int xp;
  final int weeklySteps;
  final String guild;

  // Avatar selections
  final int bodyColor;     // ARGB int
  final int eyeStyle;      // 0–3
  final int hairStyle;     // 0–3
  final int hatStyle;      // cosmetic reward

  PlayerProfile({
    required this.uid,
    required this.email,
    required this.level,
    required this.xp,
    required this.weeklySteps,
    required this.guild,
    required this.bodyColor,
    required this.eyeStyle,
    required this.hairStyle,
    required this.hatStyle,
  });

  factory PlayerProfile.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlayerProfile(
      uid: data['uid'],
      email: data['email'],
      level: data['level'] ?? 1,
      xp: data['xp'] ?? 0,
      weeklySteps: data['weeklySteps'] ?? 0,
      guild: data['guild'] ?? "None",
      bodyColor: data['bodyColor'] ?? 0xFFf0d9b5,
      eyeStyle: data['eyeStyle'] ?? 0,
      hairStyle: data['hairStyle'] ?? 0,
      hatStyle: data['hatStyle'] ?? -1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "level": level,
      "xp": xp,
      "weeklySteps": weeklySteps,
      "guild": guild,
      "bodyColor": bodyColor,
      "eyeStyle": eyeStyle,
      "hairStyle": hairStyle,
      "hatStyle": hatStyle,
    };
  }
}
