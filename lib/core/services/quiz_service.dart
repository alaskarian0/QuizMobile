import '../api/api_client.dart';
import '../models/quiz.dart';

/// Quiz service
class QuizService {
  final ApiClient _apiClient;

  QuizService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get daily quiz
  Future<Quiz?> getDailyQuiz() async {
    try {
      final response = await _apiClient.get('/quizzes/daily');
      final data = _apiClient.handleResponse(response);
      return Quiz.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get quiz by ID
  Future<Quiz> getQuizById(String id) async {
    try {
      final response = await _apiClient.get('/quizzes/$id');
      final data = _apiClient.handleResponse(response);
      return Quiz.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Start a quiz session
  Future<QuizSession?> startQuiz(String quizId, {String? categoryId}) async {
    try {
      final response = await _apiClient.post(
        '/quizzes/$quizId/start',
        body: {
          if (categoryId != null) 'categoryId': categoryId,
        },
      );
      final data = _apiClient.handleResponse(response);
      return QuizSession.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Submit quiz answers
  Future<QuizResult?> submitQuiz(
    String quizId, {
    required List<int> answers,
    required int timeSpent,
  }) async {
    try {
      final response = await _apiClient.post(
        '/quizzes/$quizId/submit',
        body: {
          'answers': answers,
          'timeSpent': timeSpent,
        },
      );
      final data = _apiClient.handleResponse(response);
      return QuizResult.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get quiz history
  Future<List<QuizHistoryItem>> getQuizHistory({int page = 1}) async {
    try {
      final response = await _apiClient.get('/quizzes/history?page=$page');
      final data = _apiClient.handleResponse(response);
      final history = data['history'] as List? ?? [];
      return history
          .map((e) => QuizHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Handle errors
  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    return Exception('An unexpected error occurred: $error');
  }
}
