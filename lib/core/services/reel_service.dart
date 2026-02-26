import 'dart:convert';
import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/reel.dart';

/// Service for Reel API operations
class ReelService {
  final ApiClient _apiClient;

  ReelService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get all reels
  Future<List<Reel>> getAllReels() async {
    try {
      final response = await _apiClient.get('/reels');
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        final List<dynamic> reelsJson = data['data'];
        return reelsJson.map((json) => Reel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching reels: $e');
      rethrow;
    }
  }

  /// Get active reels (not expired)
  Future<List<Reel>> getActiveReels() async {
    try {
      final response = await _apiClient.get('/reels/active');
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        final List<dynamic> reelsJson = data['data'];
        return reelsJson.map((json) => Reel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching active reels: $e');
      rethrow;
    }
  }

  /// Get reels by user ID
  Future<List<Reel>> getReelsByUser(String userId) async {
    try {
      final response = await _apiClient.get('/reels/user/$userId');
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        final List<dynamic> reelsJson = data['data'];
        return reelsJson.map((json) => Reel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching user reels: $e');
      rethrow;
    }
  }

  /// Get my reels (authenticated user's reels)
  Future<List<Reel>> getMyReels() async {
    try {
      final response = await _apiClient.get('/reels/my-reels');
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        final List<dynamic> reelsJson = data['data'];
        return reelsJson.map((json) => Reel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching my reels: $e');
      rethrow;
    }
  }

  /// Create a new reel
  Future<Reel> createReel(CreateReelDto dto) async {
    try {
      final response = await _apiClient.post(
        '/reels',
        body: dto.toJson(),
      );
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        return Reel.fromJson(data['data']);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      debugPrint('Error creating reel: $e');
      rethrow;
    }
  }

  /// Update a reel
  Future<Reel> updateReel(String id, UpdateReelDto dto) async {
    try {
      final response = await _apiClient.patch(
        '/reels/$id',
        body: dto.toJson(),
      );
      final data = _apiClient.handleResponse(response);

      if (data is Map && data.containsKey('data')) {
        return Reel.fromJson(data['data']);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      debugPrint('Error updating reel: $e');
      rethrow;
    }
  }

  /// Increment reel views
  Future<void> incrementViews(String id) async {
    try {
      final response = await _apiClient.patch('/reels/$id/view');
      _apiClient.handleResponse(response);
    } catch (e) {
      debugPrint('Error incrementing views: $e');
      rethrow;
    }
  }

  /// Delete a reel
  Future<void> deleteReel(String id) async {
    try {
      final response = await _apiClient.delete('/reels/$id');
      _apiClient.handleResponse(response);
    } catch (e) {
      debugPrint('Error deleting reel: $e');
      rethrow;
    }
  }
}
