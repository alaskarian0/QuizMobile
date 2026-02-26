import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/answer_history.dart';

/// Service for Answer History API operations
class AnswerHistoryService {
  final ApiClient _apiClient;

  AnswerHistoryService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get my answer history
  Future<List<AnswerHistory>> getMyHistory() async {
    try {
      final response = await _apiClient.get('/answer-history');

      // Handle 401 Unauthorized - user not logged in
      if (response.statusCode == 401) {
        debugPrint('User not authenticated for answer history');
        return [];
      }

      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        final List<dynamic> historyJson = data['data'];
        return historyJson.map((json) => AnswerHistory.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching answer history: $e');
      // Return empty list on error instead of throwing
      return [];
    }
  }

  /// Get my answer statistics
  Future<AnswerStats> getMyStats() async {
    try {
      final response = await _apiClient.get('/answer-history/stats');

      // Handle 401 Unauthorized - user not logged in
      if (response.statusCode == 401) {
        debugPrint('User not authenticated for answer stats');
        return AnswerStats(
          total: 0,
          correct: 0,
          incorrect: 0,
          accuracy: 0.0,
          totalXP: 0,
        );
      }

      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        return AnswerStats.fromJson(data['data']);
      }

      // Return default stats on invalid response
      return AnswerStats(
        total: 0,
        correct: 0,
        incorrect: 0,
        accuracy: 0.0,
        totalXP: 0,
      );
    } catch (e) {
      debugPrint('Error fetching answer stats: $e');
      // Return default stats on error
      return AnswerStats(
        total: 0,
        correct: 0,
        incorrect: 0,
        accuracy: 0.0,
        totalXP: 0,
      );
    }
  }

  /// Get history for a specific question
  Future<QuestionStats> getQuestionStats(String questionId) async {
    try {
      final response = await _apiClient.get('/answer-history/question/$questionId');
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        return QuestionStats.fromJson(data['data']);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      debugPrint('Error fetching question stats: $e');
      rethrow;
    }
  }

  /// Get my incorrect answers (for review)
  Future<List<AnswerHistory>> getIncorrectAnswers() async {
    try {
      final response = await _apiClient.get('/answer-history/incorrect');

      // Handle 401 Unauthorized - user not logged in
      if (response.statusCode == 401) {
        debugPrint('User not authenticated for incorrect answers');
        return [];
      }

      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        final List<dynamic> historyJson = data['data'];
        return historyJson.map((json) => AnswerHistory.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching incorrect answers: $e');
      // Return empty list on error instead of throwing
      return [];
    }
  }

  /// Record an answer (public endpoint - no auth required)
  Future<AnswerHistory> recordAnswer(RecordAnswerDto dto) async {
    try {
      final response = await _apiClient.post(
        '/answer-history/record',
        body: dto.toJson(),
      );
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        return AnswerHistory.fromJson(data['data']);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      debugPrint('Error recording answer: $e');
      rethrow;
    }
  }
}
