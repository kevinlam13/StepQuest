class PlayerProfile {
  final String id; // same as Firebase Auth uid
  final String displayName;
  final String heroClass;
  final int level;
  final int xp;
  final int stepsLifetime;
  final int stepsToday;
  final int encountersCompleted;
  final int colorIndex; // used for card color theme

  PlayerProfile({
    required this.id,
    required this.displayName,
    required this.heroClass,
    required this.level,
    required this.xp,
    required this.stepsLifetime,
    required this.stepsToday,
    required this.encountersCompleted,
    required this.colorIndex,
  });

  factory PlayerProfile.initial(String uid) {
    return PlayerProfile(
      id: uid,
      displayName: 'New Adventurer',
      heroClass: 'Walker',
      level: 1,
      xp: 0,
      stepsLifetime: 0,
      stepsToday: 0,
      encountersCompleted: 0,
      colorIndex: 0,
    );
  }

  factory PlayerProfile.fromJson(Map<String, dynamic> json, String id) {
    return PlayerProfile(
      id: id,
      displayName: json['displayName'] as String? ?? 'Adventurer',
      heroClass: json['heroClass'] as String? ?? 'Walker',
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      stepsLifetime: (json['stepsLifetime'] as num?)?.toInt() ?? 0,
      stepsToday: (json['stepsToday'] as num?)?.toInt() ?? 0,
      encountersCompleted:
      (json['encountersCompleted'] as num?)?.toInt() ?? 0,
      colorIndex: (json['colorIndex'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'heroClass': heroClass,
      'level': level,
      'xp': xp,
      'stepsLifetime': stepsLifetime,
      'stepsToday': stepsToday,
      'encountersCompleted': encountersCompleted,
      'colorIndex': colorIndex,
    };
  }

  PlayerProfile copyWith({
    String? displayName,
    String? heroClass,
    int? level,
    int? xp,
    int? stepsLifetime,
    int? stepsToday,
    int? encountersCompleted,
    int? colorIndex,
  }) {
    return PlayerProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      heroClass: heroClass ?? this.heroClass,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      stepsLifetime: stepsLifetime ?? this.stepsLifetime,
      stepsToday: stepsToday ?? this.stepsToday,
      encountersCompleted: encountersCompleted ?? this.encountersCompleted,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}
