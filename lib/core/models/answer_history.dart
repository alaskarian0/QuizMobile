import 'question.dart';
import 'category.dart';

/// Model for tracking user's answer history
class AnswerHistory {
  final String id;
  final String userId;
  final String questionId;
  final int answer;
  final bool isCorrect;
  final int xpEarned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Question? question;

  AnswerHistory({
    required this.id,
    required this.userId,
    required this.questionId,
    required this.answer,
    required this.isCorrect,
    this.xpEarned = 0,
    required this.createdAt,
    required this.updatedAt,
    this.question,
  });

  factory AnswerHistory.fromJson(Map<String, dynamic> json) {
    return AnswerHistory(
      id: json['id'] as String,
      userId: json['userId'] as String,
      questionId: json['questionId'] as String,
      answer: json['answer'] as int,
      isCorrect: json['isCorrect'] as bool,
      xpEarned: json['xpEarned'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      question: json['question'] != null
          ? Question.fromJson(json['question'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'questionId': questionId,
      'answer': answer,
      'isCorrect': isCorrect,
      'xpEarned': xpEarned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'question': question?.toJson(),
    };
  }
}

/// User answer statistics
class AnswerStats {
  final int total;
  final int correct;
  final int incorrect;
  final double accuracy;
  final int totalXP;

  AnswerStats({
    required this.total,
    required this.correct,
    required this.incorrect,
    required this.accuracy,
    required this.totalXP,
  });

  factory AnswerStats.fromJson(Map<String, dynamic> json) {
    return AnswerStats(
      total: json['total'] as int,
      correct: json['correct'] as int,
      incorrect: json['incorrect'] as int,
      accuracy: (json['accuracy'] as num).toDouble(),
      totalXP: json['totalXP'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'correct': correct,
      'incorrect': incorrect,
      'accuracy': accuracy,
      'totalXP': totalXP,
    };
  }
}

/// Question statistics for a specific question
class QuestionStats {
  final String questionId;
  final int attempts;
  final double correctRate;

  QuestionStats({
    required this.questionId,
    required this.attempts,
    required this.correctRate,
  });

  factory QuestionStats.fromJson(Map<String, dynamic> json) {
    return QuestionStats(
      questionId: json['questionId'] as String,
      attempts: json['attempts'] as int,
      correctRate: (json['correctRate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'attempts': attempts,
      'correctRate': correctRate,
    };
  }
}

/// DTO for recording an answer
class RecordAnswerDto {
  final String questionId;
  final int answer;

  RecordAnswerDto({
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answer': answer,
    };
  }
}
