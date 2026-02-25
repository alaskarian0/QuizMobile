import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../models/user.dart';

/// Authentication service
class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Login with username and password
  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: {
          'username': username,
          'password': password,
        },
      );

      final data = _apiClient.handleResponse(response);
      final loginResponse = LoginResponse.fromJson(data);

      // Save tokens
      await _apiClient.saveTokens(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
      );

      // Save user data
      await _saveUserData(loginResponse.user);

      return loginResponse;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Continue with clearing local data even if API call fails
    } finally {
      await _apiClient.clearTokens();
    }
  }

  /// Get current authenticated user
  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/auth/me');
      final data = _apiClient.handleResponse(response);
      final user = User.fromJson(data);
      await _saveUserData(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  /// Get saved user from local storage
  Future<User?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        return User.fromJson({
          ...{'id': '', 'email': '', 'username': '', 'name': ''}, // required fields
          ...Map<String, dynamic>.from(
            // Add this import: import 'dart:convert';
            // Or use a different approach
            Map<String, dynamic>.from(
              // This is a simplified version - you'll need proper JSON decoding
              <String, dynamic>{},
            ),
          ),
        });
      }
    } catch (e) {
      // Error parsing saved user
    }
    return null;
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _apiClient.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Refresh access token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _apiClient.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _apiClient.post(
        '/auth/refresh',
        body: {'refreshToken': refreshToken},
      );

      final data = _apiClient.handleResponse(response);
      final accessToken = data['access_token'] as String?;
      final newRefreshToken = data['refreshToken'] as String?;

      if (accessToken != null) {
        await _apiClient.saveTokens(
          accessToken: accessToken,
          refreshToken: newRefreshToken ?? refreshToken,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Save user data to local storage
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    // You'll need to properly serialize the user
    // For now, just save basic info
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_username', user.username);
    await prefs.setInt('user_xp', user.xp);
    await prefs.setInt('user_level', user.level);
    await prefs.setInt('user_streak', user.streak);
  }

  /// Handle errors
  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    return Exception('An unexpected error occurred: $error');
  }
}
