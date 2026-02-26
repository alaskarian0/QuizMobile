import 'stage.dart';

/// Category model
class Category {
  final String id;
  final String name;
  final String slug;
  final String? icon;
  final String? color;
  final String? description;
  final String? imageUrl;
  final int questionCount;
  final bool showOnHome;
  final int showOnHomeOrder;
  final bool showAsChallenge;
  final List<Stage> stages;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.color,
    this.description,
    this.imageUrl,
    this.questionCount = 0,
    this.showOnHome = false,
    this.showOnHomeOrder = 0,
    this.showAsChallenge = false,
    this.stages = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      questionCount: json['questionCount'] as int? ??
                    (json['questions'] as List?)?.length ?? 0,
      showOnHome: json['showOnHome'] as bool? ?? false,
      showOnHomeOrder: json['showOnHomeOrder'] as int? ?? 0,
      showAsChallenge: json['showAsChallenge'] as bool? ?? false,
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
      'imageUrl': imageUrl,
      'questionCount': questionCount,
      'showOnHome': showOnHome,
      'showOnHomeOrder': showOnHomeOrder,
      'showAsChallenge': showAsChallenge,
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
    String? imageUrl,
    int? questionCount,
    bool? showOnHome,
    int? showOnHomeOrder,
    bool? showAsChallenge,
    List<Stage>? stages,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      questionCount: questionCount ?? this.questionCount,
      showOnHome: showOnHome ?? this.showOnHome,
      showOnHomeOrder: showOnHomeOrder ?? this.showOnHomeOrder,
      showAsChallenge: showAsChallenge ?? this.showAsChallenge,
      stages: stages ?? this.stages,
    );
  }
}
