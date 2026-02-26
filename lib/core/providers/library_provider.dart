import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library.dart';
import '../services/library_service.dart';

/// Library Service provider
final libraryServiceProvider = Provider<LibraryService>((ref) {
  return LibraryService();
});

// ==================== ARTICLES ====================

/// Articles provider
final articlesProvider =
    FutureProvider.autoDispose<List<Article>>((ref) async {
  final libraryService = ref.watch(libraryServiceProvider);
  return await libraryService.getArticles();
});

/// Articles by category provider
final articlesByCategoryProvider =
    FutureProvider.family.autoDispose<List<Article>, String>((ref, category) async {
  final libraryService = ref.watch(libraryServiceProvider);
  return await libraryService.getArticles(category: category);
});

// ==================== LESSONS ====================

/// Lessons provider
final lessonsProvider =
    FutureProvider.autoDispose<List<Lesson>>((ref) async {
  final libraryService = ref.watch(libraryServiceProvider);
  return await libraryService.getLessons();
});

/// Lessons by category provider
final lessonsByCategoryProvider =
    FutureProvider.family.autoDispose<List<Lesson>, String>((ref, category) async {
  final libraryService = ref.watch(libraryServiceProvider);
  return await libraryService.getLessons(category: category);
});

/// Lessons by level provider
final lessonsByLevelProvider =
    FutureProvider.family.autoDispose<List<Lesson>, String>((ref, level) async {
  final libraryService = ref.watch(libraryServiceProvider);
  return await libraryService.getLessons(level: level);
});

// ==================== PODCASTS ====================

/// Podcasts provider
final podcastsProvider =
    FutureProvider.autoDispose<List<Podcast>>((ref) async {
  final libraryService = ref.watch(libraryServiceProvider);
  return await libraryService.getPodcasts();
});

/// Podcasts by category provider
final podcastsByCategoryProvider =
    FutureProvider.family.autoDispose<List<Podcast>, String>((ref, category) async {
  final libraryService = ref.watch(libraryServiceProvider);
  return await libraryService.getPodcasts(category: category);
});

// ==================== E-BOOKS ====================

/// E-Books provider
final ebooksProvider =
    FutureProvider.autoDispose<List<EBook>>((ref) async {
  final libraryService = ref.watch(libraryServiceProvider);
  return await libraryService.getEBooks();
});

/// E-Books by category provider
final ebooksByCategoryProvider =
    FutureProvider.family.autoDispose<List<EBook>, String>((ref, category) async {
  final libraryService = ref.watch(libraryServiceProvider);
  return await libraryService.getEBooks(category: category);
});
