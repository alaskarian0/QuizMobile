import '../api/api_client.dart';
import '../models/user.dart';

/// Achievement service
class AchievementService {
  final ApiClient _apiClient;

  AchievementService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get all achievements
  Future<List<Achievement>> getAchievements({
    String? type,
    String? category,
  }) async {
    try {
      String queryParams = '';
      if (type != null) {
        queryParams += '?type=$type';
        if (category != null) {
          queryParams += '&category=$category';
        }
      } else if (category != null) {
        queryParams += '?category=$category';
      }

      final response = await _apiClient.get('/achievements$queryParams');
      final data = _apiClient.handleResponse(response);

      // Handle both array and object with data property
      List<dynamic> achievementsList;
      if (data is Map && data.containsKey('data')) {
        achievementsList = data['data'] as List;
      } else {
        achievementsList = data as List;
      }

      return achievementsList
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get user's achievements with progress
  Future<List<Achievement>> getMyAchievements() async {
    try {
      final response = await _apiClient.get('/achievements/my-achievements');
      final data = _apiClient.handleResponse(response);

      List<dynamic> achievementsList;
      if (data is Map && data.containsKey('data')) {
        achievementsList = data['data'] as List;
      } else {
        achievementsList = data as List;
      }

      return achievementsList
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get user achievement stats
  Future<Map<String, dynamic>> getMyStats() async {
    try {
      final response = await _apiClient.get('/achievements/my-achievements/stats');
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        return data['data'] as Map<String, dynamic>;
      }
      return data as Map<String, dynamic>;
    } catch (e) {
      return {
        'total': 0,
        'completed': 0,
        'inProgress': 0,
        'totalXpEarned': 0,
      };
    }
  }

  /// Check and update achievement progress
  Future<Map<String, dynamic>?> checkAndUpdateProgress({
    required String type,
    String? category,
    int? value,
  }) async {
    try {
      final response = await _apiClient.post(
        '/achievements/check-and-update',
        body: {
          'type': type,
          if (category != null) 'category': category,
          if (value != null) 'value': value,
        },
      );
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        return data['data'] as Map<String, dynamic>;
      }
      return data as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
}
