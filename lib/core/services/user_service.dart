import '../api/api_client.dart';
import '../models/user.dart';

/// User service
class UserService {
  final ApiClient _apiClient;

  UserService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/users/me');
      final data = _apiClient.handleResponse(response);
      return User.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get current user stats
  Future<UserStats?> getCurrentUserStats() async {
    try {
      final response = await _apiClient.get('/users/me/stats');
      final data = _apiClient.handleResponse(response);
      return UserStats.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get current user's rank
  Future<Map<String, dynamic>?> getCurrentUserRank() async {
    try {
      final response = await _apiClient.get('/users/me/rank');
      final data = _apiClient.handleResponse(response);
      return {
        'rank': data['rank'] as int? ?? 0,
        'totalUsers': data['totalUsers'] as int? ?? 0,
        'percentile': data['percentile'] as int? ?? 0,
      };
    } catch (e) {
      return null;
    }
  }

  /// Update current user profile
  Future<User> updateProfile({
    String? name,
    String? avatar,
  }) async {
    try {
      final body = <String, dynamic>{
        if (name != null) 'name': name,
        if (avatar != null) 'avatar': avatar,
      };

      final response = await _apiClient.patch('/users/me', body: body);
      final data = _apiClient.handleResponse(response);
      return User.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get leaderboard
  Future<List<LeaderboardEntry>> getLeaderboard({
    int limit = 10,
    String period = 'all',
  }) async {
    try {
      final response = await _apiClient.get(
        '/users/leaderboard?limit=$limit&period=$period',
      );
      final data = _apiClient.handleResponse(response);
      final leaderboard = data['leaderboard'] as List? ?? [];
      return leaderboard
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
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
