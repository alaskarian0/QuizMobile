import 'dart:convert';
import 'question.dart';

/// Quiz difficulty enum
enum QuizDifficulty {
  easy('EASY', 'سهل'),
  medium('MEDIUM', 'متوسط'),
  hard('HARD', 'صعب');

  final String value;
  final String labelAr;

  const QuizDifficulty(this.value, this.labelAr);

  static QuizDifficulty fromString(String value) {
    return QuizDifficulty.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => QuizDifficulty.medium,
    );
  }
}

/// Quiz model
class Quiz {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String categoryId;
  final CategorySimple? category;
  final int timeLimit;
  final int xp;
  final QuizDifficulty difficulty;
  final List<QuizQuestion> questions;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.categoryId,
    this.category,
    required this.timeLimit,
    required this.xp,
    required this.difficulty,
    required this.questions,
    required this.createdAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      categoryId: json['categoryId'] as String,
      category: json['category'] != null
          ? CategorySimple.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      timeLimit: (json['timeLimit'] as num?)?.toInt() ?? 300,
      xp: (json['xp'] as num?)?.toInt() ?? 100,
      difficulty: QuizDifficulty.fromString(json['difficulty'] as String? ?? 'MEDIUM'),
      questions: (json['questions'] as List?)
              ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

/// Simple category for quiz
class CategorySimple {
  final String name;
  final String? icon;

  CategorySimple({
    required this.name,
    this.icon,
  });

  factory CategorySimple.fromJson(Map<String, dynamic> json) {
    return CategorySimple(
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }
}

/// Quiz question (junction table)
class QuizQuestion {
  final String id;
  final String questionId;
  final QuizQuestionSimple? question;
  final int order;

  QuizQuestion({
    required this.id,
    required this.questionId,
    this.question,
    required this.order,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      question: json['question'] != null
          ? QuizQuestionSimple.fromJson(json['question'] as Map<String, dynamic>)
          : null,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Simple question for quiz
class QuizQuestionSimple {
  final String id;
  final String text;
  final List<String> options;

  QuizQuestionSimple({
    required this.id,
    required this.text,
    required this.options,
  });

  factory QuizQuestionSimple.fromJson(Map<String, dynamic> json) {
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

    return QuizQuestionSimple(
      id: json['id'] as String,
      text: json['text'] as String,
      options: parseOptions(json['options']),
    );
  }
}

/// Quiz session (when user starts a quiz)
class QuizSession {
  final String sessionId;
  final String quizId;
  final DateTime startedAt;
  final List<Question> questions;

  QuizSession({
    required this.sessionId,
    required this.quizId,
    required this.startedAt,
    required this.questions,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      sessionId: json['sessionId'] as String,
      quizId: json['quizId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      questions: (json['questions'] as List?)
              ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Quiz submission result
class QuizResult {
  final int score;
  final int total;
  final int correctAnswers;
  final int xpEarned;
  final double accuracy;
  final DateTime completedAt;
  final List<QuizAnswerResult> results;

  QuizResult({
    required this.score,
    required this.total,
    required this.correctAnswers,
    required this.xpEarned,
    required this.accuracy,
    required this.completedAt,
    required this.results,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    final score = (json['score'] as num?)?.toInt() ?? 0;
    final total = (json['totalQuestions'] as num?)?.toInt() ?? 
                 (json['total'] as num?)?.toInt() ?? 0;
    
    return QuizResult(
      score: score,
      total: total,
      correctAnswers: (json['correctAnswers'] as num?)?.toInt() ?? 0,
      xpEarned: (json['xpEarned'] as num?)?.toInt() ?? 0,
      accuracy: total > 0 ? (score / total) * 100 : 0.0,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : DateTime.now(),
      results: (json['answers'] as List?)
              ?.map((e) => QuizAnswerResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          (json['results'] as List?)
              ?.map((e) => QuizAnswerResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Get star rating (1-3 stars)
  int get stars {
    if (accuracy >= 90) return 3;
    if (accuracy >= 70) return 2;
    if (accuracy >= 50) return 1;
    return 0;
  }
}

/// Answer result for a single question
class QuizAnswerResult {
  final String questionId;
  final bool correct;
  final int correctAnswer;
  final int userAnswer;
  final String? explanation;

  QuizAnswerResult({
    required this.questionId,
    required this.correct,
    required this.correctAnswer,
    required this.userAnswer,
    this.explanation,
  });

  factory QuizAnswerResult.fromJson(Map<String, dynamic> json) {
    return QuizAnswerResult(
      questionId: json['questionId'] as String? ?? '',
      correct: json['isCorrect'] as bool? ?? json['correct'] as bool? ?? false,
      correctAnswer: (json['correctOption'] as num?)?.toInt() ?? 
                    (json['correctAnswer'] as num?)?.toInt() ?? 0,
      userAnswer: (json['selectedOption'] as num?)?.toInt() ?? 
                  (json['userAnswer'] as num?)?.toInt() ?? 0,
      explanation: json['explanation'] as String?,
    );
  }
}

/// Quiz history item
class QuizHistoryItem {
  final String id;
  final int score;
  final int total;
  final int xpEarned;
  final DateTime completedAt;
  final QuizSimpleInfo quiz;

  QuizHistoryItem({
    required this.id,
    required this.score,
    required this.total,
    required this.xpEarned,
    required this.completedAt,
    required this.quiz,
  });

  factory QuizHistoryItem.fromJson(Map<String, dynamic> json) {
    return QuizHistoryItem(
      id: json['id'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      xpEarned: (json['xpEarned'] as num?)?.toInt() ?? 0,
      completedAt: DateTime.parse(json['completedAt'] as String? ?? DateTime.now().toIso8601String()),
      quiz: QuizSimpleInfo.fromJson(json['quiz'] as Map<String, dynamic>? ?? {}),
    );
  }
}

/// Simple quiz info for history
class QuizSimpleInfo {
  final String title;

  QuizSimpleInfo({
    required this.title,
  });

  factory QuizSimpleInfo.fromJson(Map<String, dynamic> json) {
    return QuizSimpleInfo(
      title: json['title'] as String? ?? '',
    );
  }
}
