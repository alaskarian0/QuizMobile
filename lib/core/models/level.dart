/// Level model representing a specific quiz within a stage
class Level {
  final String id;
  final String name;
  final String? description;
  final int order;
  final int xpReward;
  final String difficulty;

  Level({
    required this.id,
    required this.name,
    this.description,
    this.order = 0,
    this.xpReward = 100,
    this.difficulty = 'MEDIUM',
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'مستوى جديد',
      description: json['description'] as String?,
      order: json['order'] as int? ?? 0,
      xpReward: json['xpReward'] as int? ?? 100,
      difficulty: json['difficulty'] as String? ?? 'MEDIUM',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'order': order,
      'xpReward': xpReward,
      'difficulty': difficulty,
    };
  }
}
