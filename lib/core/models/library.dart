/// Article model
class Article {
  final String id;
  final String title;
  final String? titleEn;
  final String? excerpt;
  final String? imageUrl;
  final String? author;
  final String category;
  final int likes;
  final int views;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    this.titleEn,
    this.excerpt,
    this.imageUrl,
    this.author,
    required this.category,
    required this.likes,
    required this.views,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      titleEn: json['titleEn'] as String?,
      excerpt: json['excerpt'] as String?,
      imageUrl: json['imageUrl'] as String?,
      author: json['author'] as String?,
      category: json['category'] as String? ?? 'islamic-knowledge',
      likes: json['likes'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}

/// Lesson model
class Lesson {
  final String id;
  final String title;
  final String? titleEn;
  final String? description;
  final String? videoUrl;
  final String? thumbnailUrl;
  final int duration;
  final String category;
  final String level;
  final int xpReward;
  final DateTime createdAt;

  Lesson({
    required this.id,
    required this.title,
    this.titleEn,
    this.description,
    this.videoUrl,
    this.thumbnailUrl,
    required this.duration,
    required this.category,
    required this.level,
    required this.xpReward,
    required this.createdAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      titleEn: json['titleEn'] as String?,
      description: json['description'] as String?,
      videoUrl: json['videoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      duration: json['duration'] as int? ?? 0,
      category: json['category'] as String? ?? 'quran',
      level: json['level'] as String? ?? 'BEGINNER',
      xpReward: json['xpReward'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Get formatted duration (mm:ss or hh:mm:ss)
  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Podcast model
class Podcast {
  final String id;
  final String title;
  final String? titleEn;
  final String? description;
  final String? audioUrl;
  final String? thumbnailUrl;
  final int duration;
  final String category;
  final String? speaker;
  final int xpReward;
  final DateTime createdAt;

  Podcast({
    required this.id,
    required this.title,
    this.titleEn,
    this.description,
    this.audioUrl,
    this.thumbnailUrl,
    required this.duration,
    required this.category,
    this.speaker,
    required this.xpReward,
    required this.createdAt,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'] as String,
      title: json['title'] as String,
      titleEn: json['titleEn'] as String?,
      description: json['description'] as String?,
      audioUrl: json['audioUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      duration: json['duration'] as int? ?? 0,
      category: json['category'] as String? ?? 'education',
      speaker: json['speaker'] as String?,
      xpReward: json['xpReward'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Get formatted duration (mm:ss or hh:mm:ss)
  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// EBook model
class EBook {
  final String id;
  final String title;
  final String? titleEn;
  final String? description;
  final String fileUrl;
  final String? coverUrl;
  final String? author;
  final int? pages;
  final String category;
  final int xpReward;
  final DateTime createdAt;

  EBook({
    required this.id,
    required this.title,
    this.titleEn,
    this.description,
    required this.fileUrl,
    this.coverUrl,
    this.author,
    this.pages,
    required this.category,
    required this.xpReward,
    required this.createdAt,
  });

  factory EBook.fromJson(Map<String, dynamic> json) {
    return EBook(
      id: json['id'] as String,
      title: json['title'] as String,
      titleEn: json['titleEn'] as String?,
      description: json['description'] as String?,
      fileUrl: json['fileUrl'] as String,
      coverUrl: json['coverUrl'] as String?,
      author: json['author'] as String?,
      pages: json['pages'] as int?,
      category: json['category'] as String? ?? 'islamic',
      xpReward: json['xpReward'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}

/// Paginated response helper
class PaginatedResponse<T> {
  final List<T> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginatedResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}
