/// Category model
class Category {
  final String id;
  final String name;
  final String slug;
  final String? icon;
  final String? color;
  final String? description;
  final int questionCount;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.color,
    this.description,
    this.questionCount = 0,
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
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      questionCount: questionCount ?? this.questionCount,
    );
  }
}
