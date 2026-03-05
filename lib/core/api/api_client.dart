import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// API Client for making HTTP requests to the backend
class ApiClient {
  final String baseUrl;
  final http.Client _client;

  factory ApiClient({
    String? baseUrl,
    http.Client? client,
  }) {
    // If no baseUrl provided, determine the appropriate one based on platform
    final effectiveBaseUrl = baseUrl ?? _getDefaultBaseUrl();
    return ApiClient._(effectiveBaseUrl, client ?? http.Client());
  }

  /// Private constructor
  ApiClient._(this.baseUrl, this._client);

  /// Get the default base URL based on the platform
  static String _getDefaultBaseUrl() {
    // Check if running on web
    if (kIsWeb) {
      return 'http://localhost:3001/api';
    }

    // For development, use emulator-accessible URLs
    // Android emulator uses 10.0.2.2 to reach host machine
    // iOS simulator can use localhost
    if (Platform.isAndroid) {
      // If using physical device, change this to your machine's local IP (e.g. 192.168.0.183)
      return 'http://10.0.2.2:3001/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:3001/api';
    }

    // For other platforms, use localhost
    return 'http://localhost:3001/api';
  }

  /// Normalizes a URL for proper image loading.
  ///
  /// This function handles several cases:
  /// 1. Full URLs (http://, https://) - returned as-is
  /// 2. Relative paths (/uploads/images/...) - prefixed with base URL
  /// 3. localhost URLs - replaced with appropriate host for emulators
  /// 4. 127.0.0.1 URLs - replaced with appropriate host for emulators
  static String normalizeUrl(String? url, String currentBaseUrl) {
    if (url == null || url.isEmpty) return '';

    // If it's already a full URL with http/https, return as-is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // Handle relative paths - prepend with base URL (without /api suffix)
    if (url.startsWith('/')) {
      try {
        final baseUri = Uri.parse(currentBaseUrl);
        // Remove /api from the path if present
        final path = baseUri.path.replaceAll('/api', '');
        return '${baseUri.scheme}://${baseUri.host}:${baseUri.port}$path$url';
      } catch (e) {
        // Fallback: return as-is
        return url;
      }
    }

    // Handle localhost or 127.0.0.1 in URLs
    if (url.contains('localhost') || url.contains('127.0.0.1')) {
      try {
        final baseUri = Uri.parse(currentBaseUrl);
        final host = baseUri.host;
        final port = baseUri.port;

        // Replace localhost/127.0.0.1 with the host from baseUrl
        return url
            .replaceAll('localhost', host)
            .replaceAll('127.0.0.1', host)
            .replaceAll(RegExp(r':\d+'), ':$port');
      } catch (e) {
        // Fallback: replace with common emulator IP if parsing fails
        return url
            .replaceAll('localhost', '10.0.2.2')
            .replaceAll('127.0.0.1', '10.0.2.2');
      }
    }

    return url;
  }

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

    final response = await _client
        .get(Uri.parse('$baseUrl$endpoint'), headers: requestHeaders)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 401 && token != null) {
      final refreshed = await _refreshToken();
      if (refreshed) return get(endpoint, headers: headers);
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

    final response = await _client
        .post(
          Uri.parse('$baseUrl$endpoint'),
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 401 && token != null) {
      final refreshed = await _refreshToken();
      if (refreshed) return post(endpoint, headers: headers, body: body);
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

    final response = await _client
        .patch(
          Uri.parse('$baseUrl$endpoint'),
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 401 && token != null) {
      final refreshed = await _refreshToken();
      if (refreshed) return patch(endpoint, headers: headers, body: body);
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

    final response = await _client
        .delete(Uri.parse('$baseUrl$endpoint'), headers: requestHeaders)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 401 && token != null) {
      final refreshed = await _refreshToken();
      if (refreshed) return delete(endpoint, headers: headers);
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

  /// Handle API response — unwraps NestJS {success, data} envelope
  dynamic handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        final decoded = jsonDecode(response.body);
        // Unwrap NestJS envelope: { success: true, data: {...} }
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          return decoded['data'];
        }
        return decoded;
      case 204:
        return null;
      case 400:
        final body = _tryDecode(response.body);
        final msg = body?['message'] ?? 'طلب غير صحيح';
        throw BadRequestException(msg is List ? msg.join(', ') : msg.toString());
      case 401:
        throw UnauthorizedException('غير مصرح');
      case 403:
        throw ForbiddenException('ممنوع');
      case 404:
        throw NotFoundException('المورد غير موجود');
      case 500:
        throw ServerException('خطأ في الخادم');
      default:
        throw ApiException('خطأ غير متوقع: ${response.statusCode}', response.statusCode);
    }
  }

  Map<String, dynamic>? _tryDecode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>?;
    } catch (_) {
      return null;
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
