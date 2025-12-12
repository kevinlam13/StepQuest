class GuildModel {
  final String name;
  final int weeklySteps;
  final List<String> members;

  GuildModel({
    required this.name,
    required this.weeklySteps,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "weeklySteps": weeklySteps,
      "members": members,
    };
  }

  factory GuildModel.fromMap(Map<String, dynamic> map) {
    return GuildModel(
      name: map["name"],
      weeklySteps: map["weeklySteps"] ?? 0,
      members: List<String>.from(map["members"] ?? []),
    );
  }
}
