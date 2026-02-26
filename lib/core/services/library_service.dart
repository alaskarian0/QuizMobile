import '../api/api_client.dart';
import '../models/library.dart';

/// Library service
class LibraryService {
  final ApiClient _apiClient;

  LibraryService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  // ==================== ARTICLES ====================

  /// Get all articles
  Future<List<Article>> getArticles({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      String queryParams = '?page=$page&limit=$limit';
      if (category != null) {
        queryParams += '&category=$category';
      }

      final response = await _apiClient.get('/library/articles$queryParams');
      final data = _apiClient.handleResponse(response);

      List<dynamic> articlesList;
      if (data is Map && data.containsKey('data')) {
        articlesList = data['data'] as List;
      } else {
        articlesList = data as List;
      }

      return articlesList
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get single article
  Future<Article?> getArticle(String id) async {
    try {
      final response = await _apiClient.get('/library/articles/$id');
      final data = _apiClient.handleResponse(response);
      return Article.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Like article (requires auth)
  Future<bool> likeArticle(String id) async {
    try {
      final response = await _apiClient.get('/library/articles/$id/like');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ==================== LESSONS ====================

  /// Get all lessons
  Future<List<Lesson>> getLessons({
    String? category,
    String? level,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      String queryParams = '?page=$page&limit=$limit';
      if (category != null) {
        queryParams += '&category=$category';
      }
      if (level != null) {
        queryParams += '&level=$level';
      }

      final response = await _apiClient.get('/library/lessons$queryParams');
      final data = _apiClient.handleResponse(response);

      List<dynamic> lessonsList;
      if (data is Map && data.containsKey('data')) {
        lessonsList = data['data'] as List;
      } else {
        lessonsList = data as List;
      }

      return lessonsList
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get single lesson
  Future<Lesson?> getLesson(String id) async {
    try {
      final response = await _apiClient.get('/library/lessons/$id');
      final data = _apiClient.handleResponse(response);
      return Lesson.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // ==================== PODCASTS ====================

  /// Get all podcasts
  Future<List<Podcast>> getPodcasts({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      String queryParams = '?page=$page&limit=$limit';
      if (category != null) {
        queryParams += '&category=$category';
      }

      final response = await _apiClient.get('/library/podcasts$queryParams');
      final data = _apiClient.handleResponse(response);

      List<dynamic> podcastsList;
      if (data is Map && data.containsKey('data')) {
        podcastsList = data['data'] as List;
      } else {
        podcastsList = data as List;
      }

      return podcastsList
          .map((e) => Podcast.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get single podcast
  Future<Podcast?> getPodcast(String id) async {
    try {
      final response = await _apiClient.get('/library/podcasts/$id');
      final data = _apiClient.handleResponse(response);
      return Podcast.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // ==================== E-BOOKS ====================

  /// Get all E-Books
  Future<List<EBook>> getEBooks({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      String queryParams = '?page=$page&limit=$limit';
      if (category != null) {
        queryParams += '&category=$category';
      }

      final response = await _apiClient.get('/library/ebooks$queryParams');
      final data = _apiClient.handleResponse(response);

      List<dynamic> ebooksList;
      if (data is Map && data.containsKey('data')) {
        ebooksList = data['data'] as List;
      } else {
        ebooksList = data as List;
      }

      return ebooksList
          .map((e) => EBook.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get single E-Book
  Future<EBook?> getEBook(String id) async {
    try {
      final response = await _apiClient.get('/library/ebooks/$id');
      final data = _apiClient.handleResponse(response);
      return EBook.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }
}
