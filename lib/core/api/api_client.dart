import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// API Client for making HTTP requests to the backend
class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({
    this.baseUrl = 'http://localhost:3001/api',
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Get the stored access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// Get the stored refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  /// Save tokens to storage
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    if (refreshToken != null) {
      await prefs.setString('refresh_token', refreshToken);
    }
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');
  }

  /// Make a GET request
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final token = await getAccessToken();
    final requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final response = await _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: requestHeaders,
    );

    // Try to refresh token on 401
    if (response.statusCode == 401 && token != null) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        return get(endpoint, headers: headers);
      }
      // If refresh failed, try once more without token (for public endpoints)
      final publicHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };
      return _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: publicHeaders,
      );
    }

    return response;
  }

  /// Make a POST request
  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final token = await getAccessToken();
    final requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final response = await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: requestHeaders,
      body: body != null ? jsonEncode(body) : null,
    );

    // Try to refresh token on 401
    if (response.statusCode == 401 && token != null) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        return post(endpoint, headers: headers, body: body);
      }
      // If refresh failed, try once more without token (for public endpoints)
      final publicHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };
      return _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: publicHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    }

    return response;
  }

  /// Make a PATCH request
  Future<http.Response> patch(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final token = await getAccessToken();
    final requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final response = await _client.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: requestHeaders,
      body: body != null ? jsonEncode(body) : null,
    );

    // Try to refresh token on 401
    if (response.statusCode == 401 && token != null) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        return patch(endpoint, headers: headers, body: body);
      }
      // If refresh failed, try once more without token (for public endpoints)
      final publicHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };
      return _client.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: publicHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    }

    return response;
  }

  /// Make a DELETE request
  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final token = await getAccessToken();
    final requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final response = await _client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: requestHeaders,
    );

    // Try to refresh token on 401
    if (response.statusCode == 401 && token != null) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        return delete(endpoint, headers: headers);
      }
      // If refresh failed, try once more without token (for public endpoints)
      final publicHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };
      return _client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: publicHeaders,
      );
    }

    return response;
  }

  /// Attempt to refresh the access token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        // No refresh token, clear expired access token
        await clearTokens();
        return false;
      }

      final response = await _client.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['access_token'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;

        if (accessToken != null) {
          await saveTokens(
            accessToken: accessToken,
            refreshToken: newRefreshToken ?? refreshToken,
          );
          return true;
        }
      }

      // If we get here, refresh failed
      await clearTokens();
      return false;
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      // Clear tokens on any error
      await clearTokens();
      return false;
    }
  }

  /// Handle API response
  dynamic handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw BadRequestException(jsonDecode(response.body)['message'] ?? 'Bad request');
      case 401:
        throw UnauthorizedException('Unauthorized');
      case 403:
        throw ForbiddenException('Forbidden');
      case 404:
        throw NotFoundException('Resource not found');
      case 500:
        throw ServerException('Internal server error');
      default:
        throw ApiException(
          'Unexpected error: ${response.statusCode}',
          response.statusCode,
        );
    }
  }
}

// Custom exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class ServerException extends ApiException {
  ServerException(super.message);
}
