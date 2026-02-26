import 'stage.dart';

/// Category model
class Category {
  final String id;
  final String name;
  final String slug;
  final String? icon;
  final String? color;
  final String? description;
  final int questionCount;
  final bool showOnHome;
  final List<Stage> stages;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.color,
    this.description,
    this.questionCount = 0,
    this.showOnHome = false,
    this.stages = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      description: json['description'] as String?,
      questionCount: json['questionCount'] as int? ??
                    (json['questions'] as List?)?.length ?? 0,
      showOnHome: json['showOnHome'] as bool? ?? false,
      stages: (json['stages'] as List?)
              ?.map((e) => Stage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon': icon,
      'color': color,
      'description': description,
      'questionCount': questionCount,
      'showOnHome': showOnHome,
      'stages': stages.map((e) => e.toJson()).toList(),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? slug,
    String? icon,
    String? color,
    String? description,
    int? questionCount,
    bool? showOnHome,
    List<Stage>? stages,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      questionCount: questionCount ?? this.questionCount,
      showOnHome: showOnHome ?? this.showOnHome,
      stages: stages ?? this.stages,
    );
  }
}
