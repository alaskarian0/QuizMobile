import '../api/api_client.dart';
import '../models/category.dart';

/// Category service
class CategoryService {
  final ApiClient _apiClient;

  CategoryService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiClient.get('/categories');
      final data = _apiClient.handleResponse(response);

      // Handle both direct array and wrapped response
      if (data is Map && data.containsKey('data')) {
        final List<dynamic> categoriesJson = data['data'];
        return categoriesJson.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
      }

      return (data as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get category by ID
  Future<Category> getCategoryById(String id) async {
    try {
      final response = await _apiClient.get('/categories/$id');
      final data = _apiClient.handleResponse(response);
      return Category.fromJson(data as Map<String, dynamic>);
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
