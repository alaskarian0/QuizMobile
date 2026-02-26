import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/category_service.dart';

/// Category Service provider
final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryService();
});

/// Categories State
class CategoriesState {
  final List<Category> categories;
  final bool isLoading;
  final String? error;

  CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoriesState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Categories Notifier
class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final CategoryService _categoryService;

  CategoriesNotifier(this._categoryService) : super(CategoriesState()) {
    loadCategories();
  }

  /// Load categories
  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final categories = await _categoryService.getCategories();
      state = CategoriesState(
        categories: categories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Refresh categories
  Future<void> refresh() => loadCategories();
}

/// Categories State Provider
final categoriesStateProvider = StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  final categoryService = ref.watch(categoryServiceProvider);
  return CategoriesNotifier(categoryService);
});

/// Categories list provider
final categoriesProvider = Provider<List<Category>>((ref) {
  return ref.watch(categoriesStateProvider).categories;
});

/// Category by ID provider
final categoryByIdProvider = Provider.family<Category?, String>((ref, id) {
  final categories = ref.watch(categoriesProvider);
  try {
    return categories.firstWhere((c) => c.id == id);
  } catch (e) {
    return null;
  }
});

/// Category with stages provider
final categoryWithStagesProvider = FutureProvider.family<Category, String>((ref, id) async {
  final categoryService = ref.watch(categoryServiceProvider);
  return await categoryService.getCategoryById(id);
});

