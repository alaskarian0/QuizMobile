import '../api/api_client.dart';
import '../models/user.dart';

/// Badge service
class BadgeService {
  final ApiClient _apiClient;

  BadgeService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get all badges
  Future<List<Badge>> getBadges() async {
    try {
      final response = await _apiClient.get('/badges');
      final data = _apiClient.handleResponse(response);
      return (data as List)
          .map((e) => Badge.fromJson(e as Map<String, dynamic>))
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
