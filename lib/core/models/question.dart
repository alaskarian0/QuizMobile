import 'dart:convert';

/// Question difficulty enum
enum QuestionDifficulty {
  easy('EASY', 'سهل'),
  medium('MEDIUM', 'متوسط'),
  hard('HARD', 'صعب');

  final String value;
  final String labelAr;

  const QuestionDifficulty(this.value, this.labelAr);

  static QuestionDifficulty fromString(String value) {
    return QuestionDifficulty.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => QuestionDifficulty.medium,
    );
  }
}

/// Question model
class Question {
  final String id;
  final String text;
  final String? imageUrl;
  final QuestionDifficulty difficulty;
  final List<String> options;
  final int correctOption;
  final String? explanation;
  final String categoryId;
  final String? stageId;
  final String? levelId;
  final int? xpReward;
  final int? timeLimit;
  final DateTime createdAt;

  Question({
    required this.id,
    required this.text,
    this.imageUrl,
    required this.difficulty,
    required this.options,
    required this.correctOption,
    this.explanation,
    required this.categoryId,
    this.stageId,
    this.levelId,
    this.xpReward,
    this.timeLimit,
    required this.createdAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // Handle options as JSON string or array
    List<String> parseOptions(dynamic optionsData) {
      if (optionsData is String) {
        return List<String>.from(
          // Parse JSON string if needed
          (optionsData.startsWith('[') ? jsonDecode(optionsData) : [optionsData]) as List,
        );
      } else if (optionsData is List) {
        return optionsData.cast<String>();
      }
      return [];
    }

    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
      difficulty: QuestionDifficulty.fromString(
        json['difficulty'] as String? ?? 'MEDIUM',
      ),
      options: parseOptions(json['options']),
      correctOption: json['correctOption'] as int? ??
                    json['correctAnswer'] as int? ?? 0,
      explanation: json['explanation'] as String?,
      categoryId: json['categoryId'] as String,
      stageId: json['stageId'] as String?,
      levelId: json['levelId'] as String?,
      xpReward: json['xpReward'] as int?,
      timeLimit: json['timeLimit'] as int?,
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'difficulty': difficulty.value,
      'options': options,
      'correctOption': correctOption,
      'explanation': explanation,
      'categoryId': categoryId,
      'stageId': stageId,
      'levelId': levelId,
      'xpReward': xpReward,
      'timeLimit': timeLimit,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Daily question model
class DailyQuestion {
  final String id;
  final String text;
  final QuestionDifficulty difficulty;
  final List<String> options;
  final int correctOption;
  final int xpReward;

  DailyQuestion({
    required this.id,
    required this.text,
    required this.difficulty,
    required this.options,
    required this.correctOption,
    required this.xpReward,
  });

  factory DailyQuestion.fromJson(Map<String, dynamic> json) {
    // Handle options as JSON string or array
    List<String> parseOptions(dynamic optionsData) {
      if (optionsData is String) {
        return List<String>.from(
          (optionsData.startsWith('[') ? jsonDecode(optionsData) : [optionsData]) as List,
        );
      } else if (optionsData is List) {
        return optionsData.cast<String>();
      }
      return [];
    }

    return DailyQuestion(
      id: json['id'] as String,
      text: json['text'] as String,
      difficulty: QuestionDifficulty.fromString(
        json['difficulty'] as String? ?? 'MEDIUM',
      ),
      options: parseOptions(json['options']),
      correctOption: json['correctOption'] as int? ??
                    json['correctAnswer'] as int? ?? 0,
      xpReward: json['xpReward'] as int? ?? 10,
    );
  }
}

/// Question stats model
class QuestionStats {
  final int totalQuestions;
  final int easyQuestions;
  final int mediumQuestions;
  final int hardQuestions;
  final int categoriesCount;

  QuestionStats({
    required this.totalQuestions,
    required this.easyQuestions,
    required this.mediumQuestions,
    required this.hardQuestions,
    required this.categoriesCount,
  });

  factory QuestionStats.fromJson(Map<String, dynamic> json) {
    return QuestionStats(
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      easyQuestions: json['easyQuestions'] as int? ?? 0,
      mediumQuestions: json['mediumQuestions'] as int? ?? 0,
      hardQuestions: json['hardQuestions'] as int? ?? 0,
      categoriesCount: json['categoriesCount'] as int? ?? 0,
    );
  }
}
