class DailyQuest {
  final String id;
  final String description;
  final int requiredSteps;
  final bool completed;

  DailyQuest({
    required this.id,
    required this.description,
    required this.requiredSteps,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "requiredSteps": requiredSteps,
      "completed": completed,
    };
  }

  factory DailyQuest.fromMap(Map<String, dynamic> map) {
    return DailyQuest(
      id: map["id"],
      description: map["description"],
      requiredSteps: map["requiredSteps"],
      completed: map["completed"] ?? false,
    );
  }
}
