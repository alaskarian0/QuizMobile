/// Stage model representing a part of a category contest
class Stage {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final int order;
  final List<Level> levels;

  Stage({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.order = 0,
    this.levels = const [],
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      order: json['order'] as int? ?? 0,
      levels: (json['levels'] as List?)
              ?.map((e) => Level.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'order': order,
      'levels': levels.map((e) => e.toJson()).toList(),
    };
  }
}

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
      id: json['id'] as String,
      name: json['name'] as String,
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
