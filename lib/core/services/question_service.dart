import '../api/api_client.dart';
import '../models/question.dart';

/// Question service
class QuestionService {
  final ApiClient _apiClient;

  QuestionService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get questions with optional filters
  Future<List<Question>> getQuestions({
    String? categoryId,
    QuestionDifficulty? difficulty,
  }) async {
    try {
      final queryParams = <String, String>{
        if (categoryId != null) 'categoryId': categoryId,
        if (difficulty != null) 'difficulty': difficulty.value,
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final endpoint = queryString.isEmpty
          ? '/questions'
          : '/questions?$queryString';

      final response = await _apiClient.get(endpoint);
      final data = _apiClient.handleResponse(response);
      return (data as List)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get daily question
  Future<DailyQuestion?> getDailyQuestion() async {
    try {
      final response = await _apiClient.get('/questions/daily');
      final data = _apiClient.handleResponse(response);
      return DailyQuestion.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get question stats
  Future<QuestionStats?> getQuestionStats() async {
    try {
      final response = await _apiClient.get('/questions/stats');
      final data = _apiClient.handleResponse(response);
      return QuestionStats.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get question by ID
  Future<Question> getQuestionById(String id) async {
    try {
      final response = await _apiClient.get('/questions/$id');
      final data = _apiClient.handleResponse(response);
      return Question.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
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
