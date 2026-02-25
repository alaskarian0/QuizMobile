/// User model
class User {
  final String id;
  final String email;
  final String username;
  final String name;
  final String? avatar;
  final String role;
  final String status;
  final int xp;
  final int level;
  final int streak;
  final int questionsAnswered;
  final double accuracy;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    this.avatar,
    required this.role,
    required this.status,
    required this.xp,
    required this.level,
    required this.streak,
    required this.questionsAnswered,
    required this.accuracy,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'USER',
      status: json['status'] as String? ?? 'ACTIVE',
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      questionsAnswered: (json['questionsAnswered'] as num?)?.toInt() ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'avatar': avatar,
      'role': role,
      'status': status,
      'xp': xp,
      'level': level,
      'streak': streak,
      'questionsAnswered': questionsAnswered,
      'accuracy': accuracy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? name,
    String? avatar,
    String? role,
    String? status,
    int? xp,
    int? level,
    int? streak,
    int? questionsAnswered,
    double? accuracy,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      status: status ?? this.status,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      accuracy: accuracy ?? this.accuracy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if user is admin
  bool get isAdmin => role == 'ADMIN';

  /// Check if user is active
  bool get isActive => status == 'ACTIVE';

  /// Get XP required for next level
  int get xpForNextLevel => level * 500;

  /// Get progress towards next level (0.0 to 1.0)
  double get levelProgress {
    final previousLevelXp = (level - 1) * 500;
    final nextLevelXp = level * 500;
    final currentLevelProgress = xp - previousLevelXp;
    final totalLevelXp = nextLevelXp - previousLevelXp;
    return (currentLevelProgress / totalLevelXp).clamp(0.0, 1.0);
  }
}

/// Login request model
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

/// Login response model
class LoginResponse {
  final String accessToken;
  final String? refreshToken;
  final User user;

  LoginResponse({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refreshToken'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

/// User stats model
class UserStats {
  final int totalQuestions;
  final int correctAnswers;
  final double accuracy;
  final int totalXP;
  final int level;
  final int streak;
  final int quizzesCompleted;
  final List<Badge> badges;
  final int rank;

  UserStats({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracy,
    required this.totalXP,
    required this.level,
    required this.streak,
    required this.quizzesCompleted,
    required this.badges,
    required this.rank,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      totalXP: json['totalXP'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      streak: json['streak'] as int? ?? 0,
      quizzesCompleted: json['quizzesCompleted'] as int? ?? 0,
      badges: (json['badges'] as List?)
              ?.map((e) => Badge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rank: json['rank'] as int? ?? 0,
    );
  }
}

/// Badge model
class Badge {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final DateTime? earnedAt;

  Badge({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.earnedAt,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      earnedAt: json['earnedAt'] != null
          ? DateTime.parse(json['earnedAt'] as String)
          : null,
    );
  }
}

/// Leaderboard entry
class LeaderboardEntry {
  final int rank;
  final String id;
  final String username;
  final String name;
  final String? avatar;
  final int xp;
  final int level;
  final double accuracy;

  LeaderboardEntry({
    required this.rank,
    required this.id,
    required this.username,
    required this.name,
    this.avatar,
    required this.xp,
    required this.level,
    required this.accuracy,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
