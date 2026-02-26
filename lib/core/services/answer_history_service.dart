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
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        final List<dynamic> historyJson = data['data'];
        return historyJson.map((json) => AnswerHistory.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching answer history: $e');
      rethrow;
    }
  }

  /// Get my answer statistics
  Future<AnswerStats> getMyStats() async {
    try {
      final response = await _apiClient.get('/answer-history/stats');
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        return AnswerStats.fromJson(data['data']);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      debugPrint('Error fetching answer stats: $e');
      rethrow;
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
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        final List<dynamic> historyJson = data['data'];
        return historyJson.map((json) => AnswerHistory.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching incorrect answers: $e');
      rethrow;
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
