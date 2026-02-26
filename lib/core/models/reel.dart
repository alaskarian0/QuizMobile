import 'user.dart';

/// Reel model for user-generated content/stories
class Reel {
  final String id;
  final String userId;
  final String title;
  final String? mediaUrl;
  final String mediaType;
  final int xpReward;
  final bool isActive;
  final DateTime? expiresAt;
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;

  Reel({
    required this.id,
    required this.userId,
    required this.title,
    this.mediaUrl,
    this.mediaType = 'IMAGE',
    this.xpReward = 0,
    this.isActive = true,
    this.expiresAt,
    this.views = 0,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String? ?? 'IMAGE',
      xpReward: json['xpReward'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      views: json['views'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'xpReward': xpReward,
      'isActive': isActive,
      'expiresAt': expiresAt?.toIso8601String(),
      'views': views,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }

  /// Check if the reel is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if the reel is currently active (not expired and isActive flag is true)
  bool get isCurrentlyActive => isActive && !isExpired;
}

/// DTO for creating a new reel
class CreateReelDto {
  final String title;
  final String? mediaUrl;
  final String mediaType;
  final int xpReward;
  final bool isActive;
  final DateTime? expiresAt;

  CreateReelDto({
    required this.title,
    this.mediaUrl,
    this.mediaType = 'IMAGE',
    this.xpReward = 0,
    this.isActive = true,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'xpReward': xpReward,
      'isActive': isActive,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}

/// DTO for updating a reel
class UpdateReelDto {
  final String? title;
  final String? mediaUrl;
  final String? mediaType;
  final int? xpReward;
  final bool? isActive;
  final DateTime? expiresAt;

  UpdateReelDto({
    this.title,
    this.mediaUrl,
    this.mediaType,
    this.xpReward,
    this.isActive,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (title != null) json['title'] = title;
    if (mediaUrl != null) json['mediaUrl'] = mediaUrl;
    if (mediaType != null) json['mediaType'] = mediaType;
    if (xpReward != null) json['xpReward'] = xpReward;
    if (isActive != null) json['isActive'] = isActive;
    if (expiresAt != null) json['expiresAt'] = expiresAt!.toIso8601String();
    return json;
  }
}
